/**
 * VK_KHR_video_encode_queue (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_encode_queue;

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

struct VK_KHR_video_encode_queue {
    @VkProcName("vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR")
    PFN_vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR;
    
    @VkProcName("vkGetEncodedVideoSessionParametersKHR")
    PFN_vkGetEncodedVideoSessionParametersKHR vkGetEncodedVideoSessionParametersKHR;
    
    @VkProcName("vkCmdEncodeVideoKHR")
    PFN_vkCmdEncodeVideoKHR vkCmdEncodeVideoKHR;
}

enum VK_KHR_VIDEO_ENCODE_QUEUE_SPEC_VERSION = 12;
enum VK_KHR_VIDEO_ENCODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_encode_queue";

import vulkan.khr.video_encode_quantization_map : VkVideoEncodeFlagsKHR;

import vulkan.khr.video_queue : VkVideoPictureResourceInfoKHR, VkVideoReferenceSlotInfoKHR, VkVideoReferenceSlotInfoKHR;
struct VkVideoEncodeInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeFlagsKHR flags;
    VkBuffer dstBuffer;
    VkDeviceSize dstBufferOffset;
    VkDeviceSize dstBufferRange;
    VkVideoPictureResourceInfoKHR srcPictureResource;
    const(VkVideoReferenceSlotInfoKHR)* pSetupReferenceSlot;
    uint referenceSlotCount;
    const(VkVideoReferenceSlotInfoKHR)* pReferenceSlots;
    uint precedingExternallyEncodedBytes;
}

alias VkVideoEncodeCapabilityFlagsKHR = uint;
enum VkVideoEncodeCapabilityFlagsKHR
    VK_VIDEO_ENCODE_CAPABILITY_PRECEDING_EXTERNALLY_ENCODED_BYTES_BIT_KHR = 1,
    VK_VIDEO_ENCODE_CAPABILITY_INSUFFICIENT_BITSTREAM_BUFFER_RANGE_DETECTION_BIT_KHR = 2,
    VK_VIDEO_ENCODE_CAPABILITY_QUANTIZATION_DELTA_MAP_BIT_KHR = 4,
    VK_VIDEO_ENCODE_CAPABILITY_EMPHASIS_MAP_BIT_KHR = 8;


struct VkVideoEncodeCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_CAPABILITIES_KHR;
    void* pNext;
    VkVideoEncodeCapabilityFlagsKHR flags;
    VkVideoEncodeRateControlModeFlagsKHR rateControlModes;
    uint maxRateControlLayers;
    ulong maxBitrate;
    uint maxQualityLevels;
    VkExtent2D encodeInputPictureGranularity;
    VkVideoEncodeFeedbackFlagsKHR supportedEncodeFeedbackFlags;
}

struct VkQueryPoolVideoEncodeFeedbackCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUERY_POOL_VIDEO_ENCODE_FEEDBACK_CREATE_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeFeedbackFlagsKHR encodeFeedbackFlags;
}

alias VkVideoEncodeFeedbackFlagsKHR = uint;
enum VkVideoEncodeFeedbackFlagsKHR
    VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BUFFER_OFFSET_BIT_KHR = 1,
    VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BYTES_WRITTEN_BIT_KHR = 2,
    VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_HAS_OVERRIDES_BIT_KHR = 4,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_3_BIT_KHR = 8,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_4_BIT_KHR = 16,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_5_BIT_KHR = 32,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_6_BIT_KHR = 64,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_7_BIT_KHR = 128,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_8_BIT_KHR = 256,
    VK_VIDEO_ENCODE_FEEDBACK_RESERVED_9_BIT_KHR = 512;


alias VkVideoEncodeUsageFlagsKHR = uint;
enum VkVideoEncodeUsageFlagsKHR
    VK_VIDEO_ENCODE_USAGE_DEFAULT_KHR = 0,
    VK_VIDEO_ENCODE_USAGE_TRANSCODING_BIT_KHR = 1,
    VK_VIDEO_ENCODE_USAGE_STREAMING_BIT_KHR = 2,
    VK_VIDEO_ENCODE_USAGE_RECORDING_BIT_KHR = 4,
    VK_VIDEO_ENCODE_USAGE_CONFERENCING_BIT_KHR = 8;


alias VkVideoEncodeContentFlagsKHR = uint;
enum VkVideoEncodeContentFlagsKHR
    VK_VIDEO_ENCODE_CONTENT_DEFAULT_KHR = 0,
    VK_VIDEO_ENCODE_CONTENT_CAMERA_BIT_KHR = 1,
    VK_VIDEO_ENCODE_CONTENT_DESKTOP_BIT_KHR = 2,
    VK_VIDEO_ENCODE_CONTENT_RENDERED_BIT_KHR = 4;


alias VkVideoEncodeTuningModeKHR = uint;
enum VkVideoEncodeTuningModeKHR
    VK_VIDEO_ENCODE_TUNING_MODE_DEFAULT_KHR = 0,
    VK_VIDEO_ENCODE_TUNING_MODE_HIGH_QUALITY_KHR = 1,
    VK_VIDEO_ENCODE_TUNING_MODE_LOW_LATENCY_KHR = 2,
    VK_VIDEO_ENCODE_TUNING_MODE_ULTRA_LOW_LATENCY_KHR = 3,
    VK_VIDEO_ENCODE_TUNING_MODE_LOSSLESS_KHR = 4;

struct VkVideoEncodeUsageInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_USAGE_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeUsageFlagsKHR videoUsageHints;
    VkVideoEncodeContentFlagsKHR videoContentHints;
    VkVideoEncodeTuningModeKHR tuningMode;
}

alias VkVideoEncodeRateControlFlagsKHR = VkFlags;

alias VkVideoEncodeRateControlModeFlagsKHR = uint;
enum VkVideoEncodeRateControlModeFlagsKHR
    VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DEFAULT_KHR = 0,
    VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DISABLED_BIT_KHR = 1,
    VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR = 2,
    VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR = 4;


struct VkVideoEncodeRateControlInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeRateControlFlagsKHR flags;
    VkVideoEncodeRateControlModeFlagsKHR rateControlMode;
    uint layerCount;
    const(VkVideoEncodeRateControlLayerInfoKHR)* pLayers;
    uint virtualBufferSizeInMs;
    uint initialVirtualBufferSizeInMs;
}

struct VkVideoEncodeRateControlLayerInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_LAYER_INFO_KHR;
    const(void)* pNext;
    ulong averageBitrate;
    ulong maxBitrate;
    uint frameRateNumerator;
    uint frameRateDenominator;
}

import vulkan.khr.video_queue : VkVideoProfileInfoKHR;
struct VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_QUALITY_LEVEL_INFO_KHR;
    const(void)* pNext;
    const(VkVideoProfileInfoKHR)* pVideoProfile;
    uint qualityLevel;
}

struct VkVideoEncodeQualityLevelPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUALITY_LEVEL_PROPERTIES_KHR;
    void* pNext;
    VkVideoEncodeRateControlModeFlagsKHR preferredRateControlMode;
    uint preferredRateControlLayerCount;
}

struct VkVideoEncodeQualityLevelInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUALITY_LEVEL_INFO_KHR;
    const(void)* pNext;
    uint qualityLevel;
}

import vulkan.khr.video_queue : VkVideoSessionParametersKHR;
struct VkVideoEncodeSessionParametersGetInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_PARAMETERS_GET_INFO_KHR;
    const(void)* pNext;
    VkVideoSessionParametersKHR videoSessionParameters;
}

struct VkVideoEncodeSessionParametersFeedbackInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_PARAMETERS_FEEDBACK_INFO_KHR;
    void* pNext;
    VkBool32 hasOverrides;
}

alias PFN_vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR)* pQualityLevelInfo,
    VkVideoEncodeQualityLevelPropertiesKHR* pQualityLevelProperties,
);

alias PFN_vkGetEncodedVideoSessionParametersKHR = VkResult function(
    VkDevice device,
    const(VkVideoEncodeSessionParametersGetInfoKHR)* pVideoSessionParametersInfo,
    VkVideoEncodeSessionParametersFeedbackInfoKHR* pFeedbackInfo,
    size_t* pDataSize,
    void* pData,
);

alias PFN_vkCmdEncodeVideoKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkVideoEncodeInfoKHR)* pEncodeInfo,
);
