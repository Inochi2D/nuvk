/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.buffer;
import nuvk.core;

import numem.collections.vector;

/**
    The usage of the buffer
*/
enum NuvkBufferUsage {
    
    /**
        Buffer will be used as a vertex buffer
    */
    vertex      = 1,
    
    /**
        Buffer will be used as a index buffer
    */
    index       = 2,
    
    /**
        Buffer will be used as a uniform buffer
    */
    uniform     = 3,
    
    /**
        Buffer will be used as a storage buffer
    */
    storage     = 4,

    /**
        Buffer allows transfers to the CPU
    */
    transferSrc = 0x10,

    /**
        Buffer allows transfers from the CPU
    */
    transferDst = 0x20,
    
    /**
        Buffer will be used as a indirect buffer
    */
    indirect    = 0x40,

    /**
        Buffer is host-visible
    */
    hostVisible     = 0x80,

    /**
        Buffer is shared across all queues on the host.
    */
    hostShared      = 0x100
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
    Vertex format
*/
enum NuvkVertexFormat {

    /**
        Format is invalid
    */
    invalid,

    /**
        32-bit floating point value
    */
    float32,

    /**
        2D Vector of single precision floats.
    */
    vec2,
    
    /**
        3D Vector of single precision floats.
    */
    vec3,
    
    /**
        4D Vector of single precision floats.
    */
    vec4,
}

/**
    A buffer
*/
abstract
class NuvkBuffer : NuvkResource {
@nogc:
private:
    NuvkBufferUsage usage;
    ulong size;

public:

    /**
        Constructor
    */
    this(NuvkDevice owner, NuvkBufferUsage usage, ulong size, NuvkProcessSharing processSharing) {
        super(owner, processSharing);
        this.usage = usage;
        this.size = size;
    }

    /**
        Gets the usage of the buffer
    */
    final
    NuvkBufferUsage getBufferUsage() {
        return usage;
    }

    /**
        Gets the type of the buffer.
        (Usage without extra flags.)
    */
    final
    NuvkBufferUsage getBufferType() {
        return cast(NuvkBufferUsage)(usage & 0x0F);
    }

    /**
        Gets the size of the buffer in bytes.
    */
    final
    ulong getSize() {
        return size;
    }

    /**
        Uploads data to GPU memory.

        `data` is a pointer to the data to copy
        `size` is how many bytes to copy
        `offset` is the offset into the **destination** to copy into.

        If the buffer is host visible it will be mapped,
        otherwise a staging buffer will be used.
    */
    final
    void upload(void* data, ulong size, ulong offset = 0) {

        // Is host mappable.
        if (this.getBufferUsage() & NuvkBufferUsage.hostVisible) {

            // Map
            void* mapped;
            nuvkEnforce(this.map(mapped, size, offset), "Failed to map buffer!");
            
            // Set
            mapped[0..size] = data[0..size];

            // Unmap.
            nuvkEnforce(this.unmap(), "Failed to unmap buffer!");
            return;
        }

        // Requires staging.
        auto staging = this.getOwner().getStagingBuffer();
        staging.transfer(data[0..size], this, offset);
        return;
    }

    /**
        Downloads data from GPU memory

        `data` is the slice to copy the data to.
        `offset` is the offset into the **source** to copy from.

        If the buffer is host visible it will be mapped,
        otherwise a staging buffer will be used.
    */
    final
    void download(ref void[] data, ulong offset = 0) {

        // Is host mappable.
        if (this.getBufferUsage() & NuvkBufferUsage.hostVisible) {

            // Map
            void* mapped;
            nuvkEnforce(this.map(mapped, data.length, offset), "Failed to map buffer!");
            
            // Set
            data[0..data.length] = mapped[0..data.length];

            // Unmap.
            nuvkEnforce(this.unmap(), "Failed to unmap buffer!");
            return;
        }

        // Requires staging.
        auto staging = this.getOwner().getStagingBuffer();
        staging.transfer(this, data[0..$], offset, data.length);
        return;
    }

    /**
        Uploads data to GPU memory.

        `data` is a pointer to the data to copy
        `offset` is the offset into the **destination** to copy into.

        If the buffer is host visible it will be mapped,
        otherwise a staging buffer will be used.
    */
    void upload(T)(T[] data, ulong offset = 0) {
        this.upload(data.ptr, T.sizeof*data.length, offset);
    }

    /**
        Downloads data from GPU memory

        `data` is the slice to copy the data to.
        `offset` is the offset into the **source** to copy from.

        If the buffer is host visible it will be mapped,
        otherwise a staging buffer will be used.
    */
    void download(T)(ref T[] data, ulong offset = 0) {
        this.download(data.ptr, T.sizeof*data.length, offset);
    }

    /**
        Maps the buffer's memory for reading/writing.
        Returns whether mapping succeeded.

        `mapTo` is the pointer to update with the mapped reference.
        `size` is the amount of bytes to map from the buffer.
        `offset` is the byte offset into the buffer to start mapping from.

        NOTE: Only shared buffers may be mapped.
    */
    abstract bool map(ref void* mapTo, ulong size, ulong offset = 0);

    /**
        Maps the buffer's memory for reading/writing.
        Returns whether mapping succeeded.

        `mapTo` is the pointer to update with the mapped reference.
        `size` is the amount of elements to map from the buffer.
        `offset` is the offset into the buffer to start mapping from.

        NOTE: Only shared buffers may be mapped.
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
        Returns whether unmapping succeeded.

        NOTE: Only shared buffers may be mapped.
    */
    abstract bool unmap();
}