module nuvk.core.vk.queue;
import nuvk.core.vk;
import nuvk.core;
import numem.all;

import core.stdc.stdio : printf;

private {
    
    // Used doing suitability testing
    struct NuvkVkQueueFamilyCandidate {
        uint familyIndex;
        VkQueueFamilyProperties props;
    }
}

VkQueueFlags toVkQueueFlags(NuvkCommandQueueKind kind) @nogc {
    final switch(kind) {
        case NuvkCommandQueueKind.render:
            return VK_QUEUE_GRAPHICS_BIT;
        case NuvkCommandQueueKind.compute:
            return VK_QUEUE_COMPUTE_BIT;
        case NuvkCommandQueueKind.transfer:
            return VK_QUEUE_TRANSFER_BIT;
    }
}

/**
    A vulkan command queue
*/
class NuvkVkCommandQueue : NuvkCommandQueue {
@nogc:
private:
    NuvkVkQueueFamilyCandidate queueFamily; 
    VkQueue queue;
    VkCommandPool commandPool;

    // Gets the most suitable queue
    bool getMostSuitableQueue(NuvkCommandQueueKind kind, ref NuvkVkQueueFamilyCandidate dest) {
        auto vkdevice = cast(NuvkVkDevice)this.getOwner();
        auto queueInfos = vkdevice.getQueueFamilyProperties();
        auto targetFlag = kind.toVkQueueFlags();

        weak_vector!NuvkVkQueueFamilyCandidate candidates;

        // Find candidates
        foreach(idx, queueInfo; queueInfos[]) {
            if (queueInfo.queueFlags & targetFlag) {
                candidates ~= NuvkVkQueueFamilyCandidate(cast(uint)idx, queueInfo);
            }
        }

        if (candidates.size() > 0) {

            // Iterate candidates to find the most specialized.
            auto winningCandidate = candidates[0];
            foreach(queueInfo; candidates[]) {

                // Queue is specialized for this operation, choose that.
                if (queueInfo.props.queueFlags == targetFlag) {
                    winningCandidate = queueInfo;
                }
            }

            // Just choose the first supported one, then.
            dest = winningCandidate;
            nogc_delete(candidates);
            return true;
        }

        nogc_delete(candidates);
        return false;
    }

    void createQueue(NuvkCommandQueueKind kind) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        NuvkVkQueueFamilyCandidate queueInfo;
        enforce(
            this.getMostSuitableQueue(kind, queueInfo),
            nstring("Could not find suitable queue for requested kind.")    
        );

        vkGetDeviceQueue(device, queueInfo.familyIndex, 0, &queue);
        enforce(
            queue != VK_NULL_HANDLE,
            nstring("Failed creating queue!")
        );

        queueFamily = queueInfo;

        this.setHandle(queue);
    }

    void createCommandPool() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkCommandPoolCreateInfo commandPoolInfo;
        commandPoolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        commandPoolInfo.queueFamilyIndex = queueFamily.familyIndex;

        enforce(
            vkCreateCommandPool(device, &commandPoolInfo, null, &commandPool) == VK_SUCCESS,
            nstring("Failed creating command pool!")
        );
    }

public:
    /**
        Destructor
    */
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (commandPool != VK_NULL_HANDLE)
            vkDestroyCommandPool(device, commandPool, null);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkCommandQueueKind kind) {
        super(device, kind);
        this.createQueue(kind);
        this.createCommandPool();
    }

    /**
        Waits for a fence to be signaled
    */
    override
    void awaitFence(NuvkFence fence) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        vkWaitForFences(device, 1, cast(const(VkFence)*)(&fence.getHandle()), VK_TRUE, ulong.max);
    }
    
    /**
        Enqueues a sempahore wait
    */
    override
    void awaitSemaphore(NuvkSemaphore semaphore) {
        
        VkSubmitInfo submitInfo;
        submitInfo.waitSemaphoreCount = 1;
        submitInfo.pWaitSemaphores = cast(const(VkSemaphore)*)(&semaphore.getHandle());

        vkQueueSubmit(queue, 1, &submitInfo, VK_NULL_HANDLE);
    }

    /**
        Enqueues a fence signaling
    */
    override
    void signalFence(NuvkFence fence) {
        vkQueueSubmit(queue, 0, null, cast(VkFence)fence.getHandle());
    }
    
    /**
        Enqueues a sempahore signaling
    */
    override
    void signalSemaphore(NuvkSemaphore semaphore) {
        VkSubmitInfo submitInfo;
        submitInfo.signalSemaphoreCount = 1;
        submitInfo.pSignalSemaphores = cast(const(VkSemaphore)*)(&semaphore.getHandle());

        vkQueueSubmit(queue, 1, &submitInfo, VK_NULL_HANDLE);
    }

    /**
        Creates a command buffer
    */
    override
    NuvkCommandBuffer createCommandBuffer() {
        return nogc_new!NuvkVkCommandBuffer(this.getOwner(), this, commandPool);   
    }

    /**
        Waits on the queue items to finish executing.
    */
    override
    void await() {
        vkQueueWaitIdle(queue);
    }
}