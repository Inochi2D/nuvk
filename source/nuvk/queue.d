/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.queue;
import nuvk;
import numem.all;
import inmath.math;

import core.stdc.stdio : printf;

enum MAX_QUEUE_ELEMENT_COUNT = 256;

/**
    A command queue for command buffers.
*/
abstract
class NuvkQueue : NuvkDeviceObject {
@nogc:
private:
    // Indexing info
    NuvkQueueFamilyInfo familyInfo;
    uint index;

    weak_vector!NuvkCommandBuffer submissionQueue;
    weak_vector!NuvkCommandBuffer commandBuffers;

    // Attempts to find a free slot
    ptrdiff_t findFreeSlot() {
        foreach(i; 0..commandBuffers.length) {
            if (!commandBuffers[i])
                return i;
        }
        return -1;
    }

    NuvkCommandBuffer insertFreeSlot() {
        this.collect();

        auto idx = this.findFreeSlot();
        if (idx >= 0) {
            commandBuffers[idx] = this.onCreateCommandBuffer();
            return commandBuffers[idx];
        }
        return null;
    }

    bool canEnqueue(NuvkCommandBuffer inBuffer) {
        if (inBuffer.isEnqueued)
            return false;

        foreach(ref NuvkCommandBuffer buffer; submissionQueue[]) {
            if (inBuffer is buffer)
                return false;
        }

        return true;
    }

    bool canSubmit() {
        foreach(ref NuvkCommandBuffer buffer; submissionQueue[]) {
            if (!buffer.isComitted)
                return false;
        }
        return true;
    }

    void submit() {
        if (!this.canSubmit)
            return;

        foreach(ref NuvkCommandBuffer buffer; submissionQueue[]) {

            buffer.notifySubmit();
            this.onSubmit(buffer);
            foreach(ref surface; buffer.getPresentRequests()) {
                this.onSubmit(surface);
            }
        }

        this.onSubmitCompleted();
        submissionQueue.clear();
    }

    // Collects any completed buffers.
    void collect() {
        foreach(i; 0..commandBuffers.length) {
            auto element = commandBuffers[i];
            if (element && element.isCompleted) {
                nogc_delete(element);
                commandBuffers[i] = null;
            }
        }
    }

    void freeAll() {
        this.await();
        foreach(element; commandBuffers[]) {
            if (element)
                nogc_delete(element);
        }

        nogc_delete(commandBuffers);
        nogc_delete(submissionQueue);
    }

protected:

    /**
        Gets the index into the queue manager
    */
    final
    uint getIndex() {
        return index;
    }

    /**
        Trims the command queue freeing any unsued memory.

        This operation should be assumed to be expensive
        and should only be called in events where it is known
        that the cost of trimming the queue is outweighed
        by the benefits of the memory being freed.
    */
    abstract void onTrim();

    /**
        Called when a submission is requested for a range of command buffers.

        This may be called multiple times a frame to optimally submit elements.
    */
    abstract void onSubmit(NuvkCommandBuffer buffer);

    /**
        Called when a submission is requested for a surface swap.

        This may be called multiple times a frame to optimally submit elements.
    */
    abstract void onSubmit(NuvkSurface surface);

    /**
        Called when the submission request has been completed.
    */
    abstract void onSubmitCompleted();

    /**
        Called when a command buffer is enqueued.
    */
    abstract void onEnqueue(NuvkCommandBuffer toEnqueue);

    /**
        Called when a new command buffer should be created.
    */
    abstract NuvkCommandBuffer onCreateCommandBuffer();

    /**
        Gets the next buffer handle for the queue.

        returns null if no handle could be obtained.
    */
    abstract NuvkHandle onNextBufferHandle();

    /**
        Called when a handle is requested to be freed.
    */
    abstract void onFreeBufferHandle(NuvkHandle handle);

public:

    /**
        Destructor
    */
    ~this() {
        this.freeAll();

        // Tell device to destroy this queue.
        this.getOwner().destroyQueue(this);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkQueueFamilyInfo familyInfo, uint index, uint count) {
        super(device);
        this.familyInfo = familyInfo;
        this.index = index;

        uint actualMax = min(MAX_QUEUE_ELEMENT_COUNT, familyInfo.maxCommandBuffers);
        uint elementCount = cast(uint)clamp(count, 1, actualMax);
        this.commandBuffers.resize(elementCount);
        this.submissionQueue.reserve(elementCount);
    }

    /**
        Gets the next free command buffer in the queue.

        The command buffer is owned by the queue and will 
        automatically be freed after completion.
    */
    final
    NuvkCommandBuffer nextCommandBuffer() {
        return this.insertFreeSlot();
    }

    /**
        Blocks the current thread until all submitted commands
        have finished executing.
    */
    abstract void await();

    /**
        Trims the command queue freeing any unsued memory.

        This operation should be assumed to be expensive
        and should only be called in events where it is known
        that the cost of trimming the queue is outweighed
        by the benefits of the memory being freed.
    */
    final
    void trim() {
        this.onTrim();
    }

    /**
        Reserves a spot for the command buffer in the queue
    */
    final
    bool reserve(NuvkCommandBuffer buffer) {
        if (buffer.hasBeenSubmitted) 
            return false;

        if (!this.canEnqueue(buffer))
            return false;

        if (!buffer.isCompatible(this.getOwner()))
            return false;

        if (submissionQueue.length > commandBuffers.length)
            return false;

        submissionQueue ~= buffer;
        buffer.notifyEnqueue();
        this.onEnqueue(buffer);
        return true;
    }

    /**
        Gets what this queue is specialized for
    */
    final
    NuvkQueueSpecialization getSpecialization() {
        return familyInfo.specialization;
    }

    /**
        Gets information about queue
    */
    final
    NuvkQueueFamilyInfo getFamilyInfo() {
        return familyInfo;
    }
}

/**
    Objects owned by a command queue.
*/
abstract
class NuvkQueueObject : NuvkDeviceObject {
@nogc:
private:
    NuvkQueue queue;

protected:

    final
    void sendSubmitRequest() {
        queue.submit();
    }

public:

    /**
        Destructor
    */
    ~this() {
        queue.onFreeBufferHandle(this.getHandle());
    }

    /**
        Constructor
    */
    this(NuvkQueue queue) {
        this.setHandle(queue.onNextBufferHandle());

        super(queue.getOwner());
        this.queue = queue;
    }

    /**
        Gets the queue 
    */
    final
    NuvkQueue getQueue() {
        return queue;
    }
}

/**
    Enumerates the different kinds of specializations that a queue can have.
*/
enum NuvkQueueSpecialization {

    /**
        Invalid queue specialisation.

        If you get this, there's a bug in nuvk.
    */
    invalid     = 0x00,

    /**
        Graphics specialization, supports graphics/render commands.
    */
    graphics    = 0x01,

    /**
        Compute specialization, supports compute commands.
    */
    compute     = 0x02,

    /**
        Transfer specialization, supports transfers.
    */
    transfer    = 0x04,

    /**
        No specialization, supports all commands.
    */
    none        = graphics | compute | transfer,
}

/**
    Information about a command queue
*/
struct NuvkQueueFamilyInfo {

    /**
        Index of the queue family
    */
    uint index;

    /**
        How many command queues that can be
        instantiated of this index.
    */
    uint maxQueueCount;

    /**
        The specializations for the queue.
    */
    NuvkQueueSpecialization specialization;
    
    /**
        Maximum number of concurrent command buffers that
        the queue can have.
    */
    uint maxCommandBuffers;
}