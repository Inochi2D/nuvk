/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.queue;
import nuvk.core;
import nuvk.spirv;
import numem.all;

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

/**
    A command queue for command buffers.
*/
abstract
class NuvkQueue : NuvkDeviceObject {
@nogc:
private:
    NuvkQueueFamilyInfo familyInfo;
    uint index;

protected:

    /**
        Gets the index into the queue manager
    */
    final
    uint getIndex() {
        return index;
    }

public:

    /**
        Destructor
    */
    ~this() {

        // Tell device to destroy this queue.
        this.getOwner().destroyQueue(this);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkQueueFamilyInfo familyInfo, uint index) {
        super(device);
        this.familyInfo = familyInfo;
        this.index = index;
    }

    /**
        Creates a command buffer
    */
    abstract NuvkCommandBuffer createCommandBuffer();

    /**
        Blocks the current thread until all submitted commands
        have finished executing.
    */
    abstract void await();

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