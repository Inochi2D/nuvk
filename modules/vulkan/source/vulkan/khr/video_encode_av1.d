/**
 * VK_KHR_video_encode_av1 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_encode_av1;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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

public import vulkan.khr.video_encode_queue;

enum VK_KHR_VIDEO_ENCODE_AV1_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_ENCODE_AV1_EXTENSION_NAME = "VK_KHR_video_encode_av1";
enum uint VK_MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR = 7;

struct VkPhysicalDeviceVideoEncodeAV1FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_AV1_FEATURES_KHR;
    void* pNext;
    VkBool32 videoEncodeAV1;
}

alias VkVideoEncodeAV1PredictionModeKHR = uint;
enum VkVideoEncodeAV1PredictionModeKHR
    VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_INTRA_ONLY_KHR = 0,
    VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_SINGLE_REFERENCE_KHR = 1,
    VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_UNIDIRECTIONAL_COMPOUND_KHR = 2,
    VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_BIDIRECTIONAL_COMPOUND_KHR = 3;

alias VkVideoEncodeAV1RateControlGroupKHR = uint;
enum VkVideoEncodeAV1RateControlGroupKHR
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_INTRA_KHR = 0,
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_PREDICTIVE_KHR = 1,
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_BIPREDICTIVE_KHR = 2;

alias VkVideoEncodeAV1CapabilityFlagsKHR = uint;
enum VkVideoEncodeAV1CapabilityFlagsKHR
    VK_VIDEO_ENCODE_AV1_CAPABILITY_PER_RATE_CONTROL_GROUP_MIN_MAX_Q_INDEX_BIT_KHR = 1,
    VK_VIDEO_ENCODE_AV1_CAPABILITY_GENERATE_OBU_EXTENSION_HEADER_BIT_KHR = 2,
    VK_VIDEO_ENCODE_AV1_CAPABILITY_PRIMARY_REFERENCE_CDF_ONLY_BIT_KHR = 4,
    VK_VIDEO_ENCODE_AV1_CAPABILITY_FRAME_SIZE_OVERRIDE_BIT_KHR = 8,
    VK_VIDEO_ENCODE_AV1_CAPABILITY_MOTION_VECTOR_SCALING_BIT_KHR = 16,
    VK_VIDEO_ENCODE_AV1_CAPABILITY_COMPOUND_PREDICTION_INTRA_REFRESH_BIT_KHR = 32;


alias VkVideoEncodeAV1StdFlagsKHR = uint;
enum VkVideoEncodeAV1StdFlagsKHR
    VK_VIDEO_ENCODE_AV1_STD_UNIFORM_TILE_SPACING_FLAG_SET_BIT_KHR = 1,
    VK_VIDEO_ENCODE_AV1_STD_SKIP_MODE_PRESENT_UNSET_BIT_KHR = 2,
    VK_VIDEO_ENCODE_AV1_STD_PRIMARY_REF_FRAME_BIT_KHR = 4,
    VK_VIDEO_ENCODE_AV1_STD_DELTA_Q_BIT_KHR = 8;


alias VkVideoEncodeAV1SuperblockSizeFlagsKHR = uint;
enum VkVideoEncodeAV1SuperblockSizeFlagsKHR
    VK_VIDEO_ENCODE_AV1_SUPERBLOCK_SIZE_64_BIT_KHR = 1,
    VK_VIDEO_ENCODE_AV1_SUPERBLOCK_SIZE_128_BIT_KHR = 2;


struct VkVideoEncodeAV1CapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_CAPABILITIES_KHR;
    void* pNext;
    VkVideoEncodeAV1CapabilityFlagsKHR flags;
    StdVideoAV1Level maxLevel;
    VkExtent2D codedPictureAlignment;
    VkExtent2D maxTiles;
    VkExtent2D minTileSize;
    VkExtent2D maxTileSize;
    VkVideoEncodeAV1SuperblockSizeFlagsKHR superblockSizes;
    uint maxSingleReferenceCount;
    uint singleReferenceNameMask;
    uint maxUnidirectionalCompoundReferenceCount;
    uint maxUnidirectionalCompoundGroup1ReferenceCount;
    uint unidirectionalCompoundReferenceNameMask;
    uint maxBidirectionalCompoundReferenceCount;
    uint maxBidirectionalCompoundGroup1ReferenceCount;
    uint maxBidirectionalCompoundGroup2ReferenceCount;
    uint bidirectionalCompoundReferenceNameMask;
    uint maxTemporalLayerCount;
    uint maxSpatialLayerCount;
    uint maxOperatingPoints;
    uint minQIndex;
    uint maxQIndex;
    VkBool32 prefersGopRemainingFrames;
    VkBool32 requiresGopRemainingFrames;
    VkVideoEncodeAV1StdFlagsKHR stdSyntaxFlags;
}

struct VkVideoEncodeAV1QualityLevelPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_QUALITY_LEVEL_PROPERTIES_KHR;
    void* pNext;
    VkVideoEncodeAV1RateControlFlagsKHR preferredRateControlFlags;
    uint preferredGopFrameCount;
    uint preferredKeyFramePeriod;
    uint preferredConsecutiveBipredictiveFrameCount;
    uint preferredTemporalLayerCount;
    VkVideoEncodeAV1QIndexKHR preferredConstantQIndex;
    uint preferredMaxSingleReferenceCount;
    uint preferredSingleReferenceNameMask;
    uint preferredMaxUnidirectionalCompoundReferenceCount;
    uint preferredMaxUnidirectionalCompoundGroup1ReferenceCount;
    uint preferredUnidirectionalCompoundReferenceNameMask;
    uint preferredMaxBidirectionalCompoundReferenceCount;
    uint preferredMaxBidirectionalCompoundGroup1ReferenceCount;
    uint preferredMaxBidirectionalCompoundGroup2ReferenceCount;
    uint preferredBidirectionalCompoundReferenceNameMask;
}

struct VkVideoEncodeAV1SessionCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_SESSION_CREATE_INFO_KHR;
    const(void)* pNext;
    VkBool32 useMaxLevel;
    StdVideoAV1Level maxLevel;
}

struct VkVideoEncodeAV1SessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    const(StdVideoAV1SequenceHeader)* pStdSequenceHeader;
    const(StdVideoEncodeAV1DecoderModelInfo)* pStdDecoderModelInfo;
    uint stdOperatingPointCount;
    const(StdVideoEncodeAV1OperatingPointInfo)* pStdOperatingPoints;
}

struct VkVideoEncodeAV1PictureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_PICTURE_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeAV1PredictionModeKHR predictionMode;
    VkVideoEncodeAV1RateControlGroupKHR rateControlGroup;
    uint constantQIndex;
    const(StdVideoEncodeAV1PictureInfo)* pStdPictureInfo;
    int[VK_MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR] referenceNameSlotIndices;
    VkBool32 primaryReferenceCdfOnly;
    VkBool32 generateObuExtensionHeader;
}

struct VkVideoEncodeAV1DpbSlotInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_DPB_SLOT_INFO_KHR;
    const(void)* pNext;
    const(StdVideoEncodeAV1ReferenceInfo)* pStdReferenceInfo;
}

struct VkVideoEncodeAV1ProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_PROFILE_INFO_KHR;
    const(void)* pNext;
    StdVideoAV1Profile stdProfile;
}

struct VkVideoEncodeAV1QIndexKHR {
    uint intraQIndex;
    uint predictiveQIndex;
    uint bipredictiveQIndex;
}

struct VkVideoEncodeAV1FrameSizeKHR {
    uint intraFrameSize;
    uint predictiveFrameSize;
    uint bipredictiveFrameSize;
}

struct VkVideoEncodeAV1GopRemainingFrameInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_GOP_REMAINING_FRAME_INFO_KHR;
    const(void)* pNext;
    VkBool32 useGopRemainingFrames;
    uint gopRemainingIntra;
    uint gopRemainingPredictive;
    uint gopRemainingBipredictive;
}

struct VkVideoEncodeAV1RateControlInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_RATE_CONTROL_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeAV1RateControlFlagsKHR flags;
    uint gopFrameCount;
    uint keyFramePeriod;
    uint consecutiveBipredictiveFrameCount;
    uint temporalLayerCount;
}

alias VkVideoEncodeAV1RateControlFlagsKHR = uint;
enum VkVideoEncodeAV1RateControlFlagsKHR
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REGULAR_GOP_BIT_KHR = 1,
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_TEMPORAL_LAYER_PATTERN_DYADIC_BIT_KHR = 2,
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REFERENCE_PATTERN_FLAT_BIT_KHR = 4,
    VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REFERENCE_PATTERN_DYADIC_BIT_KHR = 8;


struct VkVideoEncodeAV1RateControlLayerInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_RATE_CONTROL_LAYER_INFO_KHR;
    const(void)* pNext;
    VkBool32 useMinQIndex;
    VkVideoEncodeAV1QIndexKHR minQIndex;
    VkBool32 useMaxQIndex;
    VkVideoEncodeAV1QIndexKHR maxQIndex;
    VkBool32 useMaxFrameSize;
    VkVideoEncodeAV1FrameSizeKHR maxFrameSize;
}
