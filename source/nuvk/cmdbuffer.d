/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.cmdbuffer;
import nuvk;
import numem.all;
import inmath.linalg;

/**
    A command buffer

    Command buffers store commands to send to the GPU.
*/
abstract
class NuvkCommandBuffer : NuvkQueueObject {
@nogc:
private:

    NuvkEncoder cEncoder;
    NuvkFence inFlightFence;
    NuvkSemaphore submitSemaphore;
    bool isFinalized_;

    NuvkCommandBufferStatus status;
    weak_vector!NuvkSurface toSwap;

    void endPass() {
        nogc_delete(cEncoder);
        cEncoder = null;
    }

    bool beginPass() {
        
        // Active encoder needs to be finished before a new pass.
        if (this.isWriteLocked)
            return false;

        return true;
    }

protected:

    /**
        Sets the state of the buffer
    */
    final
    void setStatus(NuvkCommandBufferStatus status) {
        if (status >= this.status)
            this.status = status;
    }

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
        Called by the implementation when the command buffer begins
        recording.

        Returns whether beginning the command buffer succeeded.
    */
    abstract bool onBegin();

    /**
        Called by the implementation when the command buffer ends
        recording.
    */
    abstract void onEnd();

package(nuvk):

    /**
        Internal: Notifies the command buffer that it has been enqueued.
    */
    final
    void notifyEnqueue() {
        this.setStatus(NuvkCommandBufferStatus.enqueued);
    }

    /**
        Internal: Notifies the command buffer that it has been submitted.
    */
    final
    void notifySubmit() {
        this.setStatus(NuvkCommandBufferStatus.submitted);
    }

public:

    /**
        Destructor
    */
    ~this() {
        if (cEncoder)
            nogc_delete(cEncoder);

        if (inFlightFence) 
            nogc_delete(inFlightFence);

        if (submitSemaphore) 
            nogc_delete(submitSemaphore);

        nogc_delete(toSwap);
    }

    /**
        Creates a command buffer
    */
    this(NuvkQueue queue) {
        super(queue);
        this.status = NuvkCommandBufferStatus.idle;

        this.inFlightFence = this.getOwner().createFence();
        this.inFlightFence.reset();

        this.submitSemaphore = this.getOwner().createSemaphore();
        this.onBegin();
    }

    /**
        Begins a render pass, returning a lightweight
        NuvkRenderEncoder.
    */
    final
    NuvkRenderEncoder beginRenderPass(ref NuvkRenderPassDescriptor renderPassDescriptor) {
        nuvkEnforce(
            (this.getQueue().getSpecialization() & NuvkQueueSpecialization.graphics),
            "Queue does not support encoding render commands!"
        );

        if (this.beginPass())
            return this.onBeginRenderPass(renderPassDescriptor);
        
        return null;
    }

    /**
        Begins a compute pass, returning a lightweight
        NuvkComputeEncoder.
    */
    final
    NuvkComputeEncoder beginComputePass(ref NuvkComputePassDescriptor computePassDescriptor) {
        nuvkEnforce(
            (this.getQueue().getSpecialization() & NuvkQueueSpecialization.compute),
            "Queue does not support encoding compute commands!"
        );

        if (this.beginPass())
            return this.onBeginComputePass(computePassDescriptor);

        return null;
    }

    /**
        Begins a transfer pass, returning a lightweight
        NuvkTransferEncoder.
    */
    final
    NuvkTransferEncoder beginTransferPass() {
        nuvkEnforce(
            (this.getQueue().getSpecialization() & NuvkQueueSpecialization.transfer),
            "Queue does not support encoding transfer commands!"
        );

        if (this.beginPass())
            return this.onBeginTransferPass();
        
        return null;
    }

    /**
        Presents the surface
    */
    final
    void present(NuvkSurface surface) {
        if (this.isWritable)
            toSwap ~= surface;
    }

    /**
        Commits the commands stored in the command buffer
        to the command queue
    */ 
    final
    void commit() {
        if (this.isComitted)
            return;

        if (!this.isEnqueued) {
            if (!this.getQueue().reserve(this))
                return;
        }

        this.onEnd();
        this.setStatus(NuvkCommandBufferStatus.comitted);
        this.sendSubmitRequest();
    }

    /**
        Blocks the current thread until the command queue
        is finished rendering the buffer.
    */
    final
    void awaitCompletion(ulong timeout = ulong.max) {
        if (this.hasBeenSubmitted) {
            inFlightFence.await(timeout);
        }
    }

    /**
        Gets the current state of the buffer
    */
    final
    NuvkCommandBufferStatus getStatus() {

        // Update the status automatically.
        if (this.status == NuvkCommandBufferStatus.submitted) {
            if (inFlightFence.isSignaled())
                this.status = NuvkCommandBufferStatus.completed;
        }

        return status;
    }

    /**
        Gets the submission sempahore for GPU-side synchronization.
    */
    final
    NuvkSemaphore getSubmissionSemaphore() => submitSemaphore;

    /**
        Gets the "in-flight" fence.
    */
    final
    NuvkFence getInFlightFence() => inFlightFence;

    /**
        Gets the presentation requests.
    */
    final
    NuvkSurface[] getPresentRequests() => toSwap[];

    /**
        Whether the command buffer is writable.
    */
    final
    bool isWritable() => this.getStatus() <= NuvkCommandBufferStatus.enqueued;

    /**
        Gets whether writing operations are locked due to an encoder being
        in-progress.
    */
    final
    bool isWriteLocked() => isWritable && cEncoder !is null;

    /**
        Gets whether the command buffer is enqueued.
    */
    final
    bool isEnqueued() => this.getStatus() >= NuvkCommandBufferStatus.enqueued;

    /**
        Gets whether the command buffer is enqueued.
    */
    final
    bool isComitted() => this.getStatus() >= NuvkCommandBufferStatus.comitted;

    /**
        Gets whether the command buffer is enqueued.
    */
    final
    bool hasBeenSubmitted() => this.getStatus() >= NuvkCommandBufferStatus.submitted;

    /**
        Gets whether execution has completed in one way or another.
    */
    final
    bool isCompleted() => this.getStatus() >= NuvkCommandBufferStatus.completed;

    /**
        Gets whether the command buffer failed execution.
    */
    final
    bool hasFailed() => this.getStatus() == NuvkCommandBufferStatus.failed;
}

abstract
class NuvkEncoder {
@nogc:
private:
    NuvkCommandBuffer commandBuffer;

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
    this(NuvkCommandBuffer buffer) {
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
        commandBuffer.endPass();
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
    NuvkShaderProgram program;

protected:

    /**
        Gets the descriptor for a render pass.
    */
    final
    ref NuvkRenderPassDescriptor getDescriptor() {
        return descriptor;
    }

    /**
        Gets the program bound to the encoder.
    */
    final
    NuvkShaderProgram getProgram() {
        return program;
    }

public:

    /**
        Constructor
    */
    this(NuvkCommandBuffer buffer, ref NuvkRenderPassDescriptor descriptor) {
        this.descriptor = descriptor;
        this.program = descriptor.shader;
        super(buffer);
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
        Sets the stencil reference value.
    */
    abstract void setStencilReference(uint refValue);

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
    abstract void drawIndexed(NuvkBuffer indexBuffer, NuvkPrimitive primitive, uint offset, uint count);

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
    this(NuvkCommandBuffer buffer, ref NuvkComputePassDescriptor computePassDescriptor) {
        this.descriptor = computePassDescriptor;
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
        Command buffer is idle, but not enqueued.

        Commands may be encoded while in this state.
    */
    idle,

    /**
        Command has been enqueued for execution, but not commited.

        Commands may be encoded while in this state.
    */
    enqueued,

    /**
        Command buffer has been comitted and is awaiting submission to the command queue.

        Commands may NOT be encoded while in this state.
    */
    comitted,

    /**
        The command buffer has been submitted.

        Commands may NOT be encoded while in this state.
    */
    submitted,

    /**
        Command buffer has finished execution.
    */
    completed,

    /**
        Command buffer execution has failed.
    */
    failed,
}

/**
    Rendering stages
*/
enum NuvkRenderStage {

    /**
        Task shader stage
    */
    task,

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
    NuvkBlendFactor sourceAlphaFactor = NuvkBlendFactor.srcAlpha;
    
    /**
        The destination color blending factor
    */
    NuvkBlendFactor destinationColorFactor = NuvkBlendFactor.oneMinusSrcAlpha;
    
    /**
        The destination alpha blending factor
    */
    NuvkBlendFactor destinationAlphaFactor = NuvkBlendFactor.oneMinusSrcAlpha;
}

/**
    Stencil operation
*/
enum NuvkDepthStencilOp {

    /**
        Keep current value
    */
    keep,
    
    /**
        Set value to zero
    */
    zero,
    
    /**
        Replace value
    */
    replace,
    
    /**
        Add to value, clamp at max value.
    */
    addClamp,
    
    /**
        Subtract from value, clamp at max value.
    */
    subtractClamp,
    
    /**
        Invert the value.
    */
    invert,
    
    /**
        Add to value, wraps around.
    */
    addWrap,
    
    /**
        Subtract from value, wraps around.
    */
    subtractWrap
}

/**
    The comparison function used when doing a comparisons
    on textures.
*/
enum NuvkCompareOp {

    /**
        Test never passes
    */
    never,

    /**
        Test passes if the value in the buffer is less
        than the incoming value
    */
    less,

    /**
        Test passes if the value in the buffer is equal 
        to the incoming value
    */
    equal,

    /**
        Test passes if the value in the buffer is less than 
        or equal to the incoming value.
    */
    lessEqual,

    /**
        Test passes if the value in the buffer is greater 
        than the incoming value
    */
    greater,

    /**
        Test passes if the value in the buffer is not equal 
        to the incoming value
    */
    notEqual,

    /**
        Test passes if the value in the buffer is greater than 
        or equal to the incoming value.
    */
    greaterEqual,
    
    /**
        Test always passes
    */
    always
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
        Operation to perform if stencil test fails.
    */
    NuvkDepthStencilOp stencilFailureOp;

    /**
        Operation to perform if depth test fails.
    */
    NuvkDepthStencilOp depthFailureOp;
    
    /**
        Operation to perform if depth and stencil test succeeds.
    */
    NuvkDepthStencilOp depthStencilPassOp;

    /**
        The comparison operation to perform.
    */
    NuvkCompareOp compareOp;

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