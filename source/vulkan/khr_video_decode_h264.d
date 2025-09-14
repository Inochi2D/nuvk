/**
    VK_KHR_video_encode_h264
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_video_decode_h264;
import vulkan.vk_video.codec_h264std;
import vulkan.khr_video_queue;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_VIDEO_DECODE_H264_SPEC_VERSION = 9;
enum string VK_KHR_VIDEO_DECODE_H264_EXTENSION_NAME = "VK_KHR_video_decode_h264";

alias VkVideoDecodeH264PictureLayoutFlagsKHR = VkFlags;
enum VkVideoDecodeH264PictureLayoutFlagsKHR VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_PROGRESSIVE_KHR = 0,
    VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_INTERLEAVED_LINES_BIT_KHR = 0x00000001,
    VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_SEPARATE_PLANES_BIT_KHR = 0x00000002;

struct VkVideoDecodeH264ProfileInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    StdVideoH264ProfileIdc stdProfileIdc;
    VkVideoDecodeH264PictureLayoutFlagsKHR pictureLayout;
}

struct VkVideoDecodeH264CapabilitiesKHR {
    VkStructureType sType;
    void* pNext;
    StdVideoH264LevelIdc maxLevelIdc;
    VkOffset2D fieldOffsetGranularity;
}

struct VkVideoDecodeH264SessionParametersAddInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint stdSPSCount;
    const(StdVideoH264SequenceParameterSet)* pStdSPSs;
    uint stdPPSCount;
    const(StdVideoH264PictureParameterSet)* pStdPPSs;
}

struct VkVideoDecodeH264SessionParametersCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint maxStdSPSCount;
    uint maxStdPPSCount;
    const(VkVideoDecodeH264SessionParametersAddInfoKHR)* pParametersAddInfo;
}

struct VkVideoDecodeH264PictureInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    const(StdVideoDecodeH264PictureInfo)* pStdPictureInfo;
    uint sliceCount;
    const(uint)* pSliceOffsets;
}

struct VkVideoDecodeH264DpbSlotInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    const(StdVideoDecodeH264ReferenceInfo)* pStdReferenceInfo;
}
