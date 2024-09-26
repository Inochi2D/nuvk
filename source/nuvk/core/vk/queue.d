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

/**
    A vulkan command queue
*/
class NuvkVkCommandQueue : NuvkCommandQueue {
@nogc:
private:
    VkQueue queue;
    VkCommandPool commandPool;
    uint queueFamilyIndex;

    void createCommandPool() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkCommandPoolCreateInfo commandPoolInfo;
        commandPoolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        commandPoolInfo.queueFamilyIndex = queueFamilyIndex;

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
    this(NuvkDevice device, NuvkQueueSpecialization specialization, VkQueue queue, uint queueFamilyIndex) {
        super(device, specialization);
        this.queue = queue;
        this.setHandle(queue);
        this.createCommandPool();
    }

    /**
        Creates a command buffer
    */
    override
    NuvkCommandBuffer createCommandBuffer() {
        return nogc_new!NuvkVkCommandBuffer(this.getOwner(), this);   
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