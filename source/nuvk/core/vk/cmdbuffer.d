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
        Resets the command buffer; allowing the buffer to be re-recorded.
    */
    override
    bool reset() {
        if (this.getStatus() != NuvkCommandBufferStatus.completed)
            return false;
        return vkResetCommandBuffer(commandBuffer, 0) == VK_SUCCESS;
    }

    /**
        Begins recording into the command buffer
    */
    override
    bool begin() {
        if (this.getStatus() != NuvkCommandBufferStatus.idle)
            return false;

        VkCommandBufferBeginInfo beginInfo;
        bool success = vkBeginCommandBuffer(commandBuffer, &beginInfo) == VK_SUCCESS;
        if (success) {
            this.setStatus(NuvkCommandBufferStatus.recording);
        }

        return success;
    }

    /**
        Ends recording into the command buffer
    */
    override
    bool end() {
        if (this.getStatus() != NuvkCommandBufferStatus.recording)
            return false;
        
        bool success = vkEndCommandBuffer(commandBuffer) == VK_SUCCESS;
        if (success) {
            this.setStatus(NuvkCommandBufferStatus.recording);
        }
        return success;
    }

    /**
        Configures the command buffer to use the specified pipeline
    */
    override
    void setPipeline(NuvkPipeline pipeline) {
        vkCmdBindPipeline(commandBuffer, pipeline.getPipelineKind().toVkPipelineBindPoint(), cast(VkPipeline)pipeline.getHandle());
    }

    /**
        Sets the vertex buffer being used for rendering.
    */
    override
    void setVertexBuffer(NuvkBuffer vertexBuffer, uint offset, uint stride, uint index) {
        VkDeviceSize vkoffset = offset;
        VkDeviceSize vkstride = stride;
        VkBuffer buffer = cast(VkBuffer)vertexBuffer.getHandle();
        vkCmdBindVertexBuffers2(
            commandBuffer,
            index,
            1,
            &buffer,
            &vkoffset,
            null,
            &vkstride
        );
    }

    /**
        Sets the index buffer being used for rendering.
    */
    override
    void setIndexBuffer(NuvkBuffer indexBuffer, uint offset, NuvkBufferIndexType indexType) {
        vkCmdBindIndexBuffer(
            commandBuffer,
            cast(VkBuffer)indexBuffer.getHandle(),
            cast(VkDeviceSize)offset,
            indexType.toVkIndexType()
        );
    }

    /**
        Configures what winding is used for the front face for rendering
    */
    override
    void setFrontFace(NuvkWinding winding) {
        vkCmdSetFrontFace(commandBuffer, winding.toVkFrontFace());
    }

    /**
        Configures the culling mode used for rendering
    */
    override
    void setCulling(NuvkCulling culling) {
        vkCmdSetCullMode(commandBuffer, culling.toVkCulling());
    }

    /**
        Configures the viewport
    */
    override
    void setViewport(rect viewport) {
        VkViewport vkviewport;
        vkviewport.x = viewport.x;
        vkviewport.y = viewport.y;
        vkviewport.width = viewport.width;
        vkviewport.height = viewport.height;
        vkviewport.minDepth = 0;
        vkviewport.maxDepth = 1;
        vkCmdSetViewport(commandBuffer, 0, 1, &vkviewport);
    }

    /**
        Configures the scissor rectangle
    */
    override
    void setScissorRect(rect scissor) {
        VkRect2D scissorRect;
        scissorRect.offset.x = cast(int)scissor.x;
        scissorRect.offset.y = cast(int)scissor.y;
        scissorRect.extent.width = cast(int)scissor.width;
        scissorRect.extent.height = cast(int)scissor.height;
        vkCmdSetScissor(commandBuffer, 0, 1, &scissorRect);
    }

    /**
        Sets the store action for the specified color
    */
    override
    void setColorStoreAction(NuvkStoreAction action, uint color) {
        
    }

    /**
        Sets the store action for the stencil buffer
    */
    override
    void setStencilStoreAction(NuvkStoreAction action) {
        
    }

    /**
        Sets the store action for the depth buffer
    */
    override
    void setDepthStoreAction(NuvkStoreAction action) {
        
    }

    /**
        Sets the color for the constant blend color blending mode.
    */
    override
    void setBlendColor(float r, float g, float b,float a) {
        float[4] colors;
        colors[0] = r;
        colors[1] = g;
        colors[2] = b;
        colors[3] = a;
        vkCmdSetBlendConstants(commandBuffer, colors);
    }

    /**
        Draws a primitive
    */
    override
    void draw(NuvkPrimitive primitive, uint start, uint count) {
        vkCmdDraw(commandBuffer, count, 0, start, 0);
    }

    /**
        Draws a primitive using bound index buffers
    */
    override
    void drawIndexed(NuvkPrimitive primitive, uint start, uint count) {
        vkCmdDrawIndexed(commandBuffer, count, 0, start, 0, 0);
    }

    /**
        Submit the current contents of the command buffer
        into the command queue the buffer was created from.
    */
    override
    void submit(NuvkFence signalFence) {
        auto queue = cast(VkQueue)this.getQueue().getHandle();
        VkSubmitInfo submitInfo;
        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = &commandBuffer;

        VkFence fence = signalFence ? 
            cast(VkFence)signalFence.getHandle() : 
            VK_NULL_HANDLE;

        enforce(
            vkQueueSubmit(queue, 1, &submitInfo, fence),
            nstring("Failed to submit command buffer!")
        );
    }
}

