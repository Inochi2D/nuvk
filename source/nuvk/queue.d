/**
    Command Queues and Pools
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.queue;
import nuvk.device;
import nuvk.sync;
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

/**
    A vulkan queue
*/
class NuvkQueue : NuvkDeviceObject!(VkQueue, VK_OBJECT_TYPE_QUEUE) {
private:
@nogc:
    uint queueFamily_;
    uint queueIndex_;

public:

    /**
        The family index of this queue.
    */
    @property uint queueFamily() => queueFamily_;

    /**
        The index of this queue
    */
    @property uint queueIndex() => queueIndex_;

    /**
        Constructs a new Queue

        Params:
            device =        The device which owns the queue.
            ptr =           The VkQueue instance.
            queueFamily =   The queue family of the queue.
            queueIndex =    The queue index of the queue.
    */
    this(NuvkDevice device, VkQueue ptr, uint queueFamily, uint queueIndex) {
        this.queueFamily_ = queueFamily;
        super(device, ptr);
    }

    /**
        Creates a new command pool for the queue.

        Params:
            flags = Creation flags for the pool.
    */
    NuvkCommandPool createPool(VkCommandPoolCreateFlags flags = 0) {
        return nogc_new!NuvkCommandPool(this, flags);
    }

    /**
        Submits a command buffer to the queue.

        Params:
            submitInfo =    Submission information.
            fence =         Fence to signal on completion (optional)
        
        Returns:
            A VkResult indicating a success or error state.
    */
    VkResult submit(VkSubmitInfo2 submitInfo, NuvkFence fence = null) {
        return vkQueueSubmit2(handle, 1, &submitInfo, fence ? fence.handle : null);
    }
}

/**
    A vulkan command pool.
*/
class NuvkCommandPool : NuvkDeviceObject!(VkCommandPool, VK_OBJECT_TYPE_COMMAND_POOL) {
private:
@nogc:
    NuvkQueue queue_;

public:

    /**
        The queue this pool submits to.
    */
    @property NuvkQueue queue() => queue_;

    // Destructor
    ~this() {
        vkDestroyCommandPool(device.handle, handle, null);
    }

    /**
        Constructs a new Command Pool

        Params:
            queue =     The queue which the pool submits to.
            flags =     Creation flags for the pool.
    */
    this(NuvkQueue queue, VkCommandPoolCreateFlags flags) {
        VkCommandPool pool_;
        auto poolCreateInfo = VkCommandPoolCreateInfo(
            queueFamilyIndex: queue.queueFamily,
            flags: flags
        );
        vkCreateCommandPool(queue.device.handle, &poolCreateInfo, null, &pool_);

        this.queue_ = queue;
        super(queue.device, pool_);
    }

    /**
        Resets the command pool.

        Params:
            resetFlags = Reset flags.
        
        Returns:
            $(D VK_SUCCESS) on success,
            negative VkResult otherwise.
    */
    VkResult reset(VkCommandPoolResetFlags resetFlags) {
        return vkResetCommandPool(device.handle, handle, resetFlags);
    }

    /**
        Trims the command pool, freeing memory if possible.

        Params:
            trimFlags = Trimming flags.
    */
    void trim(VkCommandPoolTrimFlags trimFlags) {
        vkTrimCommandPool(device.handle, handle, trimFlags);
    }

    /**
        Allocates a command buffer from the pool.

        Params:
            level = The level to allocate.
        
        Returns:
            A new VkCommandBuffer handle.
    */
    NuvkCommandBuffer allocate(VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
        VkCommandBuffer handle_;
        auto cmdbufCreateInfo = VkCommandBufferAllocateInfo(
            commandPool: handle,
            commandBufferCount: 1,
            level: level
        );

        vkAllocateCommandBuffers(device.handle, &cmdbufCreateInfo, &handle_);
        return nogc_new!NuvkCommandBuffer(this, handle_);
    }
}

/**
    A command buffer
*/
class NuvkCommandBuffer : NuvkDeviceObject!(VkCommandBuffer, VK_OBJECT_TYPE_COMMAND_BUFFER) {
private:
@nogc:
    NuvkCommandPool pool_;

public:
    
    /**
        The command pool that allocated the command buffer.
    */
    final @property NuvkCommandPool pool() => pool_;

    ~this() {
        cast(void)pool_.release();

        VkCommandBuffer handle_ = handle;
        vkFreeCommandBuffers(device.handle, pool.handle, 1, &handle_);
    }

    /**
        Constructs a new Command Buffer.

        Params:
            pool =      The owning pool.
            handle =    The handle of the command buffer.
    */
    this(NuvkCommandPool pool, VkCommandBuffer handle) {
        this.pool_ = pool.retained();
        super(pool.device, handle);
    }

    /**
        Begins the command buffer.

        Params:
            beginInfo = Info needed to begin recording commands.

        Returns:
            A $(D VkResult) code describing success or error states.
    */
    VkResult begin(VkCommandBufferBeginInfo beginInfo) {
        return vkBeginCommandBuffer(handle, &beginInfo);
    }

    /**
        Ends the command buffer.

        Returns:
            A $(D VkResult) code describing success or error states.
    */
    VkResult end() {
        return vkEndCommandBuffer(handle);
    }

    /**
        Resets the command buffer.

        Params:
            flags = Reset flags

        Returns:
            A $(D VkResult) code describing success or error states.
    */
    VkResult reset(VkCommandBufferResetFlags flags = 0) {
        return vkResetCommandBuffer(handle, flags);
    }

    /**
        Begins a dynamic rendering pass.

        Params:
            renderInfo = Information needed to begin rendering.
    */
    void beginRendering(VkRenderingInfo renderInfo) {
        vkCmdBeginRendering(handle, &renderInfo);
    }

    /**
        Ends a dynamic rendering pass.
    */
    void endRendering() {
        vkCmdEndRendering(handle);
    }

    /**
        Begins a render pass.

        Params:
            beginInfo =         Information about the render pass.
            subpassBeginInfo =  Information needed to begin the subpass.
    */
    void beginRenderPass(VkRenderPassBeginInfo beginInfo, VkSubpassBeginInfo subpassBeginInfo) {
        vkCmdBeginRenderPass2(handle, &beginInfo, &subpassBeginInfo);
    }

    /**
        Switches to the next subpass of the render pass.

        Params:
            beginInfo = Information needed to begin the subpass.
            endInfo =   Information needed to end the subpass.
    */
    void nextSubpass(VkSubpassBeginInfo beginInfo, VkSubpassEndInfo endInfo) {
        vkCmdNextSubpass2(handle, &beginInfo, &endInfo);
    }

    /**
        Ends a render pass.

        Params:
            endInfo = Information needed to end the subpass.
    */
    void endRenderPass(VkSubpassEndInfo endInfo) {
        vkCmdEndRenderPass2(handle, &endInfo);
    }

    /**
        Sets the given viewport.

        Params:
            vpIdx = The viewport index, starting from 0.
            vp =    The viewport to set at that index.
    */
    void setViewport(uint vpIdx, VkViewport vp) {
        vkCmdSetViewport(handle, vpIdx, 1, &vp);
    }

    /**
        Sets the given scissor rectangle.

        Params:
            scissorIdx =    The scissor index, starting from 0.
            scissor =       The scissor to set at that index.
    */
    void setScissor(uint scissorIdx, VkRect2D scissor) {
        vkCmdSetScissor(handle, scissorIdx, 1, &scissor);
    }

    /**
        Sets the width of lines.

        Params:
            lineWidth = The width of the line.
    */
    void setLineWidth(float lineWidth) {
        vkCmdSetLineWidth(handle, lineWidth);
    }

    /**
        Sets the depth testing bias.

        Params:
            depthBiasConstantFactor =   Constant added to all fragments.
            depthBiasClamp =            Maximum depth bias of a fragment.
            depthBiasSlopeFactor =      Factor applied to fragment slope.
    */
    void setDepthBias(float depthBiasConstantFactor, float depthBiasClamp, float depthBiasSlopeFactor) {
        vkCmdSetDepthBias(handle, depthBiasConstantFactor, depthBiasClamp, depthBiasSlopeFactor);
    }

    /**
        Sets the blending constants for blend-to-color blending modes.
        
        Params:
            blendConstants = RGBA values for the blend constants.
    */
    void setBlendConstants(const(float)[4] blendConstants) {
        vkCmdSetBlendConstants(handle, blendConstants);
    }

    /**
        Sets the bounds of depth testing.
        
        Params:
            minDepthBounds = Smallest possible depth value.
            maxDepthBounds = Largest possible depth value.
    */
    void setDepthBounds(float minDepthBounds, float maxDepthBounds) {
        vkCmdSetDepthBounds(handle, minDepthBounds, maxDepthBounds);
    }

    /**
        Sets the stencil comparison mask.
        
        Params:
            faceMask =      The face this should apply to.
            compareMask =   The comparison mask.
    */
    void setStencilCompareMask(VkStencilFaceFlags faceMask, uint compareMask) {
        vkCmdSetDepthBounds(handle, faceMask, compareMask);
    }

    /**
        Sets the stencil write mask.
        
        Params:
            faceMask =  The face this should apply to.
            writeMask = The comparison mask.
    */
    void setStencilWriteMask(VkStencilFaceFlags faceMask, uint writeMask) {
        vkCmdSetStencilWriteMask(handle, faceMask, writeMask);
    }

    /**
        Sets the stencil reference value.
        
        Params:
            faceMask =  The face this should apply to.
            reference = The reference value.
    */
    void setStencilReference(VkStencilFaceFlags faceMask, uint reference) {
        vkCmdSetStencilReference(handle, faceMask, reference);
    }

    /**
        Sets the culling mode.

        Params:
            value = The culling mode to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setCullMode(VkCullModeFlags value) {
        vkCmdSetCullMode(handle, value);
    }

    /**
        Sets the front face winding.

        Params:
            value = The font face winding to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setFrontFace(VkFrontFace value) {
        vkCmdSetFrontFace(handle, value);
    }

    /**
        Sets the topology of primitives.

        Params:
            value = The primitive topology to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setTopology(VkPrimitiveTopology value) {
        vkCmdSetPrimitiveTopology(handle, value);
    }

    /**
        Sets the depth compare operation.

        Params:
            value = The depth compare operation to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setDepthCompareOp(VkCompareOp value) {
        vkCmdSetDepthCompareOp(handle, value);
    }

    /**
        Sets the depth compare operation.

        Params:
            faceMask =      The face the stencil operation applies to.
            failOp =        Operation to perform on stencil testing failure.
            passOp =        Operation to perform on stencil testing pass.
            depthFailOp =   Operation to perform on depth testing failure.
            compareOp =     The stencil comparison operation to perform.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setStencilOp(VkStencilFaceFlags faceMask, VkStencilOp failOp, VkStencilOp passOp, VkStencilOp depthFailOp, VkCompareOp compareOp) {
        vkCmdSetStencilOp(handle, faceMask, failOp, passOp, depthFailOp, compareOp);
    }

    /**
        Sets whether depth testing is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setDepthTestEnabled(bool value) {
        vkCmdSetDepthTestEnable(handle, value);
    }

    /**
        Sets whether depth test bounds is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setDepthTestBoundsEnabled(bool value) {
        vkCmdSetDepthBoundsTestEnable(handle, value);
    }

    /**
        Sets whether depth writing is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setDepthWriteEnabled(bool value) {
        vkCmdSetDepthWriteEnable(handle, value);
    }

    /**
        Sets whether stencil testing is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setStencilTestEnabled(bool value) {
        vkCmdSetStencilTestEnable(handle, value);
    }

    /**
        Sets whether depth bias is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setDepthBiasEnabled(bool value) {
        vkCmdSetDepthBiasEnable(handle, value);
    }

    /**
        Sets whether primitive restart is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setPrimitiveRestartEnabled(bool value) {
        vkCmdSetPrimitiveRestartEnable(handle, value);
    }

    /**
        Sets whether rasterizer discard is enabled.

        Params:
            value = The value to set.

        Note:
            Only usable in dynamic rendering mode.
    */
    void setRasterDiscardEnabled(bool value) {
        vkCmdSetRasterizerDiscardEnable(handle, value);
    }

    /**
        Creates a pipeline barrier.

        Params:
            dependencies = The dependencies of the barrier.
    */
    void barrier(VkDependencyInfo dependencies) {
        vkCmdPipelineBarrier2(handle, &dependencies);
    }

    /**
        Creates a pipeline barrier.

        Params:
            barrier = A single barrier to apply.
    */
    void barrier(VkImageMemoryBarrier2 barrier) {
        auto depInfo = VkDependencyInfo(
            imageMemoryBarrierCount: 1,
            pImageMemoryBarriers: &barrier,
        );
        vkCmdPipelineBarrier2(handle, &depInfo);
    }

    /**
        Clears the bound attachments.

        Params:
            attachments = Slice of attachment clearing options.
    */
    void clearAttachments(VkClearAttachment[] attachments) {
        vkCmdClearAttachments(handle, cast(uint)attachments.length, attachments.ptr, 0, null);
    }

    /**
        Submits a drawing operation to the command buffer.

        Params:
            vertexCount =   The amount of vertices to draw.
            instanceCount = How many instances to draw.
            firstVertex =   Offset to the first vertex in the bound vertex buffers.
            firstInstance = Offset to the first instance.
    */
    void draw(uint vertexCount, uint instanceCount = 1, uint firstVertex = 0, uint firstInstance = 0) {
        vkCmdDraw(handle, vertexCount, instanceCount, firstVertex, firstInstance);
    }

    /**
        Submits a drawing operation to the command buffer.

        Params:
            indexCount =    The amount of indices to draw.
            instanceCount = How many instances to draw.
            firstIndex =    Offset to the first index in the bound index buffer.
            vertexOffset =  Constant offset to apply to the indices.
            firstInstance = Offset to the first instance.
    */
    void drawIndexed(uint indexCount, uint instanceCount = 1, uint firstIndex = 0, uint vertexOffset = 0, uint firstInstance = 0) {
        vkCmdDrawIndexed(handle, indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
    }
}