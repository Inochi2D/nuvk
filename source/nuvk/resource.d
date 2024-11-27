/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Resources
*/
module nuvk.resource;

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
    NuvkHazardTracking hazardTracking;
    NuvkStorageMode storageMode;

    NuvkHandleShared shareHandle;
    bool wasHandleSet;

    void _iCloseSharedHandle() {
        this.onShareHandleClose(shareHandle);

        this.shareHandle = cast(NuvkHandleShared)0;
        this.sharing = sharing.processLocal;
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
        Gets whether the resource is shareable.
    */
    final
    bool isSharable() {
        return this.getOwner().getDeviceInfo().getDeviceFeatures().sharing;
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
    Hazard tracking modes for memory allocated on the GPU.
*/
enum NuvkHazardTracking {

    /**
        The app should prevent data hazards when modifying or accessing this
        object's contents.

        In this case the developer will be responsible for setting up 
        memory barriers and the like.
    */
    untracked,

    /**
        Nuvk should prevent data hazards when modifying or accessing this
        object's contents.
    */
    tracked
}

/**
    Storage modes for objects allocated between the GPU and CPU, which specifies
    where the object is stored and its access permissions.
*/
enum NuvkStorageMode {

    /**
        Object is shared *coherently* between CPU and GPU.
    */
    storageShared,

    /**
        Object is shared between CPU and GPU, but the developer must
        explicitly tell nuvk to synchronize it.
    */
    storageManaged,

    /**
        Object is allocated on the GPU exclusively and can't be directly
        accessed from the CPU.
    */
    storagePrivate
}