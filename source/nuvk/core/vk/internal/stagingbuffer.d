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
    NuvkVkDevice device;
    VkBuffer buffer;
    VkDeviceMemory bufferMemory;

    VkMemoryRequirements memoryRequirements;

    weak_vector!uint queues;
    StagingRequest stagingRequest;

    /**
        A staging request
    */
    struct StagingRequest {
        VkBuffer destination;
        uint start;
        uint end;
    }

    void createStagingBuffer() {
        this.fillQueueIds();
        auto deviceInfo = cast(NuvkVkDeviceInfo)device.getDeviceInfo();
        auto vkdevice = cast(VkDevice)device.getHandle();
        
        VkBufferCreateInfo bufferCreateInfo;
        bufferCreateInfo.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT | VK_BUFFER_USAGE_TRANSFER_DST_BIT;

        // Buffer is 32 megabytes in size
        bufferCreateInfo.size = 33_554_432;
        bufferCreateInfo.sharingMode = VK_SHARING_MODE_CONCURRENT;
        bufferCreateInfo.queueFamilyIndexCount = cast(uint)queues.size();
        bufferCreateInfo.pQueueFamilyIndices = queues.data();

        enforce(
            vkCreateBuffer(vkdevice, &bufferCreateInfo, null, &buffer) == VK_SUCCESS,
            nstring("Failed creating staging buffer")
        );

        vkGetBufferMemoryRequirements(vkdevice, buffer, &memoryRequirements);

        VkMemoryAllocateInfo allocInfo;
        allocInfo.allocationSize = memoryRequirements.size;
        allocInfo.memoryTypeIndex = deviceInfo.getMatchingMemoryIndex(memoryRequirements.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT);
        
        enforce(
            vkAllocateMemory(vkdevice, &allocInfo, null, &bufferMemory) == VK_SUCCESS,
            nstring("Failed to allocate memory for staging buffer")
        );

        vkBindBufferMemory(vkdevice, buffer, bufferMemory, 0);
    }

    void fillQueueIds() {
        auto deviceInfo = cast(NuvkVkDeviceInfo)device.getDeviceInfo();
        auto queueProps = deviceInfo.getQueueFamilyProperties();
        foreach(i; 0..queueProps.length) {
            queues ~= cast(uint)i;
        }
    }

public:

    this(NuvkVkDevice device) {
        this.device = device;
    }

    void copyDataTo(VkBuffer destination, void[] data) {
        
    }
}