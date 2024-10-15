/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.cmdbuffer;
import nuvk.core;
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
        Mesh shader stage
    */
    mesh,

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
    Scope of a barrier
*/
enum NuvkBarrierScope {

    /**
        Barrier affects buffers
    */
    buffers,
    
    /**
        Barrier affects render targets
    */
    renderTargets,
    
    /**
        Barrier affects textures
    */
    textures
}

/**
    Load operation for an attachment
*/
enum NuvkLoadOp {
    /**
        GPU may discard existing content.

        Data after discard is undefined.
    */
    dontCare,

    /**
        GPU should load the existing image data.
    */
    load,
    
    /**
        GPU should clear the existing image data.
    */
    clear
}

/**
    Store operation for an attachment
*/
enum NuvkStoreOp {

    /**
        GPU may discard existing content.

        Data after discard is undefined.
    */
    dontCare,
    
    /**
        GPU should store new image data into the texture
    */
    store,

    /**
        GPU resolves multisampled textures to 1 sample per pixel.

        Data is stored in the resolve texture.
    */
    multisampleResolve,

    /**
        GPU stores multisampled data to multisample texture, 
        resolves the data to 1 sample per pixel
        and stores the result in the resolve texture.
    */
    storeAndMultisampleResolve
}

/**
    Blending operation
*/
enum NuvkBlendOp {
    add,
    subtract,
    reverseSubtract,
    min,
    max
}

/**
    Blending factor
*/
enum NuvkBlendFactor {
    zero,
    one,
    srcColor,
    srcAlpha,
    srcAlphaSaturated,
    oneMinusSrcColor,
    oneMinusSrcAlpha,
    dstColor,
    dstAlpha,
    oneMinusDstColor,
    oneMinusDstAlpha,
}

/**
    Color attachment info
*/
struct NuvkColorAttachment {

    /**
        Attached texture
    */
    NuvkTextureView texture;
    
    /**
        Texture load operation
    */
    NuvkLoadOp loadOp;
    
    /**
        Texture store operation
    */
    NuvkStoreOp storeOp;
    
    /**
        Attached resolve texture.

        This may be null if `storeOp` is NOT `multisampleResolve`.
    */
    NuvkTextureView resolveTexture;

    /**
        The value to clear with if `loadOp` is `clear`.
    */
    NuvkClearValue clearValue;

    /**
        Whether blending is enabled
    */
    bool isBlendingEnabled = true;
    
    /**
        The blending operation to use
    */
    NuvkBlendOp blendOpColor = NuvkBlendOp.add;
    
    /**
        The blending operation to use
    */
    NuvkBlendOp blendOpAlpha = NuvkBlendOp.add;
    
    /**
        The source color blending factor
    */
    NuvkBlendFactor sourceColorFactor = NuvkBlendFactor.srcAlpha;

    /**
        The source alpha blending factor
    */
    NuvkBlendFactor sourceAlphaFactor = NuvkBlendFactor.oneMinusSrcAlpha;
    
    /**
        The destination color blending factor
    */
    NuvkBlendFactor destinationColorFactor = NuvkBlendFactor.srcAlpha;
    
    /**
        The destination alpha blending factor
    */
    NuvkBlendFactor destinationAlphaFactor = NuvkBlendFactor.oneMinusSrcAlpha;
}

/**
    A render pass attachment
*/
struct NuvkDepthStencilAttachment {
@nogc:

    /**
        Attached texture
    */
    NuvkTextureView texture;
    
    /**
        Texture load operation
    */
    NuvkLoadOp loadOp;
    
    /**
        Texture store operation
    */
    NuvkStoreOp storeOp;
    
    /**
        Attached resolve texture.

        This may be null if `storeOp` is NOT `multisampleResolve`.
    */
    NuvkTextureView resolveTexture;

    /**
        The value to clear with if `loadOp` is `clear`.
    */
    NuvkClearValue clearValue;
}

/**
    Describes a rendering pass
*/
struct NuvkRenderPassDescriptor {
@nogc nothrow:

    /**
        Shader program to use for the pass
    */
    NuvkShaderProgram shader;

    /**
        The rendering area

        By default it will render to everything.
    */
    recti renderArea = recti(0, 0, int.max, int.max);

    /**
        Color attachment for the render pass
    */
    weak_vector!NuvkColorAttachment colorAttachments;

    /**
        Depth-stencil attachment for the render pass
    */
    NuvkDepthStencilAttachment depthStencilAttachment;

    /**
        Indicates whether to use the alpha channel
        to create a sampler coverage mask.
    */
    bool isAlphaToCoverageEnabled = false;

    /**
        Whether to force alpha values to the highest possible value.
    */
    bool isAlphaToOneEnabled = false;

    /**
        Whether rasterization is enabled.
    */
    bool isRasterizationEnabled = true;
}

/**
    Dispatch type for compute shaders.
*/
enum NuvkDispatchType {
    /**
        Compute commands are executed in series.
    */
    serial,

    /**
        Compute commands may be executed in parallel.
    */
    parallel
}

/**
    Describes a compute pass
*/
struct NuvkComputePassDescriptor {

    /**
        Shader program to use for the pass
    */
    NuvkShaderProgram shader;

    /**
        How the pass should dispatch compute operations.
    */
    NuvkDispatchType dispatchType;
}

/**
    A command buffer

    Command buffers store commands to send to the GPU.
*/
abstract
class NuvkCommandBuffer : NuvkDeviceObject {
@nogc:
private:

    // Submissions which are waiting.
    size_t waiting;
    size_t commits;

    NuvkSemaphore submissionFinished;
    NuvkFence inFlightFence;

    NuvkQueue queue;
    NuvkCommandBufferStatus status;

    void updateStatus() {
        if (this.getStatus() == NuvkCommandBufferStatus.submitted) {
            
            if (inFlightFence.isSignaled()) {

                // Rendering is completed.
                this.setStatus(NuvkCommandBufferStatus.idle);
                inFlightFence.reset();
            }
        }
    }

    bool beginPass() {

        if (this.getStatus() == NuvkCommandBufferStatus.idle) {

            // Buffer was ready, begin new pass.
            this.setStatus(NuvkCommandBufferStatus.recording);
            this.onBeginNewPass();
            commits = 0;
        }

        return this.getStatus() == NuvkCommandBufferStatus.recording;
    }

    void finishEncoding(NuvkEncoder encoder) {
        this.onEncoderFinished(encoder);
        nogc_delete(encoder);
    }

protected:

    /**
        Sets the state of the buffer
    */
    final
    void setStatus(NuvkCommandBufferStatus status) {
        this.status = status;
    }

    /**
        Gets the submission fence.
    */
    final
    NuvkFence getInFlightFence() {
        return inFlightFence;
    }

    /**
        Gets the submission fence.
    */
    final
    NuvkSemaphore getSubmissionFinished() {
        return submissionFinished;
    }

    /**
        Implements the logic to begin a new pass of command encoding.
    */
    abstract void onBeginNewPass();

    /**
        Implements the logic to create a NuvkRenderEncoder.
    */
    abstract NuvkRenderEncoder onBeginRenderPass(ref NuvkRenderPassDescriptor descriptor);

    /**
        Implements the logic to create a NuvkComputeEncoder.
    */
    abstract NuvkComputeEncoder onBeginComputePass(ref NuvkComputePassDescriptor descriptor);

    /**
        Implements the logic to create a NuvkTransferEncoder.
    */
    abstract NuvkTransferEncoder onBeginTransferPass();

    /**
        Implements the logic to finish encoding.
    */
    abstract void onEncoderFinished(NuvkEncoder encoder);

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    abstract void onCommit(bool shouldWait);

    /**
        Presents the surface
    */
    abstract void onPresent(NuvkSurface surface);

public:

    /**
        Creates a command buffer
    */
    this(NuvkDevice device, NuvkQueue queue) {
        super(device);
        this.queue = queue;
        this.status = NuvkCommandBufferStatus.idle;

        this.inFlightFence = device.createFence();
        this.inFlightFence.reset();

        this.submissionFinished = device.createSemaphore();
    }

    /**
        Begins a render pass, returning a lightweight
        NuvkRenderEncoder.
    */
    final
    NuvkRenderEncoder beginRenderPass(ref NuvkRenderPassDescriptor renderPassDescriptor) {
        nuvkEnforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.graphics),
            "Queue does not support encoding render commands!"
        );

        this.updateStatus();
        if (this.beginPass())
            return this.onBeginRenderPass(renderPassDescriptor);
        else 
            return null;
    }

    /**
        Begins a compute pass, returning a lightweight
        NuvkComputeEncoder.
    */
    final
    NuvkComputeEncoder beginComputePass(ref NuvkComputePassDescriptor computePassDescriptor) {
        nuvkEnforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.compute),
            "Queue does not support encoding compute commands!"
        );

        this.updateStatus();
        if (this.beginPass())
            return this.onBeginComputePass(computePassDescriptor);
        else 
            return null;
    }

    /**
        Begins a transfer pass, returning a lightweight
        NuvkTransferEncoder.
    */
    final
    NuvkTransferEncoder beginTransferPass() {
        nuvkEnforce(
            (queue.getSpecialization() & NuvkQueueSpecialization.transfer),
            "Queue does not support encoding transfer commands!"
        );

        this.updateStatus();
        if (this.beginPass())
            return this.onBeginTransferPass();
        else 
            return null;
    }

    /**
        Resets the command buffer.
    */
    final
    void reset() {
        auto device = this.getOwner();
        device.awaitAll();
        
        // Reset synchronization
        nogc_delete(submissionFinished);
        this.inFlightFence.reset();
        this.submissionFinished = device.createSemaphore();

        // Reset status.
        this.setStatus(NuvkCommandBufferStatus.idle);
        this.updateStatus();
        this.beginPass();
    }

    /**
        Presents the surface
    */
    final
    void present(NuvkSurface surface) {
        this.onPresent(surface);
        waiting++;
    }

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */
    final
    void commit() {
        this.onCommit(commits != 0 && waiting == 0);
        
        waiting = 0;
        commits++;
    }

    /**
        Blocks the current thread until the command queue
        is finished rendering the buffer.
    */
    final
    void awaitCompletion(ulong timeout = ulong.max) {
        if (this.getStatus() == NuvkCommandBufferStatus.submitted) {
            inFlightFence.await(timeout);
            this.updateStatus();
        }
    }

    /**
        Gets the queue associated with this command buffer.
    */
    final
    NuvkQueue getQueue() {
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
    void* handle;

protected:

    /**
        Called by the implementation when the encoding begins
    */
    abstract void onBegin(ref NuvkCommandBuffer buffer);

    /**
        Called by the implementation when the encoding ends.

        Should return a handle to the finished command list if applicable.
    */
    abstract void onEnd(ref NuvkCommandBuffer buffer);

public:

    /**
        Destructor
    */
    ~this() {
        commandBuffer = null;
    }

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer, void* handle) {
        this.handle = handle;
        this.commandBuffer = buffer;
        this.onBegin(buffer);
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
        Ends encoding the commands to the buffer.

        This renders this encoder instance invalid.
        Do not try to use a encoder after ending it.
    */
    final
    void endEncoding() {
        this.onEnd(commandBuffer);
        commandBuffer.finishEncoding(this);
    }

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

    /**
        Gets the underlying handle for the encoder.
    */
    final
    void* getHandle() {
        return handle;
    }
}

/**
    A lightweight object for submitting rendering commands
    to a command buffer.
*/
abstract
class NuvkRenderEncoder : NuvkEncoder {
@nogc:
private:
    NuvkRenderPassDescriptor descriptor;

protected:

    /**
        Gets the descriptor for a render pass.
    */
    final
    ref NuvkRenderPassDescriptor getDescriptor() {
        return descriptor;
    }

public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer, void* handle, ref NuvkRenderPassDescriptor descriptor) {
        this.descriptor = descriptor;
        super(buffer, handle);
    }

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
        Sets a buffer for the vertex shader.
    */
    abstract void setVertexBuffer(NuvkBuffer buffer, uint offset, int index);

    /**
        Sets a buffer for the fragment shader.
    */
    abstract void setFragmentBuffer(NuvkBuffer buffer, uint offset, int index);

    /**
        Sets a texture for the fragment shader.
    */
    abstract void setFragmentTexture(NuvkTextureView texture, int index);

    /**
        Sets a sampler for the fragment shader.
    */
    abstract void setFragmentSampler(NuvkSampler sampler, int index);

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
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        This will additionally transition the layout of the texture to the specified layout.

        Parameters:
            `resource` the texture to create a barrier for and transition.
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
            `toLayout` the layout the texture will be after the transition.
    */
    abstract void waitFor(NuvkTexture resource, NuvkRenderStage after, NuvkRenderStage before, NuvkTextureLayout toLayout);

    /**
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        Parameters:
            `scope_` The resource scope to wait for..
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
    */
    abstract void waitFor(NuvkBarrierScope scope_, NuvkRenderStage after, NuvkRenderStage before);

    /**
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        Parameters:
            `resource` a Nuvk resource, such as a texture or buffer.
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
    */
    abstract void waitFor(NuvkResource resource, NuvkRenderStage after, NuvkRenderStage before);
}

/**
    A lightweight object for submitting compute commands
    to a command buffer.
*/
abstract
class NuvkComputeEncoder : NuvkEncoder {
@nogc:
private:
    NuvkComputePassDescriptor descriptor;

protected:

    /**
        Gets the descriptor for the compute pass.
    */
    final
    ref NuvkComputePassDescriptor getDescriptor() {
        return descriptor;
    }

public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer, void* handle, ref NuvkComputePassDescriptor computePassDescriptor) {
        this.descriptor = computePassDescriptor;
        super(buffer, handle);
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
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        This will additionally transition the layout of the texture to the specified layout.

        Parameters:
            `resource` the texture to create a barrier for and transition.
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
            `toLayout` the layout the texture will be after the transition.
    */
    abstract void waitFor(NuvkTexture resource, NuvkTextureLayout toLayout);

    /**
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        Parameters:
            `scope_` The resource scope to wait for..
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
    */
    abstract void waitFor(NuvkBarrierScope scope_);

    /**
        Encodes a rendering barrier that enforces a specific order for 
        read/write operations.

        Parameters:
            `resource` a Nuvk resource, such as a texture or buffer.
            `after` the stage which this barrier will be **after**
            `before` the **subsequent** stage after this barrier. 
    */
    abstract void waitFor(NuvkResource resource);
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
    this(NuvkCommandBuffer buffer, void* handle) {
        super(buffer, handle);
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
        Copies data between 2 textures
    */
    abstract void copy(NuvkTexture from, recti fromArea, NuvkTexture to, vec2i toPosition, uint arraySlice = 0, uint mipLevel = 0);

    /**
        Copies data between a buffer and a texture

        Parameters:
            `from` - The buffer to copy from
            `offset` - Offset, in bytes, into the buffer to copy from
            `rowStrde` - How many bytes there are in a row of pixels in the buffer
            `to` - The texture to copy to
            `toArea` - The width and height to copy, and the destination coordinates in the texture to put them.
            `arraySlice` - The texture array slice to copy into.
            `mipLevel` - The texture mip level to copy into.
    */
    abstract void copy(NuvkBuffer from, uint offset, uint rowStride, NuvkTexture to, recti toArea, uint arraySlice = 0, uint mipLevel = 0);

    /**
        Copies data between a texture and a buffer

        Parameters:
            `from` - The texture to copy from
            `fromArea` - The area to copy.
            `to` - The texture to copy to
            `offset` - Offset, in bytes, into the buffer to copy to
            `rowStrde` - How many bytes there are in a row of pixels in the buffer
            `arraySlice` - The texture array slice to copy from.
            `mipLevel` - The texture mip level to copy from.
    */
    abstract void copy(NuvkTexture from, recti fromArea, NuvkBuffer to, uint offset, uint rowStride, uint arraySlice = 0, uint mipLevel = 0);

    /**
        Encodes a command which optimizes the texture for the specified usage.
    */
    abstract void optimizeTextureFor(NuvkTexture texture, NuvkTextureLayout layout);

    /**
        Encodes a command which synchronizes the resource between CPU and GPU.
    */
    abstract void synchronize(NuvkResource resource);
}