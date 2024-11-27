/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.internal.vulkan.queue;
import nuvk.context;
static if (NuvkHasVulkan):

import nuvk.internal.vulkan;
import nuvk.core;
import nuvk.queue;
import nuvk.device;
import nuvk.cmdbuffer;
import nuvk.surface;
import nuvk.sync;
import numem.all;

import core.stdc.stdio : printf;


NuvkQueueSpecialization toNuvkSpecialization(VkQueueFlags flags) @nogc {
    uint oFlags = 0;

    if (flags & VK_QUEUE_COMPUTE_BIT)
        oFlags |= NuvkQueueSpecialization.compute;

    if (flags & VK_QUEUE_GRAPHICS_BIT)
        oFlags |= NuvkQueueSpecialization.graphics;

    if (flags & VK_QUEUE_TRANSFER_BIT)
        oFlags |= NuvkQueueSpecialization.transfer;

    return cast(NuvkQueueSpecialization)oFlags;
}

/**
    A vulkan command queue
*/
class NuvkQueueVk : NuvkQueue {
@nogc:
private:
    VkQueue queue;
    VkCommandPool commandPool;
    uint queueFamilyIndex;

    void createCommandPool() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkCommandPoolCreateInfo commandPoolInfo;
        commandPoolInfo.queueFamilyIndex = this.getFamilyInfo().index;

        nuvkEnforce(
            vkCreateCommandPool(device, &commandPoolInfo, null, &commandPool) == VK_SUCCESS,
            "Failed creating command pool!"
        );
    }

    NuvkSemaphore cSemaphore;
protected:

    /**
        Trims the command queue freeing any unsued memory.
    */
    override
    void onTrim() {
        auto device = this.getOwner().getHandle!VkDevice();
        vkTrimCommandPool(device, this.commandPool, 0);
    }

    /**
        Called when a submission is requested for a range of command buffers.

        This may be called multiple times a frame to optimally submit elements.
    */
    override
    void onSubmit(NuvkCommandBuffer buffer) {
        VkSubmitInfo submitInfo;
        VkPipelineStageFlags pSemaphoreStage = VK_PIPELINE_STAGE_ALL_COMMANDS_BIT;

        // Previous semaphore
        auto pSemaphore = cSemaphore;
        auto pSemaphoreHandle = pSemaphore ? pSemaphore.getHandle!VkSemaphore : VK_NULL_HANDLE;
        if (pSemaphore) {
            submitInfo.waitSemaphoreCount = 1;
            submitInfo.pWaitDstStageMask = &pSemaphoreStage;
            submitInfo.pWaitSemaphores = &pSemaphoreHandle;
        }

        // TODO: Add resource tracking to determine when
        // a semaphore is neccesary,

        // Current semaphore
        cSemaphore = buffer.getSubmissionSemaphore();
        auto cSemaphoreHandle = cSemaphore.getHandle!VkSemaphore;

        // Buffer handles        
        auto bufferHandle = buffer.getHandle!VkCommandBuffer;
        auto bufferFenceHandle = buffer.getInFlightFence().getHandle!VkFence;

        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = &bufferHandle;
        submitInfo.signalSemaphoreCount = 1;
        submitInfo.pSignalSemaphores = &cSemaphoreHandle;
        vkQueueSubmit(queue, 1, &submitInfo, bufferFenceHandle);
    }

    /**
        Called when a submission is requested for a surface swap.

        This may be called multiple times a frame to optimally submit elements.
    */
    override
    void onSubmit(NuvkSurface surface) {
        auto cSemaphoreHandle = cSemaphore.getHandle!VkSemaphore;
        auto swapchain = (cast(NuvkSwapchainVk)surface.getSwapchain());
        auto swapchainHandle = cast(VkSwapchainKHR)swapchain.getHandle();
        uint index = swapchain.getCurrentImageIndex();


        VkPresentInfoKHR presentInfo;
        presentInfo.swapchainCount = 1;
        presentInfo.pSwapchains = &swapchainHandle;
        presentInfo.pImageIndices = &index;
        presentInfo.waitSemaphoreCount = 1;
        presentInfo.pWaitSemaphores = &cSemaphoreHandle;
        vkQueuePresentKHR(queue, &presentInfo);
    }

    override
    void onSubmitCompleted() {
        cSemaphore = null;
    }

    /**
        Called when a command buffer is enqueued.
    */
    override
    void onEnqueue(NuvkCommandBuffer toEnqueue) {

    }
    
    /**
        Creates a command buffer
    */
    override
    NuvkCommandBuffer onCreateCommandBuffer() {
        return nogc_new!NuvkCommandBufferVk(this);   
    }

    /**
        Gets the next buffer handle for the queue.

        returns null if no handle could be obtained.
    */
    override
    NuvkHandle onNextBufferHandle() {
        auto device = this.getOwner().getHandle!VkDevice();
        VkCommandBuffer bufferHandle = VK_NULL_HANDLE;

        VkCommandBufferAllocateInfo commandBufferInfo;
        commandBufferInfo.commandPool = commandPool;
        commandBufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        commandBufferInfo.commandBufferCount = 1;

        if (vkAllocateCommandBuffers(device, &commandBufferInfo, &bufferHandle) == VK_SUCCESS) 
            return cast(NuvkHandle)bufferHandle;

        return null;
    }

    /**
        Called when a handle is requested to be freed.
    */
    override
    void onFreeBufferHandle(NuvkHandle handle) {
        auto device = this.getOwner().getHandle!VkDevice();
        vkFreeCommandBuffers(device, commandPool, 1, cast(VkCommandBuffer*)&handle);
    }

public:
    /**
        Destructor
    */
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (commandPool)
            vkDestroyCommandPool(device, commandPool, null);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, VkQueue queue, NuvkQueueFamilyInfo queueInfo, uint index, uint count) {
        super(device, queueInfo, index, count);

        this.queue = queue;
        this.setHandle(queue);
        this.createCommandPool();
    }

    /**
        Waits on the queue items to finish executing.
    */
    override
    void await() {
        vkQueueWaitIdle(queue);
    }

    /**
        Gets the command pool
    */
    final
    VkCommandPool getCommandPool() {
        return commandPool;
    }
}