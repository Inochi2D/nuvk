/**
 * VK_KHR_video_decode_vp9
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_decode_vp9;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.video.vp9std;
import vulkan.video.vp9std_decode;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.video_decode_queue;

enum VK_KHR_VIDEO_DECODE_VP9_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_DECODE_VP9_EXTENSION_NAME = "VK_KHR_video_decode_vp9";
enum uint VK_MAX_VIDEO_VP9_REFERENCES_PER_FRAME_KHR = 3;

struct VkPhysicalDeviceVideoDecodeVP9FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_DECODE_VP9_FEATURES_KHR;
    void* pNext;
    VkBool32 videoDecodeVP9;
}

struct VkVideoDecodeVP9ProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_VP9_PROFILE_INFO_KHR;
    const(void)* pNext;
    StdVideoVP9Profile stdProfile;
}

struct VkVideoDecodeVP9CapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_VP9_CAPABILITIES_KHR;
    void* pNext;
    StdVideoVP9Level maxLevel;
}

struct VkVideoDecodeVP9PictureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_VP9_PICTURE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeVP9PictureInfo)* pStdPictureInfo;
    int[VK_MAX_VIDEO_VP9_REFERENCES_PER_FRAME_KHR] referenceNameSlotIndices;
    uint uncompressedHeaderOffset;
    uint compressedHeaderOffset;
    uint tilesOffset;
}
