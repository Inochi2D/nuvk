/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.queue;
import nuvk.core.vk;
import nuvk.core;
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
    this(NuvkDevice device, VkQueue queue, NuvkQueueFamilyInfo queueInfo, uint index) {
        super(device, queueInfo, index);
        this.queue = queue;
        this.setHandle(queue);
        this.createCommandPool();
    }

    /**
        Creates a command buffer
    */
    override
    NuvkCommandBuffer createCommandBuffer() {
        return nogc_new!NuvkCommandBufferVk(this.getOwner(), this);   
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