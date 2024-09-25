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
        super(device, NuvkProcessSharing.processLocal);
    }
}

/**
    A semaphore
*/
class NuvkSemaphore : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device, NuvkProcessSharing sharing) {
        super(device, sharing);
    }
}