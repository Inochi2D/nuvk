module nuvk.core.vk.devinfo;
import nuvk.core.vk.internal.utils;
import nuvk.core.vk;
import nuvk.core;

import numem.all;
import std.path;

private {
    const const(char)*[] nuvkVkDeviceRequiredExtensions = [
        VK_EXT_PRIMITIVE_TOPOLOGY_LIST_RESTART_EXTENSION_NAME,
        VK_EXT_CUSTOM_BORDER_COLOR_EXTENSION_NAME,
        VK_KHR_SWAPCHAIN_EXTENSION_NAME,
        VK_EXT_EXTENDED_DYNAMIC_STATE_3_EXTENSION_NAME,
        VK_EXT_SHADER_OBJECT_EXTENSION_NAME,
    ];

    const const(char)*[] nuvkVkDeviceOptionalExtensions = [
        VK_EXT_SHADER_TILE_IMAGE_EXTENSION_NAME,
        VK_KHR_EXTERNAL_MEMORY_EXTENSION_NAME,
        NuvkVkMemorySharingExtName,
        VK_KHR_EXTERNAL_SEMAPHORE_EXTENSION_NAME,
        NuvkSemaphoreVkSharingExtName,
    ];
}

/**
    Converts vulkan physical device type to a nuvk type.
*/
NuvkDeviceType toNuvkDeviceType(VkPhysicalDeviceType type) @nogc {
    switch(type) {
        default:
            return NuvkDeviceType.integratedGPU;
        
        case VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
            return  NuvkDeviceType.dedicatedGPU;
    }
}

/**
    Information about a device
*/
class NuvkDeviceVkInfo : NuvkDeviceInfo {
@nogc:
private:

    // Device information
    NuvkDeviceType deviceType;
    vector!NuvkQueueFamilyInfo queues;
    NuvkDeviceFeatures features;
    NuvkDeviceLimits limits;
    nstring deviceName;

    // Vulkan-specifics
    bool supportsVk13;
    bool supportsRequiredFeatures;
    VkPhysicalDevice physicalDevice;
    vector!VkMemoryType memoryTypes;
    vector!VkMemoryHeap memoryHeaps;
    NuvkVkStructChain featureChain;
    NuvkVkRequestList extensions;

    // Enforces that a reported vulkan feature is actually supported.
    void enforceFeature(VkBool32 featureFlag) {
        if (featureFlag == VK_FALSE)
            this.supportsRequiredFeatures = false;
    }

    vector!nstring enumerateExtensions() {
        vector!nstring supportedExtensionStrings;
        vector!VkExtensionProperties supportedExtensions = nuvkVkDeviceGetAllExtensions(physicalDevice);

        foreach(ref extension; supportedExtensions) {
            supportedExtensionStrings ~= nstring(extension.extensionName.ptr);
        }
        return supportedExtensionStrings;
    }

    void addIfSupported(T)(T feature, const(char)* name) if (isVkStruct!T) {
        if (extensions.isSupported(name))
            featureChain.add(feature);
    }

    void enumerateFeatures() {
        VkPhysicalDeviceMemoryProperties physicalDeviceMemoryProperties;
        VkPhysicalDeviceProperties deviceProperties;
        vkGetPhysicalDeviceMemoryProperties(physicalDevice, &physicalDeviceMemoryProperties);
        vkGetPhysicalDeviceProperties(physicalDevice, &deviceProperties);

        this.deviceName = nstring(deviceProperties.deviceName.ptr);
        this.deviceType = deviceProperties.deviceType.toNuvkDeviceType();
        this.supportsVk13 = deviceProperties.apiVersion >= VK_API_VERSION_1_3;
        this.supportsRequiredFeatures = true;


        // Extensions
        {
            extensions = nogc_new!NuvkVkRequestList(this.enumerateExtensions(), "device extensions");
            extensions.addRequired(nuvkVkDeviceRequiredExtensions);

            foreach(req; nuvkVkDeviceRequiredExtensions) {
                extensions.add(cast(string)fromStringz(req));
            }

            foreach(req; nuvkVkDeviceOptionalExtensions) {
                extensions.add(cast(string)fromStringz(req));
            }

            supportsRequiredFeatures = extensions.hasRequired();
            if (!supportsRequiredFeatures)
                return;
        }

        // Features
        {
            featureChain = nogc_new!NuvkVkStructChain();

            VkPhysicalDeviceFeatures2 features2;
            VkPhysicalDeviceVulkan11Features vk11Features;
            VkPhysicalDeviceVulkan12Features vk12Features;
            VkPhysicalDeviceVulkan13Features vk13Features;
            VkPhysicalDeviceMeshShaderFeaturesEXT meshShaderFeatures;
            VkPhysicalDeviceCustomBorderColorFeaturesEXT customBorderColorFeature;
            VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT topologyRestartFeature;
            VkPhysicalDeviceExtendedDynamicState3FeaturesEXT dynamicState3Feature;
            VkPhysicalDeviceShaderObjectFeaturesEXT shaderObjectFeature;
            VkPhysicalDeviceShaderTileImageFeaturesEXT tileFeatures;
            
            VkPhysicalDeviceFeatures baseFeatures = features2.features;
            features2.pNext = &vk13Features;
            vk13Features.pNext = &vk12Features;
            vk12Features.pNext = &vk11Features;
            vk11Features.pNext = &customBorderColorFeature;
            customBorderColorFeature.pNext = &topologyRestartFeature;
            topologyRestartFeature.pNext = &dynamicState3Feature;
            dynamicState3Feature.pNext = &shaderObjectFeature;

            // Tile shading
            if (extensions.isSupported(VK_EXT_SHADER_TILE_IMAGE_EXTENSION_NAME)) {
                dynamicState3Feature.pNext = &tileFeatures;
                features.tileShading = true;
            }


            vkGetPhysicalDeviceFeatures2(physicalDevice, &features2);

            // Force disable some features.
            {
                // These are bad, mesh shaders should be used instead.
                features2.features.geometryShader = VK_FALSE;
                features2.features.tessellationShader = VK_FALSE;
            }

            // Required features.
            {
                // Vulkan 1.3
                this.enforceFeature(vk13Features.dynamicRendering);
                this.enforceFeature(vk13Features.maintenance4);

                // Vulkan 1.2
                this.enforceFeature(vk12Features.samplerMirrorClampToEdge);
                this.enforceFeature(vk12Features.descriptorBindingUniformBufferUpdateAfterBind);
                this.enforceFeature(vk12Features.descriptorBindingSampledImageUpdateAfterBind);
                this.enforceFeature(vk12Features.descriptorBindingStorageImageUpdateAfterBind);
                this.enforceFeature(vk12Features.descriptorBindingStorageBufferUpdateAfterBind);
                this.enforceFeature(vk12Features.descriptorBindingVariableDescriptorCount);
                this.enforceFeature(vk12Features.vulkanMemoryModel);
                this.enforceFeature(vk12Features.vulkanMemoryModel);
                
                // Topology restart
                this.enforceFeature(topologyRestartFeature.primitiveTopologyListRestart);
                
                // Dynamic state 3
                this.enforceFeature(dynamicState3Feature.extendedDynamicState3ColorBlendEnable);
                this.enforceFeature(dynamicState3Feature.extendedDynamicState3ColorBlendEquation);
                this.enforceFeature(dynamicState3Feature.extendedDynamicState3ColorWriteMask);
                this.enforceFeature(dynamicState3Feature.extendedDynamicState3PolygonMode);

                // Shader Objects
                this.enforceFeature(shaderObjectFeature.shaderObject);

                featureChain.add(features2);
                featureChain.add(vk11Features);
                featureChain.add(vk12Features);
                featureChain.add(vk13Features);
                featureChain.add(topologyRestartFeature);
                featureChain.add(dynamicState3Feature);
                featureChain.add(shaderObjectFeature);
                
            }

            // We failed.
            if (!this.supportsRequiredFeatures)
                return;

            // Optional extensions
            {
                this.addIfSupported(tileFeatures, VK_EXT_SHADER_TILE_IMAGE_EXTENSION_NAME);
            }

            // Custom border colors
            {
                if (customBorderColorFeature.customBorderColors) {
                    features.customBorderColors = true;

                    featureChain.add(customBorderColorFeature);
                }
            }

            // Mesh shaders
            {
                if (meshShaderFeatures.taskShader)
                    features.taskShaders = true;

                if (meshShaderFeatures.meshShader)
                    features.meshShaders = true;
                
                if (features.taskShaders && features.meshShaders)
                    featureChain.add(meshShaderFeatures);
            }

            // Base optional features
            {
                features.anisotropicFiltering   = cast(bool)baseFeatures.samplerAnisotropy;
                features.wideLines              = cast(bool)baseFeatures.wideLines;
                features.largePoints            = cast(bool)baseFeatures.largePoints;
                features.textureCompressionBC   = cast(bool)baseFeatures.textureCompressionBC;
                features.textureCompressionETC2 = cast(bool)baseFeatures.textureCompressionETC2;
                features.textureCompressionASTC = cast(bool)baseFeatures.textureCompressionASTC_LDR;

                features.hostMapBuffers         = this.hasMemoryWithFlags(VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT);
                features.hostMapCoherent        = this.hasMemoryWithFlags(VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);

                // Should be supported out of the box
                features.sharing                = extensions.isSupported(VK_KHR_EXTERNAL_MEMORY_EXTENSION_NAME);

                // TODO: Add raytracing support.
                features.raytracing             = false;
            }
        }

        // Limits
        {
            limits.maxTextureSize1D             = deviceProperties.limits.maxImageDimension1D;
            limits.maxTextureSize2D             = deviceProperties.limits.maxImageDimension2D;
            limits.maxTextureSize3D             = deviceProperties.limits.maxImageDimension3D;
            limits.maxTextureSizeCube           = deviceProperties.limits.maxImageDimensionCube;
            limits.maxTextureSlices             = deviceProperties.limits.maxImageArrayLayers;
            limits.maxFramebufferWidth          = deviceProperties.limits.maxFramebufferWidth;
            limits.maxFramebufferHeight         = deviceProperties.limits.maxFramebufferHeight;
            limits.maxColorAttachments          = deviceProperties.limits.maxColorAttachments;
            limits.maxAnisotropy                = deviceProperties.limits.maxSamplerAnisotropy;
            limits.maxLodBias                   = deviceProperties.limits.maxSamplerLodBias;
            limits.maxShaderSamplers            = deviceProperties.limits.maxDescriptorSetSamplers;
            limits.maxShaderUniformBuffers      = deviceProperties.limits.maxDescriptorSetUniformBuffers;
            limits.maxShaderStorageBuffers      = deviceProperties.limits.maxDescriptorSetStorageBuffers;
            limits.maxShaderTextures            = deviceProperties.limits.maxDescriptorSetSampledImages;
            limits.maxVertexAttributes          = deviceProperties.limits.maxVertexInputAttributes;
            limits.maxVertexBindings            = deviceProperties.limits.maxVertexInputBindings;
            limits.maxVertexOffset              = deviceProperties.limits.maxVertexInputAttributeOffset;
            limits.maxVertexStride              = deviceProperties.limits.maxVertexInputBindingStride;
            limits.maxVertexOutputs             = deviceProperties.limits.maxVertexOutputComponents;
            limits.maxFragmentInputs            = deviceProperties.limits.maxFragmentInputComponents;
            limits.maxFragmentOutputs           = deviceProperties.limits.maxFragmentOutputAttachments;
            limits.memoryAlignmentOptimal       = deviceProperties.limits.optimalBufferCopyOffsetAlignment;
            limits.memoryAlignmentMinimum       = deviceProperties.limits.nonCoherentAtomSize;
        }

        // Vulkan-specific information.
        {
            this.memoryTypes = vector!VkMemoryType(physicalDeviceMemoryProperties.memoryTypes[0..physicalDeviceMemoryProperties.memoryTypeCount]);
            this.memoryHeaps = vector!VkMemoryHeap(physicalDeviceMemoryProperties.memoryHeaps[0..physicalDeviceMemoryProperties.memoryHeapCount]);
        }

        supportsRequiredFeatures = extensions.hasRequired();
    }

    void enumerateQueues() {
        uint queueFamilyCount;
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, null);
        
        auto queueFamilyProperties = weak_vector!VkQueueFamilyProperties(queueFamilyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, queueFamilyProperties.data());

        // Enumerate queues and add them.
        foreach(i, VkQueueFamilyProperties queueFamily; queueFamilyProperties) {
            NuvkQueueFamilyInfo queueInfo;
            queueInfo.index = cast(uint)i;
            queueInfo.maxQueueCount = queueFamily.queueCount;
            queueInfo.specialization = queueFamily.queueFlags.toNuvkSpecialization();
            queueInfo.maxCommandBuffers = 0;

            // Make sure we skip queues dedicated to video encode/decode and whatever
            // else.
            if (queueInfo.specialization != NuvkQueueSpecialization.invalid)
                queues ~= queueInfo;
        }
    }

    /**
        Whether the a memory block with the specified flags exists.
    */
    bool hasMemoryWithFlags(VkMemoryPropertyFlags flagsRequired) {
        foreach(memoryType; memoryTypes) {
            if ((memoryType.propertyFlags & flagsRequired) == flagsRequired)
                return true;
        }
        return false;
    }

public:
    
    /**
        Constructor
    */
    this(VkPhysicalDevice physicalDevice) {
        this.physicalDevice = physicalDevice;
        this.setHandle(physicalDevice);

        this.enumerateFeatures();
        this.enumerateQueues();
    }

    /**
        Gets the name of the device
    */
    override
    string getDeviceName() {
        return cast(string)deviceName[];
    }

    /**
        Gets the type of the device
    */
    override
    NuvkDeviceType getDeviceType() {
        return deviceType;
    }

    /**
        Gets the device's features
    */
    override
    NuvkDeviceFeatures getDeviceFeatures() {
        return features;
    }

    /**
        Gets the device's limits
    */
    override
    NuvkDeviceLimits getDeviceLimits() {
        return limits;
    }

    /**
        Gets information about the queues that can be
        instantiated by the device.
    */
    override
    NuvkQueueFamilyInfo[] getQueueFamilyInfos() {
        return queues[];
    }

    /**
        Internal function used to discard
        devices which are not suitable for nuvk.
    */
    override
    bool isDeviceSuitable() {
		return queues.size() > 0 && supportsVk13 && supportsRequiredFeatures;
    }

    /**
        Gets the memory index matching the requested flags and bit depth.
    */
    final
    int getMatchingMemoryIndex(uint bitsRequired, VkMemoryPropertyFlags flagsRequired) {
        foreach(idx, memoryType; memoryTypes) {
            const(bool) isRequiredType = 
                (bitsRequired & (1 << idx)) != 0;
            
            const(bool) hasRequiredFlags = 
                (memoryType.propertyFlags & flagsRequired) == flagsRequired;

            if (isRequiredType && hasRequiredFlags)
                return cast(int)idx;
        }

        return -1;
    }

    /**
        Gets the vulkan extensions requested
    */
    final
    const(char)*[] getExtensionRequests() {
        return extensions.getRequests();
    }

    /**
        Gets the vulkan specific features chain.
    */
    final
    NuvkVkStructChain getFeatureChain() {
        return featureChain;
    }
}
