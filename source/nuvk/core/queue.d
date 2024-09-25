module nuvk.core.queue;
import nuvk.core;
import nuvk.spirv;
import numem.all;

/**
    The kind of a comand buffer
*/
enum NuvkCommandQueueKind {

    /**
        Queue is used for rendering
    */
    render,
    
    /**
        Queue is used for compute
    */
    compute,

    /**
        Queue is used for transferring things between objects
        on the GPU.
    */
    transfer
}

/**
    A command queue for command buffers.
*/
abstract
class NuvkCommandQueue : NuvkDeviceObject {
@nogc:
private:
    NuvkCommandQueueKind kind;

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkCommandQueueKind kind) {
        super(device, NuvkProcessSharing.processLocal);
    }

    /**
        Encodes a command that makes the queue wait for a fence.
    */
    abstract void awaitFence(NuvkFence fence);
    
    /**
        Encodes a command that makes the queue wait for a semaphore.
    */
    abstract void awaitSemaphore(NuvkSemaphore semaphore);

    /**
        Encodes a command that makes the queue wait for a fence.
    */
    abstract void signalFence(NuvkFence fence);
    
    /**
        Encodes a command that makes the queue wait for a semaphore.
    */
    abstract void signalSemaphore(NuvkSemaphore semaphore);

    /**
        Creates a command buffer
    */
    abstract NuvkCommandBuffer createCommandBuffer();

    /**
        Waits on the queue items to finish executing.
    */
    abstract void await();

    /**
        Gets the kind of command queue this is.
    */
    final
    NuvkCommandQueueKind getQueueKind() {
        return kind;
    }
}