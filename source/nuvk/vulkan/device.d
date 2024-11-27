/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.internal.vulkan.device;
import nuvk.context;
static if (NuvkHasVulkan):


import nuvk.internal.vulkan.internal.queuemanager;
import nuvk.internal.vulkan;
import nuvk;
import numem.all;

/**
    A vulkan device
*/
class NuvkDeviceVk : NuvkDevice {
@nogc:
private:
    // Vulkan
    VkDevice device;

    // Queues
    NuvkDeviceVkQueueManager queueManager;

    void createDevice() {

        // Sets up the queue manager first
        queueManager = nogc_new!NuvkDeviceVkQueueManager(this);

        NuvkDeviceVkInfo deviceInfo = cast(NuvkDeviceVkInfo)this.getDeviceInfo();
        auto physicalDevice         = cast(VkPhysicalDevice)deviceInfo.getHandle();
        auto queueCreateInfos       = queueManager.getVkQueueCreateInfos();

        VkDeviceCreateInfo deviceCreateInfo;

        deviceCreateInfo.queueCreateInfoCount       = cast(uint)queueCreateInfos.length;
        deviceCreateInfo.pQueueCreateInfos          = queueCreateInfos.ptr;
        deviceCreateInfo.enabledExtensionCount      = cast(uint)deviceInfo.getExtensionRequests().length;
        deviceCreateInfo.ppEnabledExtensionNames    = cast(const(char*)*)deviceInfo.getExtensionRequests().ptr;
        deviceCreateInfo.pNext                      = deviceInfo.getFeatureChain().getFirst();

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
    NuvkShaderProgram createShader() {
        return nogc_new!NuvkShaderProgramVk(this);
    }

    /**
        Creates a shader program
    */
    override
    NuvkShaderProgram createShader(NuvkShaderLibrary library) {
        return nogc_new!NuvkShaderProgramVk(this, library);
    }

    /**
        Creates a buffer
    */
    override
    NuvkBuffer createBuffer(NuvkBufferUsage usage, uint size, NuvkProcessSharing processSharing) {
        return nogc_new!NuvkBufferVk(this, usage, size, processSharing);
    }

    /**
        Creates a texture
    */
    override
    NuvkTexture createTexture(NuvkTextureDescriptor descriptor, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal) {
        return nogc_new!NuvkTextureVk(this, descriptor, processSharing);
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
        return nogc_new!NuvkFenceVk(this);
    }

    /**
        Creates a semaphore.
    */
    override
    NuvkSemaphore createSemaphore(NuvkProcessSharing processSharing) {
        return nogc_new!NuvkSemaphoreVk(this, processSharing);
    }

    /**
        Creates a new command queue
    */
    override
    NuvkQueue createQueue(uint count, NuvkQueueSpecialization specialiation) {
        return queueManager.createQueue(count, specialiation);
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
        queueManager.removeQueue(cast(NuvkQueueVk)queue);
    }

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    override
    NuvkSurface createSurfaceFromHandle(void* handle, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat) {
        return nogc_new!NuvkSurfaceVk(this, presentMode, textureFormat, cast(VkSurfaceKHR)handle);
    }
}