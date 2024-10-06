/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module nuvk.core.vk.internal.stagingbuffer;
import nuvk.core.vk;
import nuvk.core;
import nuvk.spirv;
import numem.all;



/**
    Internally used staging buffer for buffer uploads.
*/
class NuvkVkStagingBuffer {
@nogc:
private:
    // Buffer
    NuvkDevice device;
    NuvkBuffer buffer;

    // Queues
    vector!uint queues;

    // Command Buffer
    NuvkQueue transferQueue;

    void createStagingBuffer() {
        buffer = device.createBuffer(
            NuvkBufferUsage.hostVisible | 
            NuvkBufferUsage.transferSrc |
            NuvkBufferUsage.transferDst |
            NuvkBufferUsage.hostShared,
            33_554_432u,
        );
    }

public:

    /**
        Destructor
    */
    ~this() {
        // Make sure recursive destruction doesn't attempt
        // To destroy the queue twice.
        transferQueue = null;
        nogc_delete(buffer);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkQueue transferQueue) {
        this.device = device;
        this.transferQueue = transferQueue;
    }

    void transfer(void[] data, NuvkBuffer to) {

    }
}