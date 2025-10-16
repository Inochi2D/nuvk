/**
 * VK_KHR_video_decode_av1 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_decode_av1;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.video.av1std;
import vulkan.video.av1std_encode;
import vulkan.video.av1std_decode;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.video_decode_queue;

enum VK_KHR_VIDEO_DECODE_AV1_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_DECODE_AV1_EXTENSION_NAME = "VK_KHR_video_decode_av1";
enum uint VK_MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR = 7;

struct VkVideoDecodeAV1ProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_PROFILE_INFO_KHR;
    const(void)* pNext;
    StdVideoAV1Profile stdProfile;
    VkBool32 filmGrainSupport;
}

struct VkVideoDecodeAV1CapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_CAPABILITIES_KHR;
    void* pNext;
    StdVideoAV1Level maxLevel;
}

struct VkVideoDecodeAV1SessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoAV1SequenceHeader)* pStdSequenceHeader;
}

struct VkVideoDecodeAV1PictureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_PICTURE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeAV1PictureInfo)* pStdPictureInfo;
    int[VK_MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR] referenceNameSlotIndices;
    uint frameHeaderOffset;
    uint tileCount;
    const(uint)* pTileOffsets;
    const(uint)* pTileSizes;
}

struct VkVideoDecodeAV1DpbSlotInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_DPB_SLOT_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeAV1ReferenceInfo)* pStdReferenceInfo;
}
