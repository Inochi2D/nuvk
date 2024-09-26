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
    A command queue for command buffers.
*/
abstract
class NuvkCommandQueue : NuvkDeviceObject {
@nogc:
private:
    NuvkQueueSpecialization specialization;

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
    this(NuvkDevice device, NuvkQueueSpecialization specialization) {
        super(device);
        this.specialization = specialization;
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
        return specialization;
    }
}