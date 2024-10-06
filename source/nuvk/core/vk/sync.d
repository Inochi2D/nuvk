/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.sync;
import nuvk.core.vk;
import nuvk.core;
import numem.all;

/**
    A fence
*/
class NuvkVkFence : NuvkFence {
@nogc:
private:
    VkFence fence;

    void createFence() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkExportSemaphoreCreateInfo exportInfo;

        VkFenceCreateInfo fenceInfo;
        fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;
        
        nuvkEnforce(
            vkCreateFence(device, &fenceInfo, null, &fence) == VK_SUCCESS,
            "Failed creating a fence"
        );

        this.setHandle(fence);
    }

public:
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (fence != VK_NULL_HANDLE)
            vkDestroyFence(device, fence, null);
    }

    this(NuvkDevice device) {
        super(device);
        this.createFence();
    }

    override
    bool isSignaled() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        return vkGetFenceStatus(device, fence) == VK_SUCCESS;
    }

    override
    void await(ulong timeout) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        vkWaitForFences(device, 1, &fence, VK_TRUE, timeout);
    }

    override
    void reset() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        vkResetFences(device, 1, &fence);
    }
}

/**
    A semaphore
*/
class NuvkVkSemaphore : NuvkSemaphore {
@nogc:
private:
    VkSemaphore semaphore;
    ulong shareHandle;

    void createSemaphore(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (processSharing == NuvkProcessSharing.processShared) {

            // Export info
            VkExportSemaphoreCreateInfo exportInfo;
            exportInfo.handleTypes = NuvkVkSemaphoreSharingFlagBit;

            // Semaphore info
            VkSemaphoreCreateInfo semaphoreInfo;
            semaphoreInfo.pNext = &exportInfo;

            nuvkEnforce(
                vkCreateSemaphore(device, &semaphoreInfo, null, &semaphore) == VK_SUCCESS,
                "Failed creating a semaphore"
            );

            this.setHandle(semaphore);
            shareHandle = nuvkVkGetSharedHandle(device, semaphore);
        } else {
            // Semaphore info
            VkSemaphoreCreateInfo semaphoreInfo;
            
            nuvkEnforce(
                vkCreateSemaphore(device, &semaphoreInfo, null, &semaphore) == VK_SUCCESS,
                "Failed creating a semaphore"
            );

            this.setHandle(semaphore);
        }
    }

public:
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (shareHandle != 0) 
            nuvkVkCloseSharedHandle(shareHandle);

        if (semaphore != VK_NULL_HANDLE)
            vkDestroySemaphore(device, semaphore, null);
    }

    this(NuvkDevice device, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.createSemaphore(processSharing);
    }

    override
    ulong getSharedHandle() {
        return shareHandle;
    }
}