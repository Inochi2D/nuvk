/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.sync;
import nuvk;

/**
    A fence which handles CPU<->GPU synchronization.
*/
class NuvkFence : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device) {
        super(device);
    }

    /**
        Gets the whether the fence is signaled.
    */
    abstract bool isSignaled();

    /**
        Wait for fence to be signalled.
    */
    abstract void await(ulong timeout);

    /**
        Resets the fence.
    */
    abstract void reset();
}

/**
    A semaphore
*/
class NuvkSemaphore : NuvkDeviceObject {
@nogc:
private:
    NuvkProcessSharing sharing;

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkProcessSharing sharing) {
        super(device);
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
        Gets the shared handle
    */
    abstract NuvkHandleShared getSharedHandle();
}

/**
    An event
*/
class NuvkEvent : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device) {
        super(device);
    }
}

/**
    Sync direction
*/
enum NuvkSyncDirection {
    
    /**
        No sync
    */
    none    = 0x00,

    /**
        Sync on read
    */
    read    = 0x01,
    
    /**
        Sync on write
    */
    write   = 0x02,
    
    /**
        Sync on read and write
    */
    rw      = read | write,
}