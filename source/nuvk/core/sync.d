/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.sync;
import nuvk.core;

/**
    A fence
*/
class NuvkFence : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device) {
        super(device);
    }
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

    abstract ulong getSharedHandle();
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