/**
 * VK_KHR_video_decode_h264 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_decode_h264;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.video.h264std;
import vulkan.video.h264std_encode;
import vulkan.video.h264std_decode;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.video_decode_queue;

enum VK_KHR_VIDEO_DECODE_H264_SPEC_VERSION = 9;
enum VK_KHR_VIDEO_DECODE_H264_EXTENSION_NAME = "VK_KHR_video_decode_h264";

enum VkVideoDecodeH264PictureLayoutFlagBitsKHR : uint {
    VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_PROGRESSIVE_KHR = 0,
    VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_INTERLEAVED_LINES_BIT_KHR = 1,
    VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_SEPARATE_PLANES_BIT_KHR = 2,
}

enum VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_PROGRESSIVE_KHR = VkVideoDecodeH264PictureLayoutFlagBitsKHR.VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_PROGRESSIVE_KHR;
enum VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_INTERLEAVED_LINES_BIT_KHR = VkVideoDecodeH264PictureLayoutFlagBitsKHR.VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_INTERLEAVED_LINES_BIT_KHR;
enum VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_SEPARATE_PLANES_BIT_KHR = VkVideoDecodeH264PictureLayoutFlagBitsKHR.VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_SEPARATE_PLANES_BIT_KHR;

alias VkVideoDecodeH264PictureLayoutFlagsKHR = VkBitFlagsBase!(VkFlags, VkVideoDecodeH264PictureLayoutFlagBitsKHR);

struct VkVideoDecodeH264ProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PROFILE_INFO_KHR;
    const(void)* pNext;
    StdVideoH264ProfileIdc stdProfileIdc;
    VkVideoDecodeH264PictureLayoutFlagBitsKHR pictureLayout;
}

struct VkVideoDecodeH264CapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_CAPABILITIES_KHR;
    void* pNext;
    StdVideoH264LevelIdc maxLevelIdc;
    VkOffset2D fieldOffsetGranularity;
}

struct VkVideoDecodeH264SessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    uint maxStdSPSCount;
    uint maxStdPPSCount;
    const(VkVideoDecodeH264SessionParametersAddInfoKHR)* pParametersAddInfo;
}

struct VkVideoDecodeH264SessionParametersAddInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_ADD_INFO_KHR;
    const(void)* pNext;
    uint stdSPSCount;
    const(StdVideoH264SequenceParameterSet)* pStdSPSs;
    uint stdPPSCount;
    const(StdVideoH264PictureParameterSet)* pStdPPSs;
}

struct VkVideoDecodeH264PictureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PICTURE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeH264PictureInfo)* pStdPictureInfo;
    uint sliceCount;
    const(uint)* pSliceOffsets;
}

struct VkVideoDecodeH264DpbSlotInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_DPB_SLOT_INFO_KHR;
    const(void)* pNext;
    const(StdVideoDecodeH264ReferenceInfo)* pStdReferenceInfo;
}
