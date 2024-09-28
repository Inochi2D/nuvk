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

VkPipelineStageFlags toVkPipelineStage(NuvkRenderStage renderStage, NuvkBarrierScope scope_) @nogc {
    VkPipelineStageFlags stage;
    if (scope_ == NuvkBarrierScope.renderTargets) {
        stage |= VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
    }

    if (scope_ == NuvkBarrierScope.buffers) {
        stage |= VK_PIPELINE_STAGE_VERTEX_INPUT_BIT;
    }
    
    final switch(renderStage) {

        case NuvkRenderStage.mesh:
            stage |= VK_PIPELINE_STAGE_MESH_SHADER_BIT_EXT;
            break;

        case NuvkRenderStage.vertex:
            stage |= VK_PIPELINE_STAGE_VERTEX_SHADER_BIT;
            break;

        case NuvkRenderStage.fragment:
            stage |= VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;
            break;
    }
    return stage;
}

VkAccessFlagBits getAccessFlag(bool read) {
    return read ? VK_ACCESS_MEMORY_READ_BIT : VK_ACCESS_MEMORY_WRITE_BIT;
}

/**
    Command buffer
*/
class NuvkVkCommandBuffer : NuvkCommandBuffer {
@nogc:
private:

    // Normal use command buffers
    weak_vector!VkCommandBuffer commandBuffers;

    VkCommandBuffer createCommandBuffer() {
        VkCommandBuffer bufferHandle = VK_NULL_HANDLE;

        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkCommandQueue)this.getQueue()).getCommandPool();

        VkCommandBufferAllocateInfo commandBufferInfo;
        commandBufferInfo.commandPool = pool;
        commandBufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        commandBufferInfo.commandBufferCount = 1;

        enforce(
            vkAllocateCommandBuffers(device, &commandBufferInfo, &bufferHandle) == VK_SUCCESS,
            nstring("Failed to allocate command buffer")
        );

        VkCommandBufferBeginInfo beginInfo;
        enforce(
            vkBeginCommandBuffer(bufferHandle, &beginInfo) == VK_SUCCESS,
            nstring("Failed to begin command buffer")
        );

        return bufferHandle;
    }

    void freeCommandBuffers() {

        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkCommandQueue)this.getQueue()).getCommandPool();

        if (commandBuffers.size() > 0) {
            vkFreeCommandBuffers(device, pool, cast(uint)commandBuffers.size(), commandBuffers.data());
            commandBuffers.resize(0);
        }
    }

protected:

    override
    void onBeginNewPass() {
        this.freeCommandBuffers();
    }

    /**
        Implements the logic to create a NuvkRenderEncoder.
    */
    override
    NuvkRenderEncoder onBeginRenderPass(ref NuvkRenderPassDescriptor descriptor) {
        return nogc_new!NuvkVkRenderEncoder(this, descriptor, this.createCommandBuffer());
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
        Presents the surface
    */
    override
    void present(NuvkSurface surface) {
        enforce(
            this.getStatus() == NuvkCommandBufferStatus.submitted,
            nstring("Nothing to present.")
        );

        auto nuvkswapchain = (cast(NuvkVkSwapchain)surface.getSwapchain());
        auto swapchain = cast(VkSwapchainKHR)nuvkswapchain.getHandle();
        uint index = nuvkswapchain.getCurrentImageIndex();
        auto queue = cast(VkQueue)this.getQueue().getHandle();

        auto submitFinishSemaphore = cast(VkSemaphore)this.getSubmissionFinished().getHandle();

        VkSemaphore[1] waitSemaphores = [
            submitFinishSemaphore,
        ];

        VkPresentInfoKHR presentInfo;
        presentInfo.swapchainCount = 1;
        presentInfo.pSwapchains = &swapchain;
        presentInfo.pImageIndices = &index;
        presentInfo.waitSemaphoreCount = cast(uint)waitSemaphores.length;
        presentInfo.pWaitSemaphores = waitSemaphores.ptr;
        
        if (vkQueuePresentKHR(queue, &presentInfo) == VK_ERROR_OUT_OF_DATE_KHR) {
            this.reset();
        }
    }

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    override
    void commit() {
        auto queue = cast(VkQueue)this.getQueue().getHandle();
        auto submitFinishSemaphore = cast(VkSemaphore)this.getSubmissionFinished().getHandle();
    
        VkSubmitInfo submitInfo;
        submitInfo.waitSemaphoreCount = 0;
        submitInfo.signalSemaphoreCount = 1;
        submitInfo.pSignalSemaphores = &submitFinishSemaphore;
        submitInfo.commandBufferCount = cast(uint)commandBuffers.size();
        submitInfo.pCommandBuffers = commandBuffers.data();

        this.setStatus(NuvkCommandBufferStatus.submitted);
        vkQueueSubmit(queue, 1, &submitInfo, cast(VkFence)this.getInFlightFence().getHandle());
    }
}

/**
    Gets vulkan equivalent of NuvkLoadOp
*/
VkAttachmentLoadOp toVkLoadOp(NuvkLoadOp loadOp) @nogc {
    final switch(loadOp) {
        case NuvkLoadOp.dontCare:
            return VK_ATTACHMENT_LOAD_OP_DONT_CARE;
        case NuvkLoadOp.load:
            return VK_ATTACHMENT_LOAD_OP_LOAD;
        case NuvkLoadOp.clear:
            return VK_ATTACHMENT_LOAD_OP_CLEAR;
    }
}

/**
    Gets vulkan equivalent of NuvkStoreOp
*/
VkAttachmentStoreOp toVkStoreOp(NuvkStoreOp storeOp) @nogc {
    final switch(storeOp) {

        // Normal rendering
        case NuvkStoreOp.dontCare:
            return VK_ATTACHMENT_STORE_OP_DONT_CARE;
        case NuvkStoreOp.store:
            return VK_ATTACHMENT_STORE_OP_STORE;

        // Multisample resolve
        case NuvkStoreOp.multisampleResolve:
            return VK_ATTACHMENT_STORE_OP_DONT_CARE;
        case NuvkStoreOp.storeAndMultisampleResolve:
            return VK_ATTACHMENT_STORE_OP_STORE;
    }
}

VkResolveModeFlagBits toVkResolveMode(NuvkStoreOp storeOp) @nogc {
    final switch(storeOp) {
        case NuvkStoreOp.dontCare:
        case NuvkStoreOp.store:
            return VK_RESOLVE_MODE_NONE;
        case NuvkStoreOp.multisampleResolve:
        case NuvkStoreOp.storeAndMultisampleResolve:
            return VK_RESOLVE_MODE_SAMPLE_ZERO_BIT;
    }
}

/**
    A lightweight object for submitting rendering commands
    to a command buffer.
*/
class NuvkVkRenderEncoder : NuvkRenderEncoder {
@nogc:
private:
    NuvkVkCommandBuffer parent;
    VkCommandBuffer writeBuffer;

    void beginRendering() {
        NuvkRenderPassDescriptor descriptor = this.getDescriptor();

        VkRenderingInfo renderInfo;
        renderInfo.layerCount = 1;

        weak_vector!VkImageMemoryBarrier memoryBarriers;

        weak_vector!VkRenderingAttachmentInfo colorAttachments
            = weak_vector!VkRenderingAttachmentInfo(descriptor.colorAttachments.size());
        VkRenderingAttachmentInfo depthStencilAttachment;

        // Color attachments
        {
            foreach(i; 0..descriptor.colorAttachments.size()) {
                NuvkVkTextureView nuvkTextureView = cast(NuvkVkTextureView)descriptor.colorAttachments[i].texture;
                NuvkTexture nuvkTexture = nuvkTextureView.getTexture();
                
                // Ensure that the clip area is always within valid bounds.
                descriptor.renderArea.clip(recti(0, 0, nuvkTexture.getWidth(), nuvkTexture.getHeight()));

                colorAttachments[i].imageView                   = cast(VkImageView)nuvkTextureView.getHandle();
                colorAttachments[i].imageLayout                 = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
                colorAttachments[i].loadOp                      = descriptor.colorAttachments[i].loadOp.toVkLoadOp();
                colorAttachments[i].storeOp                     = descriptor.colorAttachments[i].storeOp.toVkStoreOp();
                colorAttachments[i].resolveMode                 = descriptor.colorAttachments[i].storeOp.toVkResolveMode();
                colorAttachments[i].clearValue.color.float32[0] = descriptor.colorAttachments[i].clearValue.r;
                colorAttachments[i].clearValue.color.float32[1] = descriptor.colorAttachments[i].clearValue.g;
                colorAttachments[i].clearValue.color.float32[2] = descriptor.colorAttachments[i].clearValue.b;
                colorAttachments[i].clearValue.color.float32[3] = descriptor.colorAttachments[i].clearValue.a;

                if (descriptor.colorAttachments[i].resolveTexture) {
                    colorAttachments[i].resolveImageView = 
                        cast(VkImageView)descriptor.colorAttachments[i].resolveTexture.getHandle();
                    colorAttachments[i].resolveImageLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
                }

                VkImageMemoryBarrier memoryBarrier;
                memoryBarrier.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
                memoryBarrier.newLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
                memoryBarrier.image = cast(VkImage)nuvkTextureView.getTexture().getHandle();
                memoryBarrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
                memoryBarrier.subresourceRange.baseMipLevel = 0;
                memoryBarrier.subresourceRange.levelCount = 1;
                memoryBarrier.subresourceRange.baseArrayLayer = 0;
                memoryBarrier.subresourceRange.layerCount = 1;

                memoryBarriers ~= memoryBarrier;
            }

            renderInfo.colorAttachmentCount = cast(uint)colorAttachments.size();
            renderInfo.pColorAttachments = colorAttachments.data();
        }

        // Depth-stencil attachments.
        {
            if (descriptor.depthStencilAttachment.texture) {
                NuvkVkTextureView nuvkTextureView = cast(NuvkVkTextureView)descriptor.depthStencilAttachment.texture;
                NuvkTexture nuvkTexture = nuvkTextureView.getTexture();
                
                // Ensure that the clip area is always within valid bounds.
                descriptor.renderArea.clip(recti(0, 0, nuvkTexture.getWidth(), nuvkTexture.getHeight()));
                
                depthStencilAttachment.imageView                        = cast(VkImageView)nuvkTextureView.getHandle();
                depthStencilAttachment.imageLayout                      = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR;
                depthStencilAttachment.loadOp                           = descriptor.depthStencilAttachment.loadOp.toVkLoadOp();
                depthStencilAttachment.storeOp                          = descriptor.depthStencilAttachment.storeOp.toVkStoreOp();
                depthStencilAttachment.resolveMode                      = descriptor.depthStencilAttachment.storeOp.toVkResolveMode();
                depthStencilAttachment.clearValue.depthStencil.depth    = descriptor.depthStencilAttachment.clearValue.depth;
                depthStencilAttachment.clearValue.depthStencil.stencil  = descriptor.depthStencilAttachment.clearValue.stencil;
                
                if (descriptor.depthStencilAttachment.resolveTexture) {
                    depthStencilAttachment.resolveImageView = 
                        cast(VkImageView)descriptor.depthStencilAttachment.resolveTexture.getHandle();
                    depthStencilAttachment.resolveImageLayout = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR;
                }

                renderInfo.pDepthAttachment = &depthStencilAttachment;
                renderInfo.pStencilAttachment = &depthStencilAttachment;
            }
        }

        renderInfo.renderArea.offset.x = descriptor.renderArea.x;
        renderInfo.renderArea.offset.y = descriptor.renderArea.y;
        renderInfo.renderArea.extent.width = descriptor.renderArea.width;
        renderInfo.renderArea.extent.height = descriptor.renderArea.height;

        // Swap image type
        vkCmdPipelineBarrier(
            writeBuffer,
            VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
            VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
            0,
            0,
            null,
            0,
            null,
            cast(uint)memoryBarriers.size(),
            memoryBarriers.data()
        );

        vkCmdBeginRendering(writeBuffer, &renderInfo);

        VkRect2D scissorRect;
        scissorRect.offset.x = descriptor.renderArea.x;
        scissorRect.offset.y = descriptor.renderArea.y;
        scissorRect.extent.width = descriptor.renderArea.width;
        scissorRect.extent.height = descriptor.renderArea.height;

        VkViewport viewport;
        viewport.minDepth = 0;
        viewport.maxDepth = 1;
        viewport.x = descriptor.renderArea.x;
        viewport.y = descriptor.renderArea.y;
        viewport.width = descriptor.renderArea.width;
        viewport.height = descriptor.renderArea.height;

        vkCmdSetScissor(writeBuffer, 0, 1, &scissorRect);
        vkCmdSetViewport(writeBuffer, 0, 1, &viewport);
        vkCmdSetPrimitiveRestartEnable(writeBuffer, VK_TRUE);
        vkCmdSetPrimitiveTopology(writeBuffer, VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST);
        vkCmdSetVertexInputEXT(writeBuffer, 0, null, 0, null);
        vkCmdSetBlendConstants(writeBuffer, [0, 0, 0, 0]);
        vkCmdSetLineWidth(writeBuffer, 1);
        vkCmdSetDepthBias(writeBuffer, 0, 0, 0);
        vkCmdSetCullMode(writeBuffer, VK_CULL_MODE_NONE);
        vkCmdBindVertexBuffers2(writeBuffer, 0, 0, null, null, null, null);
    }

    void endRendering() {
        NuvkRenderPassDescriptor descriptor = this.getDescriptor();

        weak_vector!VkImageMemoryBarrier memoryBarriers;

        foreach(i; 0..descriptor.colorAttachments.size()) {
            NuvkVkTextureView nuvkTextureView = cast(NuvkVkTextureView)descriptor.colorAttachments[i].texture;

            VkImageMemoryBarrier memoryBarrier;
            memoryBarrier.oldLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
            memoryBarrier.newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
            memoryBarrier.image = cast(VkImage)nuvkTextureView.getTexture().getHandle();
            memoryBarrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
            memoryBarrier.subresourceRange.baseMipLevel = 0;
            memoryBarrier.subresourceRange.levelCount = 1;
            memoryBarrier.subresourceRange.baseArrayLayer = 0;
            memoryBarrier.subresourceRange.layerCount = 1;

            memoryBarriers ~= memoryBarrier;
        }

        vkCmdEndRendering(writeBuffer);

        // Swap image type
        vkCmdPipelineBarrier(
            writeBuffer,
            VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
            VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
            0,
            0,
            null,
            0,
            null,
            cast(uint)memoryBarriers.size(),
            memoryBarriers.data()
        );

        vkEndCommandBuffer(writeBuffer);
        parent.commandBuffers ~= writeBuffer;
        nogc_delete(this);
    }

public:

    /**
        Constructor
    */
    this(NuvkVkCommandBuffer parent, ref NuvkRenderPassDescriptor descriptor, VkCommandBuffer rDestination) {
        super(parent, descriptor);
        this.parent = parent;
        this.writeBuffer = rDestination;
        this.beginRendering();
    }

    /**
        Pushes a debug group onto the command buffer's stack
        This is useful for render debugging.
    */
    override
    void pushDebugGroup(nstring name) {
        
    }

    /**
        Pops a debug group from the command buffer's stack
        This is useful for render debugging.
    */
    override
    void popDebugGroup() {
        
    }

    // /**
    //     Encodes a command that makes the GPU wait for a fence.
    // */
    // override
    // void waitFor(NuvkSemaphore fence, NuvkRenderStage before) {
    // }

    // /**
    //     Encodes a command that makes the GPU signal a fence.
    // */
    // override
    // void signal(NuvkSemaphore fence, NuvkRenderStage after) {
        
    // }

    /**
        Ends encoding the commands to the buffer.
    */
    override
    void endEncoding() {
        this.endRendering();
    }

    /**
        Sets the active pipeline
    */
    override
    void setPipeline(NuvkPipeline pipeline) {
        vkCmdBindPipeline(writeBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)pipeline.getHandle());
        
    }

    /**
        Configures the active rendering pipeline with 
        the specified viewport.
    */
    override
    void setViewport(recti viewport) {
        VkViewport vp;
        vp.minDepth = 0;
        vp.maxDepth = 1;
        vp.x = viewport.x;
        vp.y = viewport.y;
        vp.width = viewport.width;
        vp.height = viewport.height;
        vkCmdSetViewport(writeBuffer, 0, 1, &vp);
    }

    /**
        Configures the active rendering pipeline with 
        the specified scissor rectangle.
    */
    override
    void setScissorRect(recti scissor) {
        VkRect2D sc;
        sc.offset.x = scissor.x;
        sc.offset.y = scissor.y;
        sc.extent.width = scissor.width;
        sc.extent.height = scissor.height;
        vkCmdSetScissor(writeBuffer, 0, 1, &sc);
    }

    /**
        Configures the active rendering pipeline with 
        the specified culling mode.
    */
    override
    void setCulling(NuvkCulling culling) {
        vkCmdSetCullMode(writeBuffer, culling.toVkCulling());
    }

    /**
        Configures the active rendering pipeline with 
        the specified triangle front face winding.
    */
    override
    void setFrontFace(NuvkWinding winding) {
        vkCmdSetFrontFace(writeBuffer, winding.toVkFrontFace());
    }

    /**
        Configures the active rendering pipeline with 
        the specified triangle fill mode.
    */
    override
    void setFillMode(NuvkFillMode fillMode) {
        
    }

    /**
        Sets the vertex buffer in use.
    */
    override
    void setVertexBuffer(NuvkBuffer buffer, uint offset, uint stride, int index) {
        VkBuffer pBuffer = cast(VkBuffer)buffer.getHandle();
        VkDeviceSize pOffset = offset;
        VkDeviceSize pStride = stride;
        vkCmdBindVertexBuffers2(writeBuffer, index, 1, &pBuffer, &pOffset, null, &pStride);
    }

    /**
        Sets the vertex buffer in use.
    */
    override
    void setIndexBuffer(NuvkBuffer buffer, uint offset, NuvkBufferIndexType indexType) {
        vkCmdBindIndexBuffer(writeBuffer, cast(VkBuffer)buffer.getHandle(), offset, indexType.toVkIndexType());
    }

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state.
    */
    override
    void draw(NuvkPrimitive primitive, uint offset, uint count) {
        vkCmdDraw(writeBuffer, count, 1, offset, 0);
    }

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state, using a index buffer
        to iterate over the vertex buffers.
    */
    override
    void drawIndexed(NuvkPrimitive primitive, uint offset, uint count) {
        
    }

    /**
        Encodes a rendering barrier that enforces 
        a specific order for read/write operations.
    */
    override
    void waitBarrier(NuvkResource resource, NuvkRenderStage before, NuvkRenderStage after) {

    }
}

