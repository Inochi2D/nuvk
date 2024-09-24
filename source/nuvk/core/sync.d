module nuvk.core.sync;
import nuvk.core;

/**
    A fence
*/
class NuvkFence : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device) {
        super(device, NuvkObjectSharing.processLocal);
    }
}

/**
    A semaphore
*/
class NuvkSemaphore : NuvkDeviceObject {
@nogc:
public:
    this(NuvkDevice device, NuvkObjectSharing sharing) {
        super(device, sharing);
    }
}