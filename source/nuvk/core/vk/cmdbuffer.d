module nuvk.core.vk.cmdbuffer;
import nuvk.core.vk;
import nuvk.core;
import numem.all;
import inmath;
/**
    Command buffer
*/
class NuvkVkCommandBuffer : NuvkCommandBuffer {
@nogc:
private:
    VkCommandBuffer commandBuffer;
    VkCommandPool pool;


    void createCommandBuffer() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkCommandBufferAllocateInfo commandBufferInfo;
        commandBufferInfo.commandPool = pool;
        commandBufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        commandBufferInfo.commandBufferCount = 1;

        enforce(
            vkAllocateCommandBuffers(device, &commandBufferInfo, &commandBuffer),
            nstring("Failed to allocate command buffer")
        );
    }

public:

    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (commandBuffer != VK_NULL_HANDLE)
            vkFreeCommandBuffers(device, pool, 1, &commandBuffer);
    }

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkCommandQueue queue, VkCommandPool pool) {
        super(device, queue);
        this.pool = pool;

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
        Sets the vertex buffer being used for rendering.
    */
    override
    void setVertexBuffer(NuvkBuffer vertexBuffer, uint offset, uint stride, uint index) {
        
    }

    /**
        Sets the index buffer being used for rendering.
    */
    override
    void setIndexBuffer(NuvkBuffer indexBuffer, uint offset, uint stride, uint index) {
        
    }

    /**
        Configures the command buffer to use the specified pipeline
    */
    override
    void setPipeline(NuvkPipeline pipeline) {
        
    }

    /**
        Configures what winding is used for the front face for rendering
    */
    override
    void setFrontFace(NuvkWinding winding) {
        
    }

    /**
        Configures the culling mode used for rendering
    */
    override
    void setCulling(NuvkCulling culling) {
        
    }

    /**
        Configures the viewport
    */
    override
    void setViewport(rect viewport) {
        
    }

    /**
        Configures the scissor rectangle
    */
    override
    void setScissorRect(rect scissor) {
        
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
        
    }

    /**
        Draws a primitive
    */
    override
    void draw(NuvkPrimitive primitive, uint start, uint count) {
        
    }

    /**
        Draws a primitive using bound index buffers
    */
    override
    void drawIndexed(NuvkPrimitive primitive, uint start, uint count) {
        
    }

    /**
        Submit the current contents of the command buffer
        into the command queue the buffer was created from.
    */
    override
    void submit() {

    }
}

