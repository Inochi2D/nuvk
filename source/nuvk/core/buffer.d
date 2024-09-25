/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.buffer;
import nuvk.core.device;

/**
    The usage of the buffer
*/
enum NuvkBufferUsage {

    /**
        Buffer allows transfers to the CPU
    */
    transferSrc = 0x01,

    /**
        Buffer allows transfers from the CPU
    */
    transferDst = 0x02,
    
    /**
        Buffer will be used as a uniform buffer
    */
    uniform     = 0x04,
    
    /**
        Buffer will be used as a vertex buffer
    */
    vertex      = 0x08,
    
    /**
        Buffer will be used as a index buffer
    */
    index       = 0x10,
    
    /**
        Buffer will be used as a indirect buffer
    */
    indirect    = 0x20,

    /**
        Buffer is a staging buffer
    */
    staging     = 0x80,
}

/**
    The type of the elements in a index buffer.
*/
enum NuvkBufferIndexType {

    /**
        16-bit index buffer
    */
    uint16,
    
    /**
        32-bit index buffer
    */
    uint32,
}

/**
    A buffer
*/
abstract
class NuvkBuffer : NuvkDeviceObject {
@nogc:
private:
    NuvkDeviceSharing deviceSharing;
    NuvkBufferUsage usage;
    ulong size;

public:

    /**
        Constructor
    */
    this(NuvkDevice owner, NuvkBufferUsage usage, NuvkDeviceSharing deviceSharing, ulong size, NuvkProcessSharing processSharing) {
        super(owner, processSharing);
        this.deviceSharing = deviceSharing;
        this.usage = usage;
        this.size = size;
    }

    /**
        Gets the sharing mode of the buffer
    */
    final
    NuvkDeviceSharing getDeviceSharing() {
        return deviceSharing;
    }

    /**
        Gets the usage of the buffer
    */
    final
    NuvkBufferUsage getBufferUsage() {
        return usage;
    }

    /**
        Gets the size of the buffer in bytes.
    */
    final
    ulong getSize() {
        return size;
    }

    /**
        Uploads data to GPU memory
        NOTE: Only shared buffers may be mapped.

        Returns whether mapping succeeded.
    */
    abstract bool upload(void* data, ulong size, ulong offset = 0);

    /**
        Maps the buffer's memory for reading/writing.
        NOTE: Only shared buffers may be mapped.

        Returns whether mapping succeeded.
    */
    abstract bool map(ref void* mapTo, ulong size, ulong offset = 0);

    /**
        Maps the buffer's memory for reading/writing.
        NOTE: Only shared buffers may be mapped.

        Returns whether mapping succeeded.
    */
    bool map(T)(ref T* mapTo, ulong count, ulong offset = 0) {

        // Temporary storage
        union tmp {
            void* ptr;
            T* tptr;
        }
        tmp tmp_;

        // Copy over if possible.
        bool success = map(tmp_.ptr, count*T.sizeof, offset*T.sizeof);
        if (success) mapTo = tmp_.tptr;
        return success;
    }
    
    /**
        Unmaps the buffer's memory.
        NOTE: Only shared buffers may be mapped.

        Returns whether unmapping succeeded.
    */
    abstract bool unmap();
}