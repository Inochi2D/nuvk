/**
 * VK_KHR_video_encode_quantization_map (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_encode_quantization_map;

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
    public import vulkan.khr.format_feature_flags2;
}
public import vulkan.khr.video_encode_queue;

enum VK_KHR_VIDEO_ENCODE_QUANTIZATION_MAP_SPEC_VERSION = 2;
enum VK_KHR_VIDEO_ENCODE_QUANTIZATION_MAP_EXTENSION_NAME = "VK_KHR_video_encode_quantization_map";

enum VkVideoEncodeFlagBitsKHR : uint {
    VK_VIDEO_ENCODE_INTRA_REFRESH_BIT_KHR = 4,
    VK_VIDEO_ENCODE_WITH_QUANTIZATION_DELTA_MAP_BIT_KHR = 1,
    VK_VIDEO_ENCODE_WITH_EMPHASIS_MAP_BIT_KHR = 2,
}

enum VK_VIDEO_ENCODE_INTRA_REFRESH_BIT_KHR = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_INTRA_REFRESH_BIT_KHR;
enum VK_VIDEO_ENCODE_WITH_QUANTIZATION_DELTA_MAP_BIT_KHR = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_WITH_QUANTIZATION_DELTA_MAP_BIT_KHR;
enum VK_VIDEO_ENCODE_WITH_EMPHASIS_MAP_BIT_KHR = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_WITH_EMPHASIS_MAP_BIT_KHR;

enum VkVideoSessionParametersCreateFlagBitsKHR : uint {
    VK_VIDEO_SESSION_PARAMETERS_CREATE_QUANTIZATION_MAP_COMPATIBLE_BIT_KHR = 1,
}

enum VK_VIDEO_SESSION_PARAMETERS_CREATE_QUANTIZATION_MAP_COMPATIBLE_BIT_KHR = VkVideoSessionParametersCreateFlagBitsKHR.VK_VIDEO_SESSION_PARAMETERS_CREATE_QUANTIZATION_MAP_COMPATIBLE_BIT_KHR;

struct VkVideoEncodeQuantizationMapCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_CAPABILITIES_KHR;
    void* pNext;
    VkExtent2D maxQuantizationMapExtent;
}

struct VkVideoFormatQuantizationMapPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_FORMAT_QUANTIZATION_MAP_PROPERTIES_KHR;
    void* pNext;
    VkExtent2D quantizationMapTexelSize;
}

struct VkVideoEncodeQuantizationMapInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_INFO_KHR;
    const(void)* pNext;
    VkImageView quantizationMap;
    VkExtent2D quantizationMapExtent;
}

struct VkVideoEncodeQuantizationMapSessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    VkExtent2D quantizationMapTexelSize;
}

struct VkPhysicalDeviceVideoEncodeQuantizationMapFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_QUANTIZATION_MAP_FEATURES_KHR;
    void* pNext;
    VkBool32 videoEncodeQuantizationMap;
}

public import vulkan.khr.video_encode_h264;

struct VkVideoEncodeH264QuantizationMapCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_QUANTIZATION_MAP_CAPABILITIES_KHR;
    void* pNext;
    int minQpDelta;
    int maxQpDelta;
}

public import vulkan.khr.video_encode_h265;

struct VkVideoEncodeH265QuantizationMapCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_QUANTIZATION_MAP_CAPABILITIES_KHR;
    void* pNext;
    int minQpDelta;
    int maxQpDelta;
}

struct VkVideoFormatH265QuantizationMapPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_FORMAT_H265_QUANTIZATION_MAP_PROPERTIES_KHR;
    void* pNext;
    VkFlags compatibleCtbSizes;
}

public import vulkan.khr.video_encode_av1;

struct VkVideoEncodeAV1QuantizationMapCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_QUANTIZATION_MAP_CAPABILITIES_KHR;
    void* pNext;
    int minQIndexDelta;
    int maxQIndexDelta;
}

struct VkVideoFormatAV1QuantizationMapPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_FORMAT_AV1_QUANTIZATION_MAP_PROPERTIES_KHR;
    void* pNext;
    VkFlags compatibleSuperblockSizes;
}
