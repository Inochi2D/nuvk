/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.device;
import nuvk.core.vk.internal.queuemanager;
import nuvk.core.vk.internal.stagingbuffer;
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
    NuvkQueue transferQueue;
    NuvkVkDeviceQueueManager queueManager;

    // Staging buffer
    NuvkVkStagingBuffer stagingBuffer;
    

    void createDevice() {

        // Sets up the queue manager first
        queueManager = nogc_new!NuvkVkDeviceQueueManager(this);

        VkPhysicalDeviceFeatures2 features2;
        VkPhysicalDeviceVulkan11Features vk11Features;
        VkPhysicalDeviceVulkan12Features vk12Features;
        VkPhysicalDeviceVulkan13Features vk13Features;
        VkPhysicalDeviceCustomBorderColorFeaturesEXT customBorderColorFeature;
        VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT topologyRestartFeature;
        VkPhysicalDeviceExtendedDynamicState3FeaturesEXT dynamicState3Feature;

        auto physicalDevice = cast(VkPhysicalDevice)this.getDeviceInfo().getHandle();
        auto queueCreateInfos = queueManager.getVkQueueCreateInfos();


        // Device features
        {
            topologyRestartFeature.pNext = &dynamicState3Feature;
            customBorderColorFeature.pNext = &topologyRestartFeature;
            vk11Features.pNext = &customBorderColorFeature;
            vk12Features.pNext = &vk11Features;
            vk13Features.pNext = &vk12Features;
            features2.pNext = &vk13Features;

            vkGetPhysicalDeviceFeatures2(physicalDevice, &features2);

        }

        VkDeviceCreateInfo deviceCreateInfo;
        deviceCreateInfo.queueCreateInfoCount = cast(uint)queueCreateInfos.length;
        deviceCreateInfo.pQueueCreateInfos = queueCreateInfos.ptr;

        deviceCreateInfo.enabledExtensionCount = cast(uint)nuvkVkDeviceRequiredExtensions.length;
        deviceCreateInfo.ppEnabledExtensionNames = cast(const(char*)*)nuvkVkDeviceRequiredExtensions.ptr;

        deviceCreateInfo.pNext = &features2;

        // Debug info
        debug {
            import core.stdc.stdio : printf;

            foreach(i, extension; deviceCreateInfo.ppEnabledExtensionNames[0..deviceCreateInfo.enabledExtensionCount]) {
                printf("[Nuvk::Vulkan] device extension[%d] = %s\n", cast(uint)i, extension);
            }
        }

	    nuvkEnforce(
            vkCreateDevice(physicalDevice, &deviceCreateInfo, null, &device) == VK_SUCCESS, 
            "Device creation failed!"
        );

        this.setHandle(device);
    }

    void createTransferQueue() {
        transferQueue = queueManager.createQueue(NuvkQueueSpecialization.transfer);
    }

public:

    /**
        Destructor
    */
    ~this() {
        if (transferQueue)
            nogc_delete(transferQueue);
        
        if (queueManager)
            nogc_delete(queueManager);
        
        if (stagingBuffer)
            nogc_delete(stagingBuffer);

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
        this.createTransferQueue();
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
        nuvkEnforce(
            queue !is transferQueue,
            "Attempted to delete queue owned by device."
        );
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

    /**
        Gets the queue used for transfers internally.

        You generally don't want to touch this.
    */
    final
    NuvkQueue getInternalTransferQueue() {
        return transferQueue;
    }

    /**
        Gets the staging buffer for the device.
    */
    final
    NuvkVkStagingBuffer getStagingBuffer() {
        return stagingBuffer;
    }
}