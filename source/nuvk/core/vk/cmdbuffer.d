/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.cmdbuffer;
import nuvk.core.vk;
import nuvk.core;
import numem.all;
import inmath;

/**
    Converts winding to vulkan front face
*/
VkFrontFace toVkFrontFace(NuvkWinding winding) @nogc {
    final switch(winding) {
        case NuvkWinding.clockwise:
            return VK_FRONT_FACE_CLOCKWISE;
        case NuvkWinding.counterClockwise:
            return VK_FRONT_FACE_COUNTER_CLOCKWISE;
    }
}

/**
    Converts winding to vulkan front face
*/
VkCullModeFlagBits toVkCulling(NuvkCulling culling) @nogc {
    final switch(culling) {
        case NuvkCulling.frontFace:
            return VK_CULL_MODE_FRONT_BIT;
        case NuvkCulling.backFace:
            return VK_CULL_MODE_BACK_BIT;
        case NuvkCulling.none:
            return VK_CULL_MODE_NONE;
    }
}

/**
    Command buffer
*/
class NuvkVkCommandBuffer : NuvkCommandBuffer {
@nogc:
private:
    weak_vector!VkCommandBuffer commandBuffers;

    VkCommandBuffer createCommandBuffer() {
        VkCommandBuffer commandBuffer;
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkCommandQueue)this.getQueue()).getCommandPool();

        VkCommandBufferAllocateInfo commandBufferInfo;
        commandBufferInfo.commandPool = pool;
        commandBufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        commandBufferInfo.commandBufferCount = 1;

        enforce(
            vkAllocateCommandBuffers(device, &commandBufferInfo, &commandBuffer) == VK_SUCCESS,
            nstring("Failed to allocate command buffer")
        );

        return commandBuffer;
    }

    void freeCommandBuffers() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkCommandQueue)this.getOwner()).getCommandPool();

        if (commandBuffers.size() > 0)
            vkFreeCommandBuffers(device, pool, cast(uint)commandBuffers.size(), commandBuffers.data());
    }

protected:


    /**
        Implements the logic to create a NuvkRenderEncoder.
    */
    override
    NuvkRenderEncoder onBeginRenderPass() {
        return null;
    }

    /**
        Implements the logic to create a NuvkComputeEncoder.
    */
    override
    NuvkComputeEncoder onBeginComputePass() {
        return null;
    }

    /**
        Implements the logic to create a NuvkTransferEncoder.
    */
    override
    NuvkTransferEncoder onBeginTransferPass() {
        return null;
    }

public:

    ~this() {
        this.freeCommandBuffers();
    }

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkCommandQueue queue) {
        super(device, queue);
    }

    /**
        Resets the command buffer.

        This allows reusing the command buffer between frames.
    */
    override
    bool reset() {

        this.freeCommandBuffers();
        return true;
    }

    /**
        Presents the surface
    */
    override
    void present(NuvkSurface surface) {
        VkPresentInfoKHR presentInfo;

        vkQueuePresentKHR(cast(VkQueue)this.getQueue().getHandle(), &presentInfo);
    }

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    override
    void commit() {
        // auto device = cast(VkDevice)this.getOwner().getHandle();
        // auto pool = (cast(NuvkVkCommandQueue)this.getOwner()).getCommandPool();
        // auto queue = cast(VkQueue)this.getQueue().getHandle();
    }

    /**
        Blocks the current thread until the command queue
        is finished rendering the buffer.
    */
    override
    void awaitCompletion() {
        auto queue = cast(VkQueue)this.getQueue().getHandle();
        vkQueueWaitIdle(queue);
    }
}

