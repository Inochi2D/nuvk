module nuvk.core.staging;
import nuvk.core;

import numem.all;
import inmath;

/**
    An underlying staging buffer to use for staging requests.

    You generally won't be calling this directly.
    Refer to the `upload` and `download` functions of a Resource.
*/
class NuvkStagingBuffer {
@nogc:
@nogc:
private:
    // Buffer
    NuvkDevice device;
    NuvkBuffer buffer;

    // Command Buffer
    NuvkQueue queue;
    NuvkCommandBuffer commands;

    void createStagingBuffer() {
        this.commands = queue.createCommandBuffer();
        this.buffer = device.createBuffer(
            NuvkBufferUsage.hostVisible | 
            NuvkBufferUsage.transferSrc |
            NuvkBufferUsage.transferDst |
            NuvkBufferUsage.hostShared,
            33_554_432u,
        );
    }

    size_t clampTx(size_t offset, size_t size) {
        size_t remaining = size-offset;
        if (remaining > buffer.getSize())
            remaining = buffer.getSize();

        return remaining;
    }

public:

    /**
        Destructor
    */
    ~this() {

        // Make sure recursive destruction doesn't attempt
        // To destroy the queue twice.
        queue = null;
        nogc_delete(buffer);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkQueue transferQueue) {
        this.device = device;
        this.queue = transferQueue;
        this.createStagingBuffer();
    }

    /**
        Transfers data from the CPU to the GPU
    */
    void transfer(void[] from, NuvkBuffer to, size_t offset = 0) {
        nuvkEnforce(
            from.length <= to.getSize(), 
            "Tried to transfer data larger than destination buffer! (%d->%d)",
            from.length,
            to.getSize()
        );

        size_t remaining = clampTx(offset, from.length);
        do {

            buffer.upload(from.ptr+offset, remaining, 0);

            if (auto encoder = commands.beginTransferPass()) {
                encoder.copy(buffer, 0, to, 0, cast(uint)remaining);
                encoder.endEncoding();
            } else {
                throw nogc_new!NuException(nstring("Failed to begin transfer pass!!"));
            }

            commands.commit();
            queue.await();

            offset += remaining;
            remaining = clampTx(offset, from.length);
        } while(remaining > 0);
    }

    /**
        Transfers data from the GPU to the CPU
    */
    void transfer(NuvkBuffer from, void[] to, size_t offset, size_t size) {
        nuvkEnforce(
            offset+size <= from.getSize(),
            "Attempted to copy data out of range for buffer!"
        );
        nuvkEnforce(
            size <= to.length, 
            "Tried to transfer data larger than destination buffer! (%d->%d)",
            size,
            to.length
        );

        size_t remaining = clampTx(offset, size);
        do {

            if (auto encoder = commands.beginTransferPass()) {
                encoder.copy(from, cast(uint)offset, buffer, 0, cast(uint)remaining);
                encoder.endEncoding();
            } else {
                throw nogc_new!NuException(nstring("Failed to begin transfer pass!!"));
            }

            commands.commit();
            queue.await();

            // Copy data over.
            void* buf;
            buffer.map(buf, remaining, 0);
            to[offset..offset+remaining] = buf[0..remaining];

            offset += remaining;
            remaining = clampTx(offset, size);
        } while(remaining > 0);
    }

    /**
        Transfers data from the CPU to the GPU
    */
    void transfer(void[] from, uint rowStride, NuvkTexture to, recti region, uint arraySlice = 0, uint mipmapLevel = 0) {
        nuvkEnforce(
            from.length <= to.getAllocatedSize(), 
            "Tried to transfer data larger than destination texture! (%d->%d)",
            from.length,
            to.getAllocatedSize()
        );

        // TODO: implement an algorithm which uploads based on tiles.
        if (from.length > buffer.getSize()) {
            nuvkLogError("Source size is larger than staging buffer, support for this is not implemented yet!");
            return;
        }

        buffer.upload(from.ptr, from.length, 0);
        if (auto encoder = commands.beginTransferPass()) {
            encoder.copy(buffer, 0, rowStride, to, region, arraySlice, mipmapLevel);
            encoder.endEncoding();
        } else {
            throw nogc_new!NuException(nstring("Failed to begin transfer pass!"));
        }

        commands.commit();
        queue.await();
    }
}