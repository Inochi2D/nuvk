/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

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
    abstract NuvkTexture createTexture(NuvkTextureDescriptor descriptor, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal);
    
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
    abstract NuvkCommandQueue createQueue(NuvkQueueSpecialization specialization = NuvkQueueSpecialization.none);

    /**
        Destroys a queue.

        calling nogc_delete on a queue will automatically invoke this.
    */
    abstract void destroyQueue(NuvkCommandQueue queue);

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    abstract NuvkSurface createSurfaceFromHandle(void* handle, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat);
}

/**
    A Nuvk Object owned by a device.
*/
abstract
class NuvkDeviceObject : NuvkObject {
@nogc:
private:
    NuvkDevice owner;

public:

    /**
        Creates a new device object.
    */
    this(NuvkDevice owner) {
        this.owner = owner;
    }

    /**
        Gets the owner of this object.
    */
    final
    ref NuvkDevice getOwner() {
        return owner;
    }
}

/**
    A Nuvk resources.

    Resources are memory allocations visible to the GPU.
    This includes buffers, textures, and the like.
*/
abstract
class NuvkResource : NuvkDeviceObject {
@nogc:
private:
    NuvkProcessSharing sharing;

    // Sharing
    // NOTE: All NuvkResource types should support sharing
    // As such having a shared implementation here is less
    // of a headache.
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

    /**
        Destructor
    */
    ~this() {
        if(wasHandleSet) {
            this._iCloseSharedHandle();
        }
    }

    /**
        Constructor
    */
    this(NuvkDevice owner, NuvkProcessSharing sharing) {
        super(owner);
        this.sharing = sharing;
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
}