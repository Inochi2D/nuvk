/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.staging;
import nuvk;

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

    /**
        Creates a temporary texture staging buffer
    */
    NuvkBuffer createTextureStagingBuffer(NuvkTexture texture, bool isSource) {
        NuvkBufferUsage usage = 
            NuvkBufferUsage.hostVisible | NuvkBufferUsage.hostShared;

        usage |= isSource ? NuvkBufferUsage.transferSrc : NuvkBufferUsage.transferDst;

        return device.createBuffer(
            usage,
            cast(uint)texture.getAllocatedSize(),
        );
    }

    NuvkTransferEncoder begin() {
        this.commands = queue.nextCommandBuffer();
        return commands.beginTransferPass();
    }

    void end(NuvkTransferEncoder encoder) {
        if (encoder) {
        
            // Note: encoder is basically deleted after this.
            encoder.endEncoding();
            encoder = null;

            commands.commit();
            queue.await();
        }
    }

    void copyOut(void* destination, size_t size, NuvkBuffer rbuffer = null) {

        // Workaround for being unable to pass buffer in.
        if (rbuffer is null)
            rbuffer = buffer;

        // Copy data over.
        void* buf;
        if (rbuffer.map(buf, size, 0)) {
            destination[0..size] = buf[0..size];
            rbuffer.unmap();
        }
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
            "Tried to transfer data larger than destination! (%d->%d)",
            from.length,
            to.getSize()
        );

        size_t remaining = clampTx(offset, from.length);
        do {

            buffer.upload(from.ptr+offset, remaining, 0);

            if (auto encoder = this.begin()) {
                encoder.copy(buffer, 0, to, 0, cast(uint)remaining);
                
                this.end(encoder);
                offset += remaining;
                remaining = clampTx(offset, from.length);
            } else {
                nuvkLogError("Failed to upload {0} bytes...", cast(uint)remaining);
                return;
            }
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
            "Tried to transfer data larger than destination! (%d->%d)",
            size,
            to.length
        );

        size_t remaining = clampTx(offset, size);
        do {
            if (auto encoder = this.begin()) {
                encoder.copy(from, cast(uint)offset, buffer, 0, cast(uint)remaining);

                this.end(encoder);
                this.copyOut(to.ptr+offset, remaining);

                offset += remaining;
                remaining = clampTx(offset, size);
            } else {
                nuvkLogError("Failed to download {0} bytes...", cast(uint)remaining);
                return;
            }
        } while(remaining > 0);
    }

    /**
        Transfers data from the CPU to the GPU
    */
    void transfer(void[] from, uint rowStride, NuvkTexture to, recti region, uint arraySlice = 0, uint mipmapLevel = 0) {
        nuvkEnforce(
            from.length <= to.getAllocatedSize(), 
            "Tried to transfer data larger than destination! (%d->%d)",
            from.length,
            to.getAllocatedSize()
        );

        // Create temporary buffer and delete it after use.
        NuvkBuffer imgBuffer = this.createTextureStagingBuffer(to, true);
        scope(exit) nogc_delete(imgBuffer);
        
        imgBuffer.upload(from.ptr, from.length, 0);

        if (auto encoder = this.begin()) {
            encoder.copy(imgBuffer, 0, rowStride, to, region, arraySlice, mipmapLevel);

            this.end(encoder);
        }
    }

    /**
        Transfers data from the GPU to the CPU
    */
    void transfer(NuvkTexture from, void[] to, recti region) {
        nuvkEnforce(
            from.getAllocatedSize() <= to.length, 
            "Tried to transfer data larger than destination! (%d->%d)",
            from.getAllocatedSize(),
            to.length,
        );

        // Create temporary buffer and delete it after use.
        NuvkBuffer imgBuffer = this.createTextureStagingBuffer(from, false);
        scope(exit) nogc_delete(imgBuffer);

        if (auto encoder = this.begin()) {
            // encoder.copy(imgBuffer, 0, rowStride, to, region, arraySlice, mipmapLevel);

            this.end(encoder);
            this.copyOut(to.ptr, imgBuffer.getSize(), imgBuffer);
        }
    }
}