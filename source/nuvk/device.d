/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.device;
import numem.all;
import nuvk;

import inmath;

/**
    The device that owns the context.
*/
abstract
class NuvkDevice : NuvkObject {
@nogc:
private:
    NuvkContext owner;
    NuvkDeviceInfo deviceInfo;
    NuvkStagingBuffer staging;

public:

    /**
        Destructor
    */
    ~this() {

        // Staging buffer belongs to the device.
        if (staging)
            nogc_delete(staging);
    }

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
    abstract NuvkShaderProgram createShader();

    /**
        Creates a shader program from a library
    */
    abstract NuvkShaderProgram createShader(NuvkShaderLibrary library);
    
    /**
        Creates a buffer.
    */
    abstract NuvkBuffer createBuffer(NuvkBufferUsage usage, uint size, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal);

    /**
        Creates a buffer.

        Data is automatically uploaded to the buffer.
    */
    NuvkBuffer createBuffer(T)(NuvkBufferUsage usage, T[] elements, NuvkProcessSharing processSharing = NuvkProcessSharing.processLocal) {
        
        // If buffer is not host visible, make sure we can use the staging buffer.
        if (!(usage & NuvkBufferUsage.hostVisible))
            usage |= NuvkBufferUsage.transferDst;
        
        NuvkBuffer buffer = this.createBuffer(usage, cast(uint)(T.sizeof*elements.length), processSharing);
        buffer.upload(elements, 0);
        return buffer;
    }

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
        Creates a new command queue
    */
    abstract NuvkQueue createQueue(uint maxCommandBuffers = 64, NuvkQueueSpecialization specialization = NuvkQueueSpecialization.none);

    /**
        Creates a surface from a handle created by your windowing
        library.
    */
    abstract NuvkSurface createSurfaceFromHandle(void* handle, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat);

    /**
        Waits for all queues to be idle.
    */
    abstract void awaitAll();

    /**
        Destroys a queue.

        calling nogc_delete on a queue will automatically invoke this.
    */
    abstract void destroyQueue(NuvkQueue queue);
    
    /**
        Gets the queue family information
    */
    final
    NuvkQueueFamilyInfo[] getQueueFamilyInfos() {
        return deviceInfo.getQueueFamilyInfos();
    }

    /**
        Gets the queue family information
    */
    final
    ptrdiff_t getQueueFamilyInfoFor(NuvkQueueSpecialization specialization) {
        return deviceInfo.getQueueFamilyIdxFor(specialization);
    }

    /**
        Gets the staging buffer for this device.

        If no staging buffer exists yet, one will be created.
        The staging buffer is owned by the device. 
    */
    final
    NuvkStagingBuffer getStagingBuffer() {
        if (!staging)
            staging = nogc_new!NuvkStagingBuffer(this, this.createQueue(NuvkQueueSpecialization.transfer));

        return staging;
    }
}

/**
    A Nuvk Object owned by a device.

    Attempting to use a device object with other devices than which owns it
    will result in error.
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

    /**
        Gets the owner of this object.

        Shorthand for casting to the lower level API type.
    */
    T getOwnerAs(T)() if (is(T : NuvkDevice)) {
        return cast(T)owner;
    }

    /**
        Gets whether this object is compatible with the given device.
    */
    final
    bool isCompatible(NuvkDevice other) {
        return owner is other;
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
    NuvkHandleShared shareHandle;
    bool wasHandleSet;

    void _iCloseSharedHandle() {
        this.onShareHandleClose(shareHandle);

        this.shareHandle = cast(NuvkHandleShared)0;
        this.sharing = sharing.processLocal;
    }

    bool canShare() {
        return this.getOwner().getDeviceInfo().getDeviceFeatures().sharing;
    }

    // Sync state
    NuvkSyncDirection syncState;

protected:

    /**
        Sets the handle used for sharing
    */
    final
    void setSharedHandle(NuvkHandleShared shareHandle) {
        this.shareHandle = shareHandle;
        this.wasHandleSet = true;
    }

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    void onShareHandleClose(NuvkHandleShared handle) { }

    /**
        Called when the object is created.
    */
    abstract void onCreated(NuvkProcessSharing sharing);

package(nuvk):

    /**
        Updates the usage sync state of the resource.

        This should only be called by a nuvk backend.
    */
    final
    void use(NuvkSyncDirection state) {
        this.syncState = state;
    }

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
        this.sharing = canShare() ? 
            sharing : 
            NuvkProcessSharing.processLocal;
        
        this.onCreated(this.sharing);
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
    NuvkHandleShared getSharedHandle() {
        return shareHandle;
    }

    /**
        Gets the current sync state.

        If the state is "none" it means the resource is free to use
        without any prior synchronisation.
    */
    final
    NuvkSyncDirection getSyncState() {
        return syncState;
    }

    /**
        Gets the allocated size on the GPU, in bytes.
    */
    abstract ulong getAllocatedSize();

    /**
        Gets the allocated alignment on the GPU, in bytes.
    */
    abstract ulong getAlignment();
}

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