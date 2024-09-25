module nuvk.core.vk.device;
import nuvk.core.vk;
import nuvk.core;
import nuvk.spirv;
import numem.all;

private {
    const float nuvkVkDeviceQueuePriority = 1.0f;
    
    const const(char)*[] nuvkVkDeviceRequiredExtensions = [
        "VK_EXT_vertex_input_dynamic_state",
        "VK_EXT_extended_dynamic_state",
        "VK_EXT_extended_dynamic_state2",
        "VK_KHR_swapchain",
        "VK_KHR_dynamic_rendering",
        "VK_EXT_custom_border_color",
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
    VkDevice device;
    weak_vector!VkDeviceQueueCreateInfo queueInfos;

    void createDevice() {
    	VkPhysicalDeviceFeatures features;
        VkPhysicalDeviceFeatures2 features2;

        auto physicalDevice = cast(VkPhysicalDevice)this.getDeviceInfo().getHandle();


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
        deviceCreateInfo.queueCreateInfoCount = cast(uint)queueInfos.size();
        deviceCreateInfo.pQueueCreateInfos = queueInfos.data();
        deviceCreateInfo.pEnabledFeatures = &features;

        deviceCreateInfo.enabledExtensionCount = cast(uint)nuvkVkDeviceRequiredExtensions.length;
        deviceCreateInfo.ppEnabledExtensionNames = cast(const(char*)*)nuvkVkDeviceRequiredExtensions.ptr;

        deviceCreateInfo.pNext = &features2;

	    enforce(
            vkCreateDevice(physicalDevice, &deviceCreateInfo, null, &device) == VK_SUCCESS, 
            nstring("Device creation failed!")
        );

        this.setHandle(device);
    }

    void initDeviceQueueInfos() {
        auto deviceInfo = (cast(NuvkVkDeviceInfo)this.getDeviceInfo());
        auto queueFamilies = deviceInfo.getQueueFamilyProperties();

        foreach(i, family; queueFamilies) {
            VkDeviceQueueCreateInfo queueCreateInfo;
            queueCreateInfo.queueFamilyIndex = cast(uint)i;
            queueCreateInfo.queueCount = 1;
            queueCreateInfo.pQueuePriorities = &nuvkVkDeviceQueuePriority;

            queueInfos ~= queueCreateInfo;
        }
    }

public:
    this(NuvkContext owner, NuvkDeviceInfo info) {
        super(owner, info);
        this.initDeviceQueueInfos();
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
    NuvkCommandQueue createQueue(NuvkCommandQueueKind kind) {
        return nogc_new!NuvkVkCommandQueue(this, kind);
    }

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    override
    NuvkSurface createSurfaceFromHandle(void* handle) {
        return nogc_new!NuvkVkSurface(this, cast(VkSurfaceKHR)handle);
    }

    /**
        Gets queue family properties
    */
    VkQueueFamilyProperties[] getQueueFamilyProperties() {
        auto deviceInfo = (cast(NuvkVkDeviceInfo)this.getDeviceInfo());
        return deviceInfo.getQueueFamilyProperties();
    }
}