/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.buffer;
import nuvk.core.vk;
import nuvk.core;
import numem.all;


/**
    Converts NuvkBufferUsage to a VkBufferUsageFlags, usable by Vulkan.
*/
VkBufferUsageFlags toVkBufferUsageFlags(NuvkBufferUsage usage) @nogc {
    VkBufferUsageFlags flags;

    if (usage & NuvkBufferUsage.staging)
        flags |= VK_BUFFER_USAGE_TRANSFER_SRC_BIT;

    if (usage & NuvkBufferUsage.transferSrc)
        flags |= VK_BUFFER_USAGE_TRANSFER_SRC_BIT;

    if (usage & NuvkBufferUsage.transferDst)
        flags |= VK_BUFFER_USAGE_TRANSFER_DST_BIT;

    if (usage & NuvkBufferUsage.uniform)
        flags |= VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;

    if (usage & NuvkBufferUsage.vertex)
        flags |= VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;

    if (usage & NuvkBufferUsage.index)
        flags |= VK_BUFFER_USAGE_INDEX_BUFFER_BIT;

    if (usage & NuvkBufferUsage.indirect)
        flags |= VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT;

    return flags;
}

VkIndexType toVkIndexType(NuvkBufferIndexType indexType) @nogc {
    final switch(indexType) {
        case NuvkBufferIndexType.uint16:
            return VK_INDEX_TYPE_UINT16;
        case NuvkBufferIndexType.uint32:
            return VK_INDEX_TYPE_UINT32;
    }
}

class NuvkVkBuffer : NuvkBuffer {
@nogc:
private:
    VkMemoryRequirements memoryRequirements; 
    VkDeviceMemory deviceMemory;
    VkBuffer buffer;
    bool mapped;

    void createBuffer(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto deviceInfo = cast(NuvkVkDeviceInfo)this.getOwner().getDeviceInfo();
        auto usage = this.getBufferUsage();
        auto deviceSharing = this.getDeviceSharing();
        int memoryIndex;
        VkFlags flags;

        if (deviceSharing == NuvkDeviceSharing.deviceShared) {
            flags |= VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;

            // Staging buffers should be host coherent
            if (usage == NuvkBufferUsage.staging) 
                flags |= VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;
        }

        // Create buffer
        {
            VkExternalMemoryBufferCreateInfo bufferExternalInfo;

            VkBufferCreateInfo bufferInfo;
            bufferInfo.size = this.getSize();
            bufferInfo.usage = usage;
            bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

            // Handle types needs to be specified when sharing here.
            if (processSharing == NuvkProcessSharing.processShared) {
                bufferExternalInfo.handleTypes = NuvkVkMemorySharingFlagBit;
                bufferInfo.pNext = &bufferExternalInfo;
            }

            enforce(
                vkCreateBuffer(device, &bufferInfo, null, &buffer) == VK_SUCCESS,
                nstring("Failed creating buffer")
            );
        }

        // Find memory layout
        {
            vkGetBufferMemoryRequirements(device, buffer, &memoryRequirements);

            memoryIndex = deviceInfo.getMatchingMemoryIndex(memoryRequirements.memoryTypeBits, flags);
            enforce(
                memoryIndex >= 0, 
                nstring("Failed finding suitable memory for the requested buffer")
            );
        }

        // Allocate memory.
        {
            if (processSharing == NuvkProcessSharing.processShared) {

                VkExportMemoryAllocateInfo exportInfo;
                exportInfo.handleTypes = NuvkVkMemorySharingFlagBit;

                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;
                allocInfo.pNext = &exportInfo;

                enforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    nstring("Failed allocating memory for buffer!")
                );

                vkBindBufferMemory(device, buffer, deviceMemory, 0);
                this.setSharedHandle(nuvkVkGetSharedHandle(device, deviceMemory));

            } else {
                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;

                enforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    nstring("Failed allocating memory for buffer!")
                );

                vkBindBufferMemory(device, buffer, deviceMemory, 0);
            }
        }

        this.setHandle(buffer);
    }
protected:

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    override
    void onShareHandleClose(ulong handle) {
        nuvkVkCloseSharedHandle(handle);
    }

public:

    /**
        Destructor
    */
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        // Free buffer memory
        if (deviceMemory != VK_NULL_HANDLE)
            vkFreeMemory(device, deviceMemory, null);

        // Free buffer itself
        if (buffer != VK_NULL_HANDLE)
            vkDestroyBuffer(device, buffer, null);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkBufferUsage usage, NuvkDeviceSharing sharing, ulong size, NuvkProcessSharing processSharing) {
        super(device, usage, sharing, size, processSharing);
        this.createBuffer(processSharing);
    }

    /**
        Uploads data to GPU memory

        `data` is a pointer to the data to copy
        `size` is how many bytes to copy
        `offset` is the offset into the **destination** to copy into.

        Returns whether uploaded succeeded.
    */
    override
    bool upload(void* data, ulong size, ulong offset = 0) {
        if (this.getDeviceSharing() != NuvkDeviceSharing.deviceShared)
            return false;

        import core.stdc.string : memcpy;
        auto device = cast(VkDevice)this.getOwner().getHandle();
        void* dataBuffer;

        VkMappedMemoryRange memoryRange;
        memoryRange.memory = deviceMemory;
        memoryRange.offset = offset;
        memoryRange.size = size;

        if (vkMapMemory(device, memoryRange.memory, memoryRange.offset, memoryRange.size, 0, &dataBuffer) == VK_SUCCESS) {
            memcpy(dataBuffer, data+offset, size);
            vkUnmapMemory(device, deviceMemory);
            vkFlushMappedMemoryRanges(device, 1, &memoryRange);
        }

        return false;
    }

    /**
        Maps the buffer's memory for reading/writing.

        Returns whether mapping succeeded.
    */
    override
    bool map(ref void* mapTo, ulong size, ulong offset = 0) {
        if (this.getDeviceSharing() != NuvkDeviceSharing.deviceShared)
            return false;

        auto device = cast(VkDevice)this.getOwner().getHandle();
        
        if (!mapped) {
            VkMappedMemoryRange memoryRange;
            memoryRange.memory = deviceMemory;
            memoryRange.offset = offset;
            memoryRange.size = size;

            mapped = true;

            // Non-staging buffers need to tell the GPU to invalidate buffer.
            // It doesn't matter if this succeeds or not.
            if (this.getBufferUsage() != NuvkBufferUsage.staging) {
                vkInvalidateMappedMemoryRanges(device, 1, &memoryRange);
            }
            
            return vkMapMemory(device, deviceMemory, offset, size, 0, &mapTo) == VK_SUCCESS;
        }
        return false;
    }
    
    /**
        Unmaps the buffer's memory.

        Returns whether unmapping succeeded.
    */
    override
    bool unmap() {
        if (this.getDeviceSharing() != NuvkDeviceSharing.deviceShared)
            return false;
        
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (mapped) {
            VkMappedMemoryRange memoryRange;
            memoryRange.memory = deviceMemory;
            memoryRange.offset = 0;
            memoryRange.size = this.getSize();

            mapped = false;
            
            vkUnmapMemory(device, deviceMemory);

            // Non-staging buffers need to tell the GPU to flush buffer.
            // It doesn't matter if this succeeds or not.
            if (this.getBufferUsage() != NuvkBufferUsage.staging) {
                vkFlushMappedMemoryRanges(device, 1, &memoryRange);
            }
        }
        return false;
    }
}