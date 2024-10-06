/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.cmdbuffer;
import nuvk.core.vk.internal.descpoolmgr;
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

VkBlendFactor toVkBlendFactor(NuvkBlendFactor factor) @nogc {
    final switch(factor) {
        case NuvkBlendFactor.zero:
            return VK_BLEND_FACTOR_ZERO;
        case NuvkBlendFactor.one:
            return VK_BLEND_FACTOR_ONE;
        case NuvkBlendFactor.srcColor:
            return VK_BLEND_FACTOR_SRC_COLOR;
        case NuvkBlendFactor.oneMinusSrcColor:
            return VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR;
        case NuvkBlendFactor.oneMinusSrcAlpha:
            return VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
        case NuvkBlendFactor.destColor:
            return VK_BLEND_FACTOR_DST_COLOR;
        case NuvkBlendFactor.oneMinusDestColor:
            return VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR;
        case NuvkBlendFactor.oneMinusDestAlpha:
            return VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA;
        case NuvkBlendFactor.srcAlphaSaturated:
            return VK_BLEND_FACTOR_SRC_ALPHA_SATURATE;
    }
}

VkBlendOp toVkBlendOp(NuvkBlendOp op) @nogc {
    final switch(op) {
        case NuvkBlendOp.add:
            return VK_BLEND_OP_ADD;
        case NuvkBlendOp.subtract:
            return VK_BLEND_OP_SUBTRACT;
        case NuvkBlendOp.reverseSubtract:
            return VK_BLEND_OP_REVERSE_SUBTRACT;
        case NuvkBlendOp.min:
            return VK_BLEND_OP_MIN;
        case NuvkBlendOp.max:
            return VK_BLEND_OP_MAX;
    }
}

/**
    Command buffer
*/
class NuvkVkCommandBuffer : NuvkCommandBuffer {
@nogc:
private:
    NuvkDescriptorPoolManager pools;

    // Normal use command buffers
    weak_vector!VkCommandBuffer commandBuffers;

    VkCommandBuffer createCommandBuffer() {
        VkCommandBuffer bufferHandle = VK_NULL_HANDLE;

        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkQueue)this.getQueue()).getCommandPool();

        VkCommandBufferAllocateInfo commandBufferInfo;
        commandBufferInfo.commandPool = pool;
        commandBufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        commandBufferInfo.commandBufferCount = 1;

        nuvkEnforce(
            vkAllocateCommandBuffers(device, &commandBufferInfo, &bufferHandle) == VK_SUCCESS,
            "Failed to allocate command buffer"
        );

        VkCommandBufferBeginInfo beginInfo;
        nuvkEnforce(
            vkBeginCommandBuffer(bufferHandle, &beginInfo) == VK_SUCCESS,
            "Failed to begin command buffer"
        );

        return bufferHandle;
    }

    void freeCommandBuffers() {

        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto pool = (cast(NuvkVkQueue)this.getQueue()).getCommandPool();

        if (commandBuffers.size() > 0) {
            vkFreeCommandBuffers(device, pool, cast(uint)commandBuffers.size(), commandBuffers.data());
            commandBuffers.resize(0);
        }
    }

protected:

    /**
        Implements the logic to begin a new pass of command encoding.
    */
    override
    void onBeginNewPass() {
        this.freeCommandBuffers();
        pools.reset();
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
        return nogc_new!NuvkVkTransferEncoder(this, this.createCommandBuffer());
    }

    /**
        Implements the logic to finish encoding.
    */
    override
    void onEncoderFinished(void* handle) {
        this.commandBuffers ~= cast(VkCommandBuffer)handle;
    }

public:

    ~this() {
        this.freeCommandBuffers();
        nogc_delete(this.pools);
    }

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkQueue queue) {
        super(device, queue);
        this.pools = nogc_new!NuvkDescriptorPoolManager(cast(NuvkVkDevice)this.getOwner());
    }

    /**
        Presents the surface
    */
    override
    void present(NuvkSurface surface) {
        nuvkEnforce(
            this.getStatus() == NuvkCommandBufferStatus.submitted,
            "Nothing to present."
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

    // Parent command buffer
    NuvkVkCommandBuffer parent;
    VkCommandBuffer writeBuffer;
    VkDevice device;

    // Pipeline state
    NuvkVkPipeline currentPipeline;
    VkDescriptorSet currentSet;
    VkDescriptorSet boundSet;

    void bindCurrentSet() {
        if (boundSet !is currentSet) {
            vkCmdBindDescriptorSets(
                writeBuffer,
                VK_PIPELINE_BIND_POINT_GRAPHICS,
                currentPipeline.getPipelineLayout(),
                0,
                1,
                &currentSet,
                0,
                null
            );
            boundSet = currentSet;
        }
    }

protected:


    /**
        Called by the implementation when the encoding begins
    */
    override
    void onBegin(ref NuvkCommandBuffer buffer) {
        NuvkRenderPassDescriptor descriptor = this.getDescriptor();

        VkRenderingInfo renderInfo;
        renderInfo.layerCount = 1;

        weak_vector!VkImageMemoryBarrier memoryBarriers;

        weak_vector!VkRenderingAttachmentInfo colorAttachments
            = weak_vector!VkRenderingAttachmentInfo(descriptor.colorAttachments.size());
        VkRenderingAttachmentInfo depthStencilAttachment;

        uint attachmentCount = 0;

        // Color attachments
        {
            foreach(i; 0..descriptor.colorAttachments.size()) {
                NuvkVkTextureView nuvkTextureView = cast(NuvkVkTextureView)descriptor.colorAttachments[i].texture;
                NuvkTexture nuvkTexture = nuvkTextureView.getTexture();
                
                // Ensure that the clip area is always within valid bounds.
                descriptor.renderArea.clip(recti(0, 0, nuvkTexture.getWidth(), nuvkTexture.getHeight()));

                colorAttachments[i].imageView                   = cast(VkImageView)nuvkTextureView.getHandle();
                colorAttachments[i].imageLayout                 = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR;
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
                    colorAttachments[i].resolveImageLayout = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR;
                }

                VkImageMemoryBarrier memoryBarrier;
                memoryBarrier.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
                memoryBarrier.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
                memoryBarrier.newLayout = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR;
                memoryBarrier.image = cast(VkImage)nuvkTextureView.getTexture().getHandle();
                memoryBarrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
                memoryBarrier.subresourceRange.baseMipLevel = 0;
                memoryBarrier.subresourceRange.levelCount = 1;
                memoryBarrier.subresourceRange.baseArrayLayer = 0;
                memoryBarrier.subresourceRange.layerCount = 1;

                memoryBarriers ~= memoryBarrier;
                attachmentCount++;
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
                attachmentCount++;
            }
        }

        renderInfo.renderArea.offset.x = descriptor.renderArea.x;
        renderInfo.renderArea.offset.y = descriptor.renderArea.y;
        renderInfo.renderArea.extent.width = descriptor.renderArea.width;
        renderInfo.renderArea.extent.height = descriptor.renderArea.height;

        nuvkEnforce(
            attachmentCount > 0,
            "Attempting to render without attachments!"
        );

        // Swap image type
        vkCmdPipelineBarrier(
            writeBuffer,
            VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
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

        if (colorAttachments.size() > 0) {
            foreach(i, colorAttachment; descriptor.colorAttachments) {
                uint attachmentIndex = cast(uint)i;

                VkBool32 enabled = colorAttachment.isBlendingEnabled;
                vkCmdSetColorBlendEnableEXT(writeBuffer, attachmentIndex, 1, &enabled);
                if (colorAttachment.isBlendingEnabled) {
                    VkColorBlendEquationEXT equation;
                    equation.colorBlendOp = colorAttachment.blendOp.toVkBlendOp();
                    equation.alphaBlendOp = colorAttachment.blendOp.toVkBlendOp();
                    equation.srcColorBlendFactor = colorAttachment.sourceColorFactor.toVkBlendFactor();
                    equation.srcAlphaBlendFactor = colorAttachment.sourceAlphaFactor.toVkBlendFactor();
                    equation.dstColorBlendFactor = colorAttachment.destinationColorFactor.toVkBlendFactor();
                    equation.dstAlphaBlendFactor = colorAttachment.destinationAlphaFactor.toVkBlendFactor();

                    vkCmdSetColorBlendEquationEXT(writeBuffer, attachmentIndex, 1, &equation);
                }

                uint writeMask = VK_COLOR_COMPONENT_R_BIT | 
                                 VK_COLOR_COMPONENT_G_BIT | 
                                 VK_COLOR_COMPONENT_B_BIT | 
                                 VK_COLOR_COMPONENT_A_BIT;
                vkCmdSetColorWriteMaskEXT(writeBuffer, 0, 1, &writeMask);
            }
        }

        vkCmdSetScissor(writeBuffer, 0, 1, &scissorRect);
        vkCmdSetViewport(writeBuffer, 0, 1, &viewport);
        vkCmdSetPrimitiveRestartEnable(writeBuffer, VK_TRUE);
        vkCmdSetPrimitiveTopology(writeBuffer, VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST);
        vkCmdSetLineWidth(writeBuffer, 1);
        vkCmdSetDepthBias(writeBuffer, 0, 0, 0);
        vkCmdSetCullMode(writeBuffer, VK_CULL_MODE_BACK_BIT);
        vkCmdSetFrontFace(writeBuffer, VK_FRONT_FACE_CLOCKWISE);
    }

    /**
        Called by the implementation when the encoding ends
    */
    override
    void* onEnd(ref NuvkCommandBuffer buffer) {
        NuvkRenderPassDescriptor descriptor = this.getDescriptor();

        weak_vector!VkImageMemoryBarrier memoryBarriers;

        foreach(i; 0..descriptor.colorAttachments.size()) {
            NuvkVkTextureView nuvkTextureView = cast(NuvkVkTextureView)descriptor.colorAttachments[i].texture;

            VkImageMemoryBarrier memoryBarrier;
            memoryBarrier.srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
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
            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
            VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
            0,
            0,
            null,
            0,
            null,
            cast(uint)memoryBarriers.size(),
            memoryBarriers.data()
        );

        vkEndCommandBuffer(writeBuffer);
        return writeBuffer;
    }

public:

    /**
        Constructor
    */
    this(NuvkVkCommandBuffer parent, ref NuvkRenderPassDescriptor descriptor, VkCommandBuffer rDestination) {
        this.device = cast(VkDevice)parent.getOwner().getHandle();
        this.parent = parent;
        this.writeBuffer = rDestination;

        super(parent, descriptor);
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
        Sets the active pipeline
    */
    override
    void setPipeline(NuvkPipeline pipeline) {

        currentPipeline = cast(NuvkVkPipeline)pipeline;
        currentSet = parent.pools.getNext(currentPipeline.getLayouts());
        vkCmdBindPipeline(writeBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, cast(VkPipeline)currentPipeline.getHandle());
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
        Sets a buffer for the vertex shader.
    */
    override
    void setVertexBuffer(NuvkBuffer buffer, uint offset, int index) {
        switch(buffer.getBufferType()) {
            default:
                break;
            case NuvkBufferUsage.index:
                vkCmdBindIndexBuffer(writeBuffer, cast(VkBuffer)buffer.getHandle(), offset, VK_INDEX_TYPE_UINT16);
                break;

            case NuvkBufferUsage.uniform:
                VkDescriptorBufferInfo bufferInfo;
                bufferInfo.buffer = cast(VkBuffer)buffer.getHandle();
                bufferInfo.offset = offset;
                bufferInfo.range = buffer.getSize();

                VkWriteDescriptorSet writeInfo;
                writeInfo.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
                writeInfo.descriptorCount = 1;
                writeInfo.dstBinding = index;
                writeInfo.dstArrayElement = 0;
                writeInfo.pBufferInfo = &bufferInfo;
                writeInfo.dstSet = currentSet;

                vkUpdateDescriptorSets(device, 1, &writeInfo, 0, null);
                break;

            case NuvkBufferUsage.vertex:
                VkBuffer pBuffer = cast(VkBuffer)buffer.getHandle();
                VkDeviceSize pOffset = offset;
                vkCmdBindVertexBuffers(writeBuffer, index, 1, &pBuffer, &pOffset);
                break;
        }
    }
    
    /**
        Sets a buffer for the fragment shader.
    */
    override
    void setFragmentBuffer(NuvkBuffer buffer, uint offset, int index) {
        switch(buffer.getBufferType()) {
            default:
                break;

            case NuvkBufferUsage.uniform:
                VkDescriptorBufferInfo bufferInfo;
                bufferInfo.buffer = cast(VkBuffer)buffer.getHandle();
                bufferInfo.offset = offset;
                bufferInfo.range = buffer.getSize();

                VkWriteDescriptorSet writeInfo;
                writeInfo.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
                writeInfo.descriptorCount = 1;
                writeInfo.dstBinding = index;
                writeInfo.dstArrayElement = 0;
                writeInfo.pBufferInfo = &bufferInfo;
                writeInfo.dstSet = currentSet;

                vkUpdateDescriptorSets(device, 1, &writeInfo, 0, null);
                break;
        }
    }


    /**
        Sets a texture for the fragment shader
    */
    override
    void setFragmentTexture(NuvkTextureView texture, int index) {
        VkDescriptorImageInfo imageInfo;
        imageInfo.imageLayout = VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL;
        imageInfo.imageView = cast(VkImageView)texture.getHandle();

        VkWriteDescriptorSet writeInfo;
        writeInfo.descriptorType = VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
        writeInfo.descriptorCount = 1;
        writeInfo.dstBinding = index;
        writeInfo.dstArrayElement = 0;
        writeInfo.pBufferInfo = null;
        writeInfo.pImageInfo = &imageInfo;
        writeInfo.dstSet = currentSet;

        vkUpdateDescriptorSets(device, 1, &writeInfo, 0, null);
    }

    /**
        Sets a sampler for the fragment shader
    */
    override
    void setFragmentSampler(NuvkSampler sampler, int index) {
        VkDescriptorImageInfo imageInfo;
        imageInfo.sampler = cast(VkSampler)sampler.getHandle();

        VkWriteDescriptorSet writeInfo;
        writeInfo.descriptorType = VK_DESCRIPTOR_TYPE_SAMPLER;
        writeInfo.descriptorCount = 1;
        writeInfo.dstBinding = index;
        writeInfo.dstArrayElement = 0;
        writeInfo.pBufferInfo = null;
        writeInfo.pImageInfo = &imageInfo;
        writeInfo.dstSet = currentSet;

        vkUpdateDescriptorSets(device, 1, &writeInfo, 0, null);
    }

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state.
    */
    override
    void draw(NuvkPrimitive primitive, uint offset, uint count) {
        this.bindCurrentSet();
        vkCmdDraw(writeBuffer, count, 1, offset, 0);
    }

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state, using a index buffer
        to iterate over the vertex buffers.
    */
    override
    void drawIndexed(NuvkPrimitive primitive, uint offset, uint count) {
        this.bindCurrentSet();
        vkCmdDrawIndexed(writeBuffer, count, 1, 0, offset, 0);
    }

    /**
        Encodes a rendering barrier that enforces 
        a specific order for read/write operations.
    */
    override
    void waitFor(NuvkBarrierScope scope_, NuvkRenderStage after, NuvkRenderStage before) {
        VkMemoryBarrier barrier;
        barrier.srcAccessMask = VK_ACCESS_MEMORY_WRITE_BIT;
        barrier.dstAccessMask = VK_ACCESS_MEMORY_READ_BIT;

        vkCmdPipelineBarrier(
            writeBuffer,
            after.toVkPipelineStage(scope_),
            before.toVkPipelineStage(scope_),
            0,
            1,
            &barrier,
            0,
            null,
            0,
            null
        );
    }
}



/**
    A lightweight object for submitting transfer commands
    to a command buffer.
*/
class NuvkVkTransferEncoder : NuvkTransferEncoder {
@nogc:
private:

    // Parent command buffer
    NuvkVkCommandBuffer parent;
    VkCommandBuffer writeBuffer;
    VkDevice device;

protected:

    /**
        Called by the implementation when the encoding begins
    */
    override
    void onBegin(ref NuvkCommandBuffer buffer) {
        VkCommandBufferBeginInfo beginInfo;
        vkBeginCommandBuffer(writeBuffer, &beginInfo);
    }

    /**
        Called by the implementation when the encoding ends
    */
    override
    void* onEnd(ref NuvkCommandBuffer buffer) {
        vkEndCommandBuffer(writeBuffer);
        return writeBuffer;
    }


public:

    /**
        Constructor
    */
    this(NuvkVkCommandBuffer parent, VkCommandBuffer rDestination) {
        this.device = cast(VkDevice)parent.getOwner().getHandle();
        this.parent = parent;
        this.writeBuffer = rDestination;

        super(parent);
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

    /**
        Submits a command which generates mipmaps for the
        specified texture
    */
    override
    void generateMipmaps(NuvkTexture texture) {
        
    }

    /**
        Copies data between 2 buffers
    */
    override
    void copy(NuvkBuffer from, uint sourceOffset, NuvkBuffer to, uint destOffset, uint size) {

    }

    /**
        Copies data between a buffer and texture

        Parameters:
            `from` - The buffer to copy from
            `sourceOffset` - Offset, in bytes, into the buffer to copy from
            `sourcePxStride` - How many bytes there are in a single pixel
            `copyRange` - The width and height to copy, and the destination coordinates in the texture to put them.
            `to` - The texture to copy to
            `arraySlice` - The texture array slice to copy into.
            `mipLevel` - The texture mip level to copy into.
    */
    override
    void copy(NuvkBuffer from, uint sourceOffset, uint sourcePxStride, recti copyRange, NuvkTexture to, uint arraySlice = 0, uint mipLevel = 0) {
        
    }

    /**
        Copies data between 2 textures
    */
    override
    void copy(NuvkTexture from, NuvkTexture to) {
        
    }

    /**
        Encodes a command which optimizes the texture for the specified usage.
    */
    override
    void optimizeTextureFor(NuvkTexture texture, NuvkOptimizationMode mode, uint arraySlice = 0, uint mipLevel = 0) {
        
    }

    /**
        Encodes a command which synchronizes the resource between CPU and GPU.
    */
    override
    void synchronize(NuvkResource resource) {
        
    }
}