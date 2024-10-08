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
        "VK_EXT_primitive_topology_list_restart",
        "VK_EXT_custom_border_color",
        "VK_KHR_swapchain",
        "VK_EXT_extended_dynamic_state3",
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
    NuvkVkDeviceQueueManager queueManager;

    void createDevice() {

        // Sets up the queue manager first
        queueManager = nogc_new!NuvkVkDeviceQueueManager(this);

        NuvkVkDeviceInfo deviceInfo = cast(NuvkVkDeviceInfo)this.getDeviceInfo();
        auto physicalDevice         = cast(VkPhysicalDevice)deviceInfo.getHandle();
        auto queueCreateInfos       = queueManager.getVkQueueCreateInfos();

        VkDeviceCreateInfo deviceCreateInfo;

        deviceCreateInfo.queueCreateInfoCount       = cast(uint)queueCreateInfos.length;
        deviceCreateInfo.pQueueCreateInfos          = queueCreateInfos.ptr;
        deviceCreateInfo.enabledExtensionCount      = cast(uint)nuvkVkDeviceRequiredExtensions.length;
        deviceCreateInfo.ppEnabledExtensionNames    = cast(const(char*)*)nuvkVkDeviceRequiredExtensions.ptr;
        deviceCreateInfo.pNext                      = deviceInfo.getFeatureChain().getFirst();

        foreach(i, extension; deviceCreateInfo.ppEnabledExtensionNames[0..deviceCreateInfo.enabledExtensionCount])
            nuvkLogDebug("device extensions[%d] = %s", cast(uint)i, extension);
        
	    nuvkEnforce(
            vkCreateDevice(physicalDevice, &deviceCreateInfo, null, &device) == VK_SUCCESS, 
            "Device creation failed!"
        );

        this.setHandle(device);
    }

public:

    /**
        Destructor
    */
    ~this() {
        if (queueManager)
            nogc_delete(queueManager);

        // Destroy device
        if (device != VK_NULL_HANDLE)
            vkDestroyDevice(device, null);
    }

    /**
        Constructor
    */
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
    NuvkBuffer createBuffer(NuvkBufferUsage usage, uint size, NuvkProcessSharing processSharing) {
        return nogc_new!NuvkVkBuffer(this, usage, size, processSharing);
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
    NuvkQueue createQueue(NuvkQueueSpecialization specialiation) {
        return queueManager.createQueue(specialiation);
    }

    /**
        Waits for all queues to be idle.
    */
    override
    void awaitAll() {
        vkDeviceWaitIdle(device);
    }

    /**
        Creates a new command queue
    */
    override
    void destroyQueue(NuvkQueue queue) {
        queueManager.removeQueue(cast(NuvkVkQueue)queue);
    }

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    override
    NuvkSurface createSurfaceFromHandle(void* handle, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat) {
        return nogc_new!NuvkVkSurface(this, presentMode, textureFormat, cast(VkSurfaceKHR)handle);
    }
}