/**
    VK_KHR_video_decode_queue
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.video_decode_queue;
import vulkan.khr.video_queue;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_VIDEO_DECODE_QUEUE_SPEC_VERSION = 8;
enum string VK_KHR_VIDEO_DECODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_decode_queue";

alias VkVideoDecodeCapabilityFlagsKHR = VkFlags;
enum VkVideoDecodeCapabilityFlagsKHR VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_COINCIDE_BIT_KHR = 0x00000001,
    VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_DISTINCT_BIT_KHR = 0x00000002;

alias VkVideoDecodeUsageFlagsKHR = VkFlags;
alias VkVideoDecodeFlagsKHR = VkFlags;
enum VkVideoDecodeUsageFlagsKHR VK_VIDEO_DECODE_USAGE_DEFAULT_KHR = 0,
    VK_VIDEO_DECODE_USAGE_TRANSCODING_BIT_KHR = 0x00000001,
    VK_VIDEO_DECODE_USAGE_OFFLINE_BIT_KHR = 0x00000002,
    VK_VIDEO_DECODE_USAGE_STREAMING_BIT_KHR = 0x00000004;

struct VkVideoDecodeCapabilitiesKHR {
    VkStructureType sType;
    void* pNext;
    VkVideoDecodeCapabilityFlagsKHR flags;
}

struct VkVideoDecodeUsageInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkVideoDecodeUsageFlagsKHR videoUsageHints;
}

struct VkVideoDecodeInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkVideoDecodeFlagsKHR flags;
    VkBuffer srcBuffer;
    VkDeviceSize srcBufferOffset;
    VkDeviceSize srcBufferRange;
    VkVideoPictureResourceInfoKHR dstPictureResource;
    const(VkVideoReferenceSlotInfoKHR)* pSetupReferenceSlot;
    uint referenceSlotCount;
    const(VkVideoReferenceSlotInfoKHR)* pReferenceSlots;
}

alias PFN_vkCmdDecodeVideoKHR = void function(VkCommandBuffer commandBuffer, const(
        VkVideoDecodeInfoKHR)* pDecodeInfo);
