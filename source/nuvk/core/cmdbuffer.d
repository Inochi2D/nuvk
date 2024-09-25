module nuvk.core.cmdbuffer;
import nuvk.core;
import nuvk.spirv;
import numem.all;
import inmath.linalg;

/**
    Winding of vertices used to determine the front face of a triangle.
*/
enum NuvkWinding {

    /**
        Front face is encoded as screen-space clockwise vertices
    */
    clockwise,
    
    /**
        Front face is encoded as screen-space counter-clockwise vertices
    */
    counterClockwise
}

/**
    Sets the culling mode
*/
enum NuvkCulling {

    /**
        Back-face culling
    */
    backFace,

    /**
        Front-face culling
    */
    frontFace,

    /**
        Disable culling
    */
    none
}

/**
    Primitives that can be rendered
*/
enum NuvkPrimitive {

    /**
        Primitive is points
    */
    points,
    
    /**
        Primitive is lines
    */
    lines,

    /**
        Primitive is a line strip.

        Also called a polyline
    */
    lineStrip,
    
    /**
        Primitive is triangles
    */
    triangles,
    
    /**
        Primitive is triangle strip.

        For every 3 adjacent vertices, draw a triangle.
    */
    triangleStrip
}

/**
    Action GPU should perform at the end of the rendering pass.
*/
enum NuvkStoreAction {
    
    /**
        GPU should store rendered contents to the texture
    */
    store,

    /**
        GPU should discard rendered contents
    */
    discard
}

/**
    The status of a command buffer
*/
enum NuvkCommandBufferStatus {

    /**
        Command buffer is idle.

        Recording can be begun by calling begin()
    */
    idle,

    /**
        Command buffer is being recorded to.

        Recording can be ended by calling end()
    */
    recording,

    /**
        Recording to the command buffer has finished.

        Recording can be submitted by calling submit()
    */
    completed,

    /**
        The command buffer has been submitted.

        You may not reset the command buffer while it's under submission.
        Status will return to completed when execution is completed.
    */
    submitted,

    /**
        Command buffer is in an invalid state.
    */
    invalid,
}

/**
    Usage for the command buffer.
*/
enum NuvkCommandBufferUsage {
    
    /**
        Buffer is recorded once, then reused.
    */
    oneShot,

    /**
        Command buffer is reusable, clearing its contents
        after submission.
    */
    reusable
}

/**
    A command buffer

    Command buffers store commands to send to the GPU.
*/
abstract
class NuvkCommandBuffer : NuvkDeviceObject {
@nogc:
private:
    NuvkCommandQueue queue;
    NuvkCommandBufferStatus status;

protected:

    /**
        Sets the state of the buffer
    */
    final
    void setStatus(NuvkCommandBufferStatus status) {
        this.status = status;
    }

public:

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkCommandQueue queue) {
        super(device, NuvkProcessSharing.processLocal);
        this.queue = queue;
        this.status = NuvkCommandBufferStatus.idle;
    }

    /**
        Resets the command buffer; allowing the buffer to be re-recorded.
    */
    abstract bool reset();

    /**
        Begins recording into the command buffer
    */
    abstract bool begin();

    /**
        Ends recording into the command buffer
    */
    abstract bool end();

    /**
        Sets the vertex buffer being used for rendering.
    */
    abstract void setVertexBuffer(NuvkBuffer vertexBuffer, uint offset, uint stride, uint index);

    /**
        Sets the index buffer being used for rendering.
    */
    abstract void setIndexBuffer(NuvkBuffer indexBuffer, uint offset, NuvkBufferIndexType indexType);

    /**
        Configures the command buffer to use the specified pipeline
    */
    abstract void setPipeline(NuvkPipeline pipeline);

    /**
        Configures what winding is used for the front face for rendering
    */
    abstract void setFrontFace(NuvkWinding winding);

    /**
        Configures the culling mode used for rendering
    */
    abstract void setCulling(NuvkCulling culling);

    /**
        Configures the viewport
    */
    abstract void setViewport(rect viewport);

    /**
        Configures the scissor rectangle
    */
    abstract void setScissorRect(rect scissor);

    /**
        Sets the store action for the specified color
    */
    abstract void setColorStoreAction(NuvkStoreAction action, uint color);

    /**
        Sets the store action for the stencil buffer
    */
    abstract void setStencilStoreAction(NuvkStoreAction action);

    /**
        Sets the store action for the depth buffer
    */
    abstract void setDepthStoreAction(NuvkStoreAction action);

    /**
        Sets the color for the constant blend color blending mode.
    */
    abstract void setBlendColor(float r, float g, float b,float a);

    /**
        Draws a primitive
    */
    abstract void draw(NuvkPrimitive primitive, uint start, uint count);

    /**
        Draws a primitive using bound index buffers
    */
    abstract void drawIndexed(NuvkPrimitive primitive, uint start, uint count);

    /**
        Submit the current contents of the command buffer
        into the command queue the buffer was created from.
    */
    abstract void submit(NuvkFence signalFence);

    /**
        Gets the queue kind associated with this command buffer.

        The queue kind specifies which operations are possible.
    */
    final
    NuvkCommandQueueKind getQueueKind() {
        return queue.getQueueKind();
    }

    /**
        Gets the queue associated with this command buffer.
    */
    final
    NuvkCommandQueue getQueue() {
        return queue;
    }

    /**
        Gets the current state of the buffer
    */
    final
    NuvkCommandBufferStatus getStatus() {
        return status;
    }
}