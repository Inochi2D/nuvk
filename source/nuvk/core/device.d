module nuvk.core.device;
import nuvk.core;
import nuvk.spirv;
import numem.all;

/**
    Whether the object is shared
*/
enum NuvkProcessSharing {

    /**
        Object should be process local
    */
    processLocal,
    
    /**
        Object should be shared across processes.

        A handle is exported that can be passed between processes.
    */
    processShared,
}

/**
    Sharing mode for a buffer
*/
enum NuvkDeviceSharing {
    
    /**
        Buffer is local to the GPU
    */
    deviceLocal,
    
    /**
        Buffer is shared with the CPU
    */
    deviceShared
}

/**
    The device that owns the context.
*/
abstract
class NuvkDevice : NuvkObject {
@nogc:
private:
    NuvkContext owner;
    NuvkDeviceInfo deviceInfo;

public:

    /**
        Constructor
    */
    this(NuvkContext owner, NuvkDeviceInfo info) {
        this.owner = owner;
        this.deviceInfo = info;
    }

    /**
        Gets information about the device
    */
    final
    NuvkDeviceInfo getDeviceInfo() {
        return deviceInfo;
    }

    /**
        Creates a shader program.
    */
    abstract NuvkShader createShader(NuvkSpirvModule module_, NuvkShaderStage stage);
    
    /**
        Creates a buffer.
    */
    abstract NuvkBuffer createBuffer(NuvkBufferUsage usage, NuvkDeviceSharing sharing, uint size, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal);

    /**
        Creates a texture
    */
    abstract NuvkTexture createTexture(NuvkTextureDescriptor descriptor, NuvkDeviceSharing deviceSharing, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal);
    
    /**
        Creates a sampler
    */
    abstract NuvkSampler createSampler(NuvkSamplerDescriptor descriptor);

    /**
        Creates a fence.
    */
    abstract NuvkFence createFence();

    /**
        Creates a semaphore.
    */
    abstract NuvkSemaphore createSemaphore(NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal);

    /**
        Creates a graphics pipeline.
    */
    abstract NuvkPipeline createGraphicsPipeline(ref NuvkGraphicsPipelineDescriptor pipelineCreationInfo);

    /**
        Creates a compute pipeline.
    */
    abstract NuvkPipeline createComputePipeline(ref NuvkComputePipelineDescriptor pipelineCreationInfo);

    /**
        Creates a new command queue
    */
    abstract NuvkCommandQueue createQueue(NuvkCommandQueueKind kind);
}

/**
    A Nuvk object owned by a device.
*/
abstract
class NuvkDeviceObject : NuvkObject {
@nogc:
private:
    NuvkDevice owner;
    NuvkProcessSharing sharing;
    ulong shareHandle;
    bool wasHandleSet;

    void _iCloseSharedHandle() {
        this.onShareHandleClose(shareHandle);

        this.shareHandle = 0;
        this.sharing = sharing.processLocal;
    }

protected:

    /**
        Sets the handle used for sharing
    */
    final
    void setSharedHandle(ulong shareHandle) {
        this.shareHandle = shareHandle;
        this.wasHandleSet = true;
    }

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    void onShareHandleClose(ulong handle) { }

public:

    ~this() {
        if(wasHandleSet) {
            this._iCloseSharedHandle();
        }
    }

    /**
        Creates a new device object.
    */
    this(NuvkDevice owner, NuvkProcessSharing sharing) {
        this.owner = owner;
        this.sharing = sharing;
    }

    /**
        Gets the owner of this object.
    */
    final
    ref NuvkDevice getOwner() {
        return owner;
    }

    /**
        Gets the sharing state of the object.
    */
    final
    NuvkProcessSharing getSharing() {
        return sharing;
    }

    /**
        Gets a handle which can be shared between processes.
    */
    final
    ulong getSharedHandle() {
        return shareHandle;
    }

    /**
        Override function to change how handle
        closing is handled.
    */
    final
    void stopSharing() {
        if(wasHandleSet) {
            this._iCloseSharedHandle();
        }
    }
}