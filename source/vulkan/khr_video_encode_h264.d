/**
    VK_KHR_video_encode_h264
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_video_encode_h264;
import vulkan.vk_video.codec_h264std;
import vulkan.khr_video_queue;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_VIDEO_ENCODE_H264_SPEC_VERSION = 14;
enum string VK_KHR_VIDEO_ENCODE_H264_EXTENSION_NAME = "VK_KHR_video_encode_h264";

alias VkVideoEncodeH264CapabilityFlagsKHR = VkFlags;
enum VkVideoEncodeH264CapabilityFlagsKHR VK_VIDEO_ENCODE_H264_CAPABILITY_HRD_COMPLIANCE_BIT_KHR = 0x00000001,
    VK_VIDEO_ENCODE_H264_CAPABILITY_PREDICTION_WEIGHT_TABLE_GENERATED_BIT_KHR = 0x00000002,
    VK_VIDEO_ENCODE_H264_CAPABILITY_ROW_UNALIGNED_SLICE_BIT_KHR = 0x00000004,
    VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_KHR = 0x00000008,
    VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L0_LIST_BIT_KHR = 0x00000010,
    VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_KHR = 0x00000020,
    VK_VIDEO_ENCODE_H264_CAPABILITY_PER_PICTURE_TYPE_MIN_MAX_QP_BIT_KHR = 0x00000040,
    VK_VIDEO_ENCODE_H264_CAPABILITY_PER_SLICE_CONSTANT_QP_BIT_KHR = 0x00000080,
    VK_VIDEO_ENCODE_H264_CAPABILITY_GENERATE_PREFIX_NALU_BIT_KHR = 0x00000100,
    VK_VIDEO_ENCODE_H264_CAPABILITY_B_PICTURE_INTRA_REFRESH_BIT_KHR = 0x00000400,
    VK_VIDEO_ENCODE_H264_CAPABILITY_MB_QP_DIFF_WRAPAROUND_BIT_KHR = 0x00000200;

alias VkVideoEncodeH264StdFlagsKHR = VkFlags;
enum VkVideoEncodeH264StdFlagsKHR VK_VIDEO_ENCODE_H264_STD_SEPARATE_COLOR_PLANE_FLAG_SET_BIT_KHR = 0x00000001,
    VK_VIDEO_ENCODE_H264_STD_QPPRIME_Y_ZERO_TRANSFORM_BYPASS_FLAG_SET_BIT_KHR = 0x00000002,
    VK_VIDEO_ENCODE_H264_STD_SCALING_MATRIX_PRESENT_FLAG_SET_BIT_KHR = 0x00000004,
    VK_VIDEO_ENCODE_H264_STD_CHROMA_QP_INDEX_OFFSET_BIT_KHR = 0x00000008,
    VK_VIDEO_ENCODE_H264_STD_SECOND_CHROMA_QP_INDEX_OFFSET_BIT_KHR = 0x00000010,
    VK_VIDEO_ENCODE_H264_STD_PIC_INIT_QP_MINUS26_BIT_KHR = 0x00000020,
    VK_VIDEO_ENCODE_H264_STD_WEIGHTED_PRED_FLAG_SET_BIT_KHR = 0x00000040,
    VK_VIDEO_ENCODE_H264_STD_WEIGHTED_BIPRED_IDC_EXPLICIT_BIT_KHR = 0x00000080,
    VK_VIDEO_ENCODE_H264_STD_WEIGHTED_BIPRED_IDC_IMPLICIT_BIT_KHR = 0x00000100,
    VK_VIDEO_ENCODE_H264_STD_TRANSFORM_8X8_MODE_FLAG_SET_BIT_KHR = 0x00000200,
    VK_VIDEO_ENCODE_H264_STD_DIRECT_SPATIAL_MV_PRED_FLAG_UNSET_BIT_KHR = 0x00000400,
    VK_VIDEO_ENCODE_H264_STD_ENTROPY_CODING_MODE_FLAG_UNSET_BIT_KHR = 0x00000800,
    VK_VIDEO_ENCODE_H264_STD_ENTROPY_CODING_MODE_FLAG_SET_BIT_KHR = 0x00001000,
    VK_VIDEO_ENCODE_H264_STD_DIRECT_8X8_INFERENCE_FLAG_UNSET_BIT_KHR = 0x00002000,
    VK_VIDEO_ENCODE_H264_STD_CONSTRAINED_INTRA_PRED_FLAG_SET_BIT_KHR = 0x00004000,
    VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_DISABLED_BIT_KHR = 0x00008000,
    VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_ENABLED_BIT_KHR = 0x00010000,
    VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_PARTIAL_BIT_KHR = 0x00020000,
    VK_VIDEO_ENCODE_H264_STD_SLICE_QP_DELTA_BIT_KHR = 0x00080000,
    VK_VIDEO_ENCODE_H264_STD_DIFFERENT_SLICE_QP_DELTA_BIT_KHR = 0x00100000;

alias VkVideoEncodeH264RateControlFlagsKHR = VkFlags;
enum VkVideoEncodeH264RateControlFlagsKHR VK_VIDEO_ENCODE_H264_RATE_CONTROL_ATTEMPT_HRD_COMPLIANCE_BIT_KHR = 0x00000001,
    VK_VIDEO_ENCODE_H264_RATE_CONTROL_REGULAR_GOP_BIT_KHR = 0x00000002,
    VK_VIDEO_ENCODE_H264_RATE_CONTROL_REFERENCE_PATTERN_FLAT_BIT_KHR = 0x00000004,
    VK_VIDEO_ENCODE_H264_RATE_CONTROL_REFERENCE_PATTERN_DYADIC_BIT_KHR = 0x00000008,
    VK_VIDEO_ENCODE_H264_RATE_CONTROL_TEMPORAL_LAYER_PATTERN_DYADIC_BIT_KHR = 0x00000010;

struct VkVideoEncodeH264CapabilitiesKHR {
    VkStructureType sType;
    void* pNext;
    VkVideoEncodeH264CapabilityFlagsKHR flags;
    StdVideoH264LevelIdc maxLevelIdc;
    uint maxSliceCount;
    uint maxPPictureL0ReferenceCount;
    uint maxBPictureL0ReferenceCount;
    uint maxL1ReferenceCount;
    uint maxTemporalLayerCount;
    VkBool32 expectDyadicTemporalLayerPattern;
    int minQp;
    int maxQp;
    VkBool32 prefersGopRemainingFrames;
    VkBool32 requiresGopRemainingFrames;
    VkVideoEncodeH264StdFlagsKHR stdSyntaxFlags;
}

struct VkVideoEncodeH264QpKHR {
    int qpI;
    int qpP;
    int qpB;
}

struct VkVideoEncodeH264QualityLevelPropertiesKHR {
    VkStructureType sType;
    void* pNext;
    VkVideoEncodeH264RateControlFlagsKHR preferredRateControlFlags;
    uint preferredGopFrameCount;
    uint preferredIdrPeriod;
    uint preferredConsecutiveBFrameCount;
    uint preferredTemporalLayerCount;
    VkVideoEncodeH264QpKHR preferredConstantQp;
    uint preferredMaxL0ReferenceCount;
    uint preferredMaxL1ReferenceCount;
    VkBool32 preferredStdEntropyCodingModeFlag;
}

struct VkVideoEncodeH264SessionCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkBool32 useMaxLevelIdc;
    StdVideoH264LevelIdc maxLevelIdc;
}

struct VkVideoEncodeH264SessionParametersAddInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint stdSPSCount;
    const(StdVideoH264SequenceParameterSet)* pStdSPSs;
    uint stdPPSCount;
    const(StdVideoH264PictureParameterSet)* pStdPPSs;
}

struct VkVideoEncodeH264SessionParametersCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint maxStdSPSCount;
    uint maxStdPPSCount;
    const(VkVideoEncodeH264SessionParametersAddInfoKHR)* pParametersAddInfo;
}

struct VkVideoEncodeH264SessionParametersGetInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkBool32 writeStdSPS;
    VkBool32 writeStdPPS;
    uint stdSPSId;
    uint stdPPSId;
}

struct VkVideoEncodeH264SessionParametersFeedbackInfoKHR {
    VkStructureType sType;
    void* pNext;
    VkBool32 hasStdSPSOverrides;
    VkBool32 hasStdPPSOverrides;
}

struct VkVideoEncodeH264NaluSliceInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    int constantQp;
    const(StdVideoEncodeH264SliceHeader)* pStdSliceHeader;
}

struct VkVideoEncodeH264PictureInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint naluSliceEntryCount;
    const(VkVideoEncodeH264NaluSliceInfoKHR)* pNaluSliceEntries;
    const(StdVideoEncodeH264PictureInfo)* pStdPictureInfo;
    VkBool32 generatePrefixNalu;
}

struct VkVideoEncodeH264DpbSlotInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    const(StdVideoEncodeH264ReferenceInfo)* pStdReferenceInfo;
}

struct VkVideoEncodeH264ProfileInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    StdVideoH264ProfileIdc stdProfileIdc;
}

struct VkVideoEncodeH264RateControlInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkVideoEncodeH264RateControlFlagsKHR flags;
    uint gopFrameCount;
    uint idrPeriod;
    uint consecutiveBFrameCount;
    uint temporalLayerCount;
}

struct VkVideoEncodeH264FrameSizeKHR {
    uint frameISize;
    uint framePSize;
    uint frameBSize;
}

struct VkVideoEncodeH264RateControlLayerInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkBool32 useMinQp;
    VkVideoEncodeH264QpKHR minQp;
    VkBool32 useMaxQp;
    VkVideoEncodeH264QpKHR maxQp;
    VkBool32 useMaxFrameSize;
    VkVideoEncodeH264FrameSizeKHR maxFrameSize;
}

struct VkVideoEncodeH264GopRemainingFrameInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkBool32 useGopRemainingFrames;
    uint gopRemainingI;
    uint gopRemainingP;
    uint gopRemainingB;
}
