/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.buffer;
import nuvk.core.vk;
import nuvk.core;
import numem.all;
import inmath;


/**
    Converts NuvkBufferUsage to a VkBufferUsageFlags, usable by Vulkan.
*/
VkBufferUsageFlags toVkBufferUsageFlags(NuvkBufferUsage usage) @nogc {
    uint flags = 0;

    if (usage & NuvkBufferUsage.transferSrc)
        flags |= VK_BUFFER_USAGE_TRANSFER_SRC_BIT;

    if (usage & NuvkBufferUsage.transferDst)
        flags |= VK_BUFFER_USAGE_TRANSFER_DST_BIT;

    uint type = usage & 0x0F;

    if (type == NuvkBufferUsage.uniform)
        flags |= VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;

    if (type == NuvkBufferUsage.vertex)
        flags |= VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;

    if (type == NuvkBufferUsage.index)
        flags |= VK_BUFFER_USAGE_INDEX_BUFFER_BIT;

    if (type == NuvkBufferUsage.storage)
        flags |= VK_BUFFER_USAGE_STORAGE_BUFFER_BIT;

    if (type == NuvkBufferUsage.indirect)
        flags |= VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT;

    return cast(VkBufferUsageFlags)flags;
}

VkIndexType toVkIndexType(NuvkBufferIndexType indexType) @nogc {
    final switch(indexType) {
        case NuvkBufferIndexType.uint16:
            return VK_INDEX_TYPE_UINT16;
        case NuvkBufferIndexType.uint32:
            return VK_INDEX_TYPE_UINT32;
    }
}

class NuvkBufferVk : NuvkBuffer {
@nogc:
private:
    VkMemoryRequirements memoryRequirements; 
    VkDeviceMemory deviceMemory;
    VkBuffer buffer;
    bool mapped;

    VkDeviceSize allocatedSize;
    VkDeviceSize requiredAlignment;

    VkDeviceSize alignToAllowedSize(VkDeviceSize in_, VkDeviceSize offset) {
        return min((in_ + (in_ % requiredAlignment)) - offset, allocatedSize);
    }

protected:

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    override
    void onShareHandleClose(ulong handle) {
        nuvkCloseSharedHandleVk(handle);
    }

    override
    void onCreated(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto deviceInfo = cast(NuvkDeviceVkInfo)this.getOwner().getDeviceInfo();
        auto usage = this.getBufferUsage();
        int memoryIndex;
        VkFlags flags;

        // Staging buffers should be host coherent
        if (usage & NuvkBufferUsage.hostVisible) {
            flags |= VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
            flags |= VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;
        }

        // Create buffer
        {
            VkExternalMemoryBufferCreateInfo bufferExternalInfo;

            VkBufferCreateInfo bufferInfo;
            bufferInfo.size = this.getSize();
            bufferInfo.usage = usage.toVkBufferUsageFlags();
            bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

            // Handle types needs to be specified when sharing here.
            if (processSharing == NuvkProcessSharing.processShared) {
                bufferExternalInfo.handleTypes = NuvkVkMemorySharingFlagBit;
                bufferInfo.pNext = &bufferExternalInfo;
            }
            
            nuvkEnforce(
                vkCreateBuffer(device, &bufferInfo, null, &buffer) == VK_SUCCESS,
                "Failed creating buffer"
            );
        }

        // Find memory layout
        {
            vkGetBufferMemoryRequirements(device, buffer, &memoryRequirements);

            memoryIndex = deviceInfo.getMatchingMemoryIndex(memoryRequirements.memoryTypeBits, flags);
            nuvkEnforce(
                memoryIndex >= 0, 
                "Failed finding suitable memory for the requested buffer"
            );

            allocatedSize = memoryRequirements.size;
            requiredAlignment = memoryRequirements.alignment;
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

                nuvkEnforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    "Failed allocating memory for buffer!"
                );

                vkBindBufferMemory(device, buffer, deviceMemory, 0);
                this.setSharedHandle(nuvkGetSharedHandleVk(device, deviceMemory));

            } else {
                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;

                nuvkEnforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    "Failed allocating memory for buffer!"
                );

                vkBindBufferMemory(device, buffer, deviceMemory, 0);
            }
        }

        this.setHandle(buffer);
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
    this(NuvkDevice device, NuvkBufferUsage usage, ulong size, NuvkProcessSharing processSharing) {
        super(device, usage, size, processSharing);
    }

    /**
        Maps the buffer's memory for reading/writing.

        Returns whether mapping succeeded.
    */
    override
    bool map(ref void* mapTo, ulong size, ulong offset = 0) {
        if (!(this.getBufferUsage() & NuvkBufferUsage.hostVisible))
            return false;

        auto device = cast(VkDevice)this.getOwner().getHandle();
        
        if (!mapped) {
            VkMappedMemoryRange memoryRange;
            memoryRange.memory = deviceMemory;
            memoryRange.offset = offset;
            memoryRange.size = this.alignToAllowedSize(size, offset);

            mapped = true;

            // Non-staging buffers need to tell the GPU to invalidate buffer.
            // It doesn't matter if this succeeds or not.
            if (!(this.getBufferUsage() & NuvkBufferUsage.hostVisible)) {
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
        if (!(this.getBufferUsage() & NuvkBufferUsage.hostVisible))
            return false;
        
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (mapped) {
            VkMappedMemoryRange memoryRange;
            memoryRange.memory = deviceMemory;
            memoryRange.offset = 0;
            memoryRange.size = this.getSize();

            mapped = false;

            // Non-staging buffers need to tell the GPU to flush buffer.
            // It doesn't matter if this succeeds or not.
            if (!(this.getBufferUsage() & NuvkBufferUsage.hostVisible)) {
                vkFlushMappedMemoryRanges(device, 1, &memoryRange);
            }
            
            vkUnmapMemory(device, deviceMemory);
            return true;
        }
        return false;
    }

    /**
        Gets the actually allocated amount of bytes for the buffer.
    */
    override
    ulong getAllocatedSize() {
        return allocatedSize;
    }

    /**
        Gets the allocated size on the GPU, in bytes.
    */
    override
    ulong getAlignment() {
        return requiredAlignment;
    } 
}