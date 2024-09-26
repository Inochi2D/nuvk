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
    VkCommandBuffer commandBuffer;

    void createCommandBuffer() {
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
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkCommandQueue)this.getOwner()).getCommandPool();

        if (commandBuffer != VK_NULL_HANDLE)
            vkFreeCommandBuffers(device, pool, 1, &commandBuffer);
    }

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkCommandQueue queue) {
        super(device, queue);
        this.createCommandBuffer();
    }

    /**
        Resets the command buffer.

        This allows reusing the command buffer between frames.
    */
    override
    bool reset() {
        return true;
    }

    /**
        Presents the surface
    */
    override
    void present(NuvkSurface surface) {
        
    }

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    override
    void commit() {
        
    }

    /**
        Blocks the current thread until the command queue
        is finished rendering the buffer.
    */
    override
    void awaitCompletion() {

    }
}

