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
        
        enforce(
            vkCreateFence(device, &fenceInfo, null, &fence) == VK_SUCCESS,
            nstring("Failed creating a fence")
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
}

/**
    A semaphore
*/
class NuvkVkSemaphore : NuvkSemaphore {
@nogc:
private:
    VkSemaphore semaphore;

    void createSemaphore(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (processSharing == NuvkProcessSharing.processShared) {

            // Export info
            VkExportSemaphoreCreateInfo exportInfo;
            exportInfo.handleTypes = NuvkVkSemaphoreSharingFlagBit;

            // Semaphore info
            VkSemaphoreCreateInfo semaphoreInfo;
            semaphoreInfo.pNext = &exportInfo;

            enforce(
                vkCreateSemaphore(device, &semaphoreInfo, null, &semaphore) == VK_SUCCESS,
                nstring("Failed creating a semaphore")
            );

            this.setHandle(semaphore);
            this.setSharedHandle(nuvkVkGetSharedHandle(device, semaphore));
        } else {
            // Semaphore info
            VkSemaphoreCreateInfo semaphoreInfo;
            
            enforce(
                vkCreateSemaphore(device, &semaphoreInfo, null, &semaphore) == VK_SUCCESS,
                nstring("Failed creating a semaphore")
            );

            this.setHandle(semaphore);
        }
    }

protected:

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    override
    void onShareHandleClose(ulong handle) {
        nuvkVkCloseSharedHandle(handle);
    }

public:
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (semaphore != VK_NULL_HANDLE)
            vkDestroySemaphore(device, semaphore, null);
    }

    this(NuvkDevice device, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.createSemaphore(processSharing);
    }
}