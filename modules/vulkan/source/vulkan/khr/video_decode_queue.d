/**
 * VK_KHR_video_decode_queue (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_decode_queue;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
}
public import vulkan.khr.video_queue;

struct VK_KHR_video_decode_queue {
    @VkProcName("vkCmdDecodeVideoKHR")
    PFN_vkCmdDecodeVideoKHR vkCmdDecodeVideoKHR;
}

enum VK_KHR_VIDEO_DECODE_QUEUE_SPEC_VERSION = 8;
enum VK_KHR_VIDEO_DECODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_decode_queue";

alias VkVideoDecodeCapabilityFlagsKHR = uint;
enum VkVideoDecodeCapabilityFlagsKHR
    VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_COINCIDE_BIT_KHR = 1,
    VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_DISTINCT_BIT_KHR = 2;


struct VkVideoDecodeCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_CAPABILITIES_KHR;
    void* pNext;
    VkVideoDecodeCapabilityFlagsKHR flags;
}

alias VkVideoDecodeUsageFlagsKHR = uint;
enum VkVideoDecodeUsageFlagsKHR
    VK_VIDEO_DECODE_USAGE_DEFAULT_KHR = 0,
    VK_VIDEO_DECODE_USAGE_TRANSCODING_BIT_KHR = 1,
    VK_VIDEO_DECODE_USAGE_OFFLINE_BIT_KHR = 2,
    VK_VIDEO_DECODE_USAGE_STREAMING_BIT_KHR = 4;


struct VkVideoDecodeUsageInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_USAGE_INFO_KHR;
    const(void)* pNext;
    VkVideoDecodeUsageFlagsKHR videoUsageHints;
}

alias VkVideoDecodeFlagsKHR = VkFlags;

import vulkan.khr.video_queue : VkVideoPictureResourceInfoKHR, VkVideoReferenceSlotInfoKHR, VkVideoReferenceSlotInfoKHR;
struct VkVideoDecodeInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_INFO_KHR;
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

alias PFN_vkCmdDecodeVideoKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkVideoDecodeInfoKHR)* pDecodeInfo,
);
