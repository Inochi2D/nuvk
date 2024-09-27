/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.device;
import nuvk.core.vk.internal.queuemanager;
import nuvk.core.vk;
import nuvk.core;
import nuvk.spirv;
import numem.all;

private {
    const const(char)*[] nuvkVkDeviceRequiredExtensions = [
        "VK_EXT_vertex_input_dynamic_state",
        "VK_EXT_extended_dynamic_state",
        "VK_EXT_extended_dynamic_state2",
        "VK_KHR_create_renderpass2",
        "VK_KHR_depth_stencil_resolve",
        "VK_KHR_dynamic_rendering",
        "VK_EXT_custom_border_color",
        "VK_KHR_swapchain",
        NuvkVkMemorySharingExtName,
        NuvkVkSemaphoreSharingExtName,
    ];
}

/**
    A vulkan device
*/
class NuvkVkDevice : NuvkDevice {
@nogc:
private:
    // Vulkan
    VkDevice device;

    // Queues
    NuvkCommandQueue transferQueue;
    NuvkVkDeviceQueueManager queueManager;
    

    void createDevice() {

        // Sets up the queue manager first
        queueManager = nogc_new!NuvkVkDeviceQueueManager(this);

        VkPhysicalDeviceFeatures2 features2;

        auto physicalDevice = cast(VkPhysicalDevice)this.getDeviceInfo().getHandle();
        auto queueCreateInfos = queueManager.getVkQueueCreateInfos();


        // Device features
        {
            vkGetPhysicalDeviceFeatures2(physicalDevice, &features2);


            VkPhysicalDeviceDynamicRenderingFeatures dynamicRenderingFeatures;
            VkPhysicalDeviceVertexInputDynamicStateFeaturesEXT vertexInputDynamicStateFeature;
            VkPhysicalDeviceExtendedDynamicStateFeaturesEXT extendedDynamicStateFeature;
            VkPhysicalDeviceExtendedDynamicState2FeaturesEXT extendedDynamicState2Feature;
            VkPhysicalDeviceCustomBorderColorFeaturesEXT customBorderColorFeature;

            extendedDynamicStateFeature.extendedDynamicState = VK_TRUE;
            extendedDynamicState2Feature.extendedDynamicState2 = VK_TRUE;
            customBorderColorFeature.customBorderColors = VK_TRUE;

            dynamicRenderingFeatures.dynamicRendering = VK_TRUE;
            vertexInputDynamicStateFeature.vertexInputDynamicState = VK_TRUE;

            extendedDynamicState2Feature.pNext = &customBorderColorFeature;
            extendedDynamicStateFeature.pNext = &extendedDynamicState2Feature;
            vertexInputDynamicStateFeature.pNext = &extendedDynamicStateFeature;
            dynamicRenderingFeatures.pNext = &vertexInputDynamicStateFeature;
            features2.pNext = &dynamicRenderingFeatures;
        }

        VkDeviceCreateInfo deviceCreateInfo;
        deviceCreateInfo.queueCreateInfoCount = cast(uint)queueCreateInfos.length;
        deviceCreateInfo.pQueueCreateInfos = queueCreateInfos.ptr;

        deviceCreateInfo.enabledExtensionCount = cast(uint)nuvkVkDeviceRequiredExtensions.length;
        deviceCreateInfo.ppEnabledExtensionNames = cast(const(char*)*)nuvkVkDeviceRequiredExtensions.ptr;

        deviceCreateInfo.pNext = &features2;

	    enforce(
            vkCreateDevice(physicalDevice, &deviceCreateInfo, null, &device) == VK_SUCCESS, 
            nstring("Device creation failed!")
        );

        this.setHandle(device);
    }

public:
    this(NuvkContext owner, NuvkDeviceInfo info) {
        super(owner, info);
        this.createDevice();
    }

    /**
        Creates a shader program
    */
    override
    NuvkShader createShader(NuvkSpirvModule module_, NuvkShaderStage stage) {
        return nogc_new!NuvkVkShader(this, module_, stage);
    }

    /**
        Creates a buffer
    */
    override
    NuvkBuffer createBuffer(NuvkBufferUsage usage, NuvkDeviceSharing sharing, uint size, NuvkProcessSharing processSharing) {
        return nogc_new!NuvkVkBuffer(this, usage, sharing, size, processSharing);
    }

    /**
        Creates a texture
    */
    override
    NuvkTexture createTexture(NuvkTextureDescriptor descriptor, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal) {
        return nogc_new!NuvkVkTexture(this, descriptor, processSharing);
    }
    
    /**
        Creates a sampler
    */
    override
    NuvkSampler createSampler(NuvkSamplerDescriptor descriptor) {
        return nogc_new!NuvkVkSampler(this, descriptor);
    }

    /**
        Creates a fence.
    */
    override
    NuvkFence createFence() {
        return nogc_new!NuvkVkFence(this);
    }

    /**
        Creates a semaphore.
    */
    override
    NuvkSemaphore createSemaphore(NuvkProcessSharing processSharing) {
        return nogc_new!NuvkVkSemaphore(this, processSharing);
    }

    /**
        Creates a graphics pipeline.
    */
    override
    NuvkPipeline createGraphicsPipeline(ref NuvkGraphicsPipelineDescriptor pipelineCreationInfo) {
        return nogc_new!NuvkVkPipeline(this, pipelineCreationInfo);
    }

    /**
        Creates a compute pipeline.
    */
    override
    NuvkPipeline createComputePipeline(ref NuvkComputePipelineDescriptor pipelineCreationInfo) {
        return null;
    }

    /**
        Creates a new command queue
    */
    override
    NuvkCommandQueue createQueue(NuvkQueueSpecialization specialiation) {
        return queueManager.createQueue(specialiation);
    }

    /**
        Creates a new command queue
    */
    override
    void destroyQueue(NuvkCommandQueue queue) {
        queueManager.removeQueue(cast(NuvkVkCommandQueue)queue);
    }

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    override
    NuvkSurface createSurfaceFromHandle(void* handle, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat) {
        return nogc_new!NuvkVkSurface(this, presentMode, textureFormat, cast(VkSurfaceKHR)handle);
    }

    /**
        Gets queue family properties
    */
    VkQueueFamilyProperties[] getQueueFamilyProperties() {
        auto deviceInfo = (cast(NuvkVkDeviceInfo)this.getDeviceInfo());
        return deviceInfo.getQueueFamilyProperties();
    }
}