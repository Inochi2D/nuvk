/**
 * VK_KHR_video_decode_h265 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_decode_h265;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.video.h265std;
import vulkan.video.h265std_encode;
import vulkan.video.h265std_decode;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.video_decode_queue;

enum VK_KHR_VIDEO_DECODE_H265_SPEC_VERSION = 8;
enum VK_KHR_VIDEO_DECODE_H265_EXTENSION_NAME = "VK_KHR_video_decode_h265";

struct VkVideoDecodeH265ProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PROFILE_INFO_KHR;
    const(void)* pNext;
    StdVideoH265ProfileIdc stdProfileIdc;
}

struct VkVideoDecodeH265CapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_CAPABILITIES_KHR;
    void* pNext;
    StdVideoH265LevelIdc maxLevelIdc;
}

struct VkVideoDecodeH265SessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    uint maxStdVPSCount;
    uint maxStdSPSCount;
    uint maxStdPPSCount;
    const(VkVideoDecodeH265SessionParametersAddInfoKHR)* pParametersAddInfo;
}

struct VkVideoDecodeH265SessionParametersAddInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_ADD_INFO_KHR;
    const(void)* pNext;
    uint stdVPSCount;
    const(StdVideoH265VideoParameterSet)* pStdVPSs;
    uint stdSPSCount;
    const(StdVideoH265SequenceParameterSet)* pStdSPSs;
    uint stdPPSCount;
    const(StdVideoH265PictureParameterSet)* pStdPPSs;
}

struct VkVideoDecodeH265PictureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PICTURE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeH265PictureInfo)* pStdPictureInfo;
    uint sliceSegmentCount;
    const(uint)* pSliceSegmentOffsets;
}

struct VkVideoDecodeH265DpbSlotInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_DPB_SLOT_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeH265ReferenceInfo)* pStdReferenceInfo;
}
