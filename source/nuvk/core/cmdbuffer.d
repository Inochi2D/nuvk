/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

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
    Sets the filling mode for triangles
*/
enum NuvkFillMode {

    /**
        Draw triangles filled
    */
    fill,
    
    /**
        Draw triangle outlines
    */
    lines
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
    Rendering stages
*/
enum NuvkRenderStage {

    /**
        Vertex shader stage
    */
    vertex,
    
    /**
        Fragment shader stage
    */
    fragment,
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

    /**
        Implements the logic to create a NuvkRenderEncoder.
    */
    abstract NuvkRenderEncoder onBeginRenderPass();

    /**
        Implements the logic to create a NuvkComputeEncoder.
    */
    abstract NuvkComputeEncoder onBeginComputePass();

    /**
        Implements the logic to create a NuvkTransferEncoder.
    */
    abstract NuvkTransferEncoder onBeginTransferPass();

public:

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkCommandQueue queue) {
        super(device);
        this.queue = queue;
        this.status = NuvkCommandBufferStatus.idle;
    }

    /**
        Begins a render pass, returning a lightweight
        NuvkRenderEncoder.
    */
    final
    NuvkRenderEncoder beginRenderPass() {
        enforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.graphics),
            nstring("Queue does not support encoding render commands!")
        );

        return this.onBeginRenderPass();
    }

    /**
        Begins a compute pass, returning a lightweight
        NuvkComputeEncoder.
    */
    final
    NuvkComputeEncoder beginComputePass() {
        enforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.compute),
            nstring("Queue does not support encoding compute commands!")
        );

        return this.onBeginComputePass();
    }

    /**
        Begins a transfer pass, returning a lightweight
        NuvkTransferEncoder.
    */
    final
    NuvkTransferEncoder beginTransferPass() {
        enforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.transfer),
            nstring("Queue does not support encoding transfer commands!")
        );

        return this.onBeginTransferPass();
    }

    /**
        Resets the command buffer.

        This allows reusing the command buffer between frames.
    */
    abstract bool reset();

    /**
        Presents the surface
    */
    abstract void present(NuvkSurface surface);

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    abstract void commit();

    /**
        Blocks the current thread until the command queue
        is finished rendering the buffer.
    */
    abstract void awaitCompletion();

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


abstract
class NuvkEncoder {
@nogc:
private:
    NuvkCommandBuffer commandBuffer;

public:

    // We don't own any memory.
    ~this() { }

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer) {
        this.commandBuffer = buffer;
    }

    /**
        Pushes a debug group onto the command buffer's stack
        This is useful for render debugging.
    */
    abstract void pushDebugGroup(nstring name);

    /**
        Pops a debug group from the command buffer's stack
        This is useful for render debugging.
    */
    abstract void popDebugGroup();

    /**
        Encodes a command that makes the GPU wait for a fence.
    */
    abstract void waitFor(NuvkFence fence, NuvkRenderStage before);

    /**
        Encodes a command that makes the GPU signal a fence.
    */
    abstract void signal(NuvkFence fence, NuvkRenderStage after);

    /**
        Ends encoding the commands to the buffer.
    */
    abstract void endEncoding();

    /**
        Gets the device which this encoder belongs to.
    */
    final
    NuvkDevice getOwner() {
        return commandBuffer.getOwner();
    }

    /**
        Gets the command buffer the encoder belongs to
    */
    final
    NuvkCommandBuffer getCommandBuffer() {
        return commandBuffer;
    }
}

/**
    A lightweight object for submitting rendering commands
    to a command buffer.
*/
abstract
class NuvkRenderEncoder : NuvkEncoder {
@nogc:
public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer) {
        super(buffer);
    }

    /**
        Sets the active pipeline
    */
    abstract void setPipeline(NuvkPipeline pipeline);

    /**
        Configures the active rendering pipeline with 
        the specified viewport.
    */
    abstract void setViewport(recti viewport);

    /**
        Configures the active rendering pipeline with 
        the specified scissor rectangle.
    */
    abstract void setScissorRect(recti scissor);

    /**
        Configures the active rendering pipeline with 
        the specified culling mode.
    */
    abstract void setCulling(NuvkCulling culling);

    /**
        Configures the active rendering pipeline with 
        the specified triangle front face winding.
    */
    abstract void setFrontFace(NuvkWinding winding);

    /**
        Configures the active rendering pipeline with 
        the specified triangle fill mode.
    */
    abstract void setFillMode(NuvkFillMode fillMode);

    /**
        Sets the vertex buffer in use.
    */
    abstract void setVertexBuffer(NuvkBuffer buffer, uint offset, uint stride, int index);

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state.
    */
    abstract void draw(NuvkPrimitive primitive, uint offset, uint count);

    /**
        Encodes a command which makes the command buffer draw
        the currently bound render state, using a index buffer
        to iterate over the vertex buffers.
    */
    abstract void drawIndexed(NuvkPrimitive primitive, uint offset, uint count);

    /**
        Encodes a rendering barrier that enforces 
        a specific order for read/write operations.
    */
    abstract void waitBarrier(NuvkResource resource, NuvkRenderStage before, NuvkRenderStage after);
}

/**
    A lightweight object for submitting compute commands
    to a command buffer.
*/
abstract
class NuvkComputeEncoder : NuvkEncoder {
@nogc:
public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer) {
        super(buffer);
    }

    /**
        Sets a buffer in the compute pass
    */
    abstract void setBuffer(NuvkBuffer buffer, uint offset, int index);

    /**
        Sets a texture in the compute pass
    */
    abstract void setTexture(NuvkTexture buffer, int index);

    /**
        Sets a sampler in the compute pass
    */
    abstract void setSampler(NuvkSampler buffer, int index);

    /**
        Dispatches the compute kernel
    */
    abstract void dispatch(vec3i groupCounts);

    /**
        Encodes a rendering barrier that enforces 
        a specific order for read/write operations.
    */
    abstract void waitBarrier(NuvkResource resource, NuvkRenderStage before, NuvkRenderStage after);
}

/**
    Optimization mode to use for texture optimization state changes
*/
enum NuvkOptimizationMode {

    /**
        Optimize for CPU access
    */
    optimizeForCPU,
    
    /**
        Optimize for GPU access
    */
    optimizeForGPU
}

/**
    A lightweight object for submitting transfer commands
    to a command buffer.
*/
abstract
class NuvkTransferEncoder : NuvkEncoder {
@nogc:
public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer) {
        super(buffer);
    }

    /**
        Submits a command which generates mipmaps for the
        specified texture
    */
    abstract void generateMipmaps(NuvkTexture texture);

    /**
        Copies data between 2 buffers
    */
    abstract void copy(NuvkBuffer from, uint sourceOffset, NuvkBuffer to, uint destOffset, uint size);

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
    abstract void copy(NuvkBuffer from, uint sourceOffset, uint sourcePxStride, recti copyRange, NuvkTexture to, uint arraySlice = 0, uint mipLevel = 0);

    /**
        Copies data between 2 textures
    */
    abstract void copy(NuvkTexture from, NuvkTexture to);

    /**
        Encodes a command which optimizes the texture for the specified usage.
    */
    abstract void optimizeTextureFor(NuvkTexture texture, NuvkOptimizationMode mode, uint arraySlice = 0, uint mipLevel = 0);

    /**
        Encodes a command which synchronizes the resource between CPU and GPU.
    */
    abstract void synchronize(NuvkResource resource);
}