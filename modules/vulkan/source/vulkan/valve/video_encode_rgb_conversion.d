/**
 * VK_VALVE_video_encode_rgb_conversion
 * 
 * Author:
 *     Valve Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.valve.video_encode_rgb_conversion;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.sampler_ycbcr_conversion;
}
public import vulkan.khr.video_encode_queue;

enum VK_VALVE_VIDEO_ENCODE_RGB_CONVERSION_SPEC_VERSION = 1;
enum VK_VALVE_VIDEO_ENCODE_RGB_CONVERSION_EXTENSION_NAME = "VK_VALVE_video_encode_rgb_conversion";

struct VkPhysicalDeviceVideoEncodeRgbConversionFeaturesVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_RGB_CONVERSION_FEATURES_VALVE;
    void* pNext;
    VkBool32 videoEncodeRgbConversion;
}

struct VkVideoEncodeRgbConversionCapabilitiesVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RGB_CONVERSION_CAPABILITIES_VALVE;
    void* pNext;
    VkFlags rgbModels;
    VkFlags rgbRanges;
    VkFlags xChromaOffsets;
    VkFlags yChromaOffsets;
}

struct VkVideoEncodeProfileRgbConversionInfoVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_PROFILE_RGB_CONVERSION_INFO_VALVE;
    const(void)* pNext;
    VkBool32 performEncodeRgbConversion;
}

struct VkVideoEncodeSessionRgbConversionCreateInfoVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_RGB_CONVERSION_CREATE_INFO_VALVE;
    const(void)* pNext;
    VkVideoEncodeRgbModelConversionFlagBitsVALVE rgbModel;
    VkVideoEncodeRgbRangeCompressionFlagBitsVALVE rgbRange;
    VkVideoEncodeRgbChromaOffsetFlagBitsVALVE xChromaOffset;
    VkVideoEncodeRgbChromaOffsetFlagBitsVALVE yChromaOffset;
}

enum VkVideoEncodeRgbModelConversionFlagBitsVALVE : uint {
    VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_RGB_IDENTITY_BIT_VALVE = 1,
    VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_IDENTITY_BIT_VALVE = 2,
    VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_709_BIT_VALVE = 4,
    VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_601_BIT_VALVE = 8,
    VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_2020_BIT_VALVE = 16,
}

enum VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_RGB_IDENTITY_BIT_VALVE = VkVideoEncodeRgbModelConversionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_RGB_IDENTITY_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_IDENTITY_BIT_VALVE = VkVideoEncodeRgbModelConversionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_IDENTITY_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_709_BIT_VALVE = VkVideoEncodeRgbModelConversionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_709_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_601_BIT_VALVE = VkVideoEncodeRgbModelConversionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_601_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_2020_BIT_VALVE = VkVideoEncodeRgbModelConversionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_MODEL_CONVERSION_YCBCR_2020_BIT_VALVE;

alias VkVideoEncodeRgbModelConversionFlagsVALVE = VkFlags;

enum VkVideoEncodeRgbRangeCompressionFlagBitsVALVE : uint {
    VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_FULL_RANGE_BIT_VALVE = 1,
    VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_NARROW_RANGE_BIT_VALVE = 2,
}

enum VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_FULL_RANGE_BIT_VALVE = VkVideoEncodeRgbRangeCompressionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_FULL_RANGE_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_NARROW_RANGE_BIT_VALVE = VkVideoEncodeRgbRangeCompressionFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_RANGE_COMPRESSION_NARROW_RANGE_BIT_VALVE;

alias VkVideoEncodeRgbRangeCompressionFlagsVALVE = VkFlags;

enum VkVideoEncodeRgbChromaOffsetFlagBitsVALVE : uint {
    VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_COSITED_EVEN_BIT_VALVE = 1,
    VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_MIDPOINT_BIT_VALVE = 2,
}

enum VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_COSITED_EVEN_BIT_VALVE = VkVideoEncodeRgbChromaOffsetFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_COSITED_EVEN_BIT_VALVE;
enum VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_MIDPOINT_BIT_VALVE = VkVideoEncodeRgbChromaOffsetFlagBitsVALVE.VK_VIDEO_ENCODE_RGB_CHROMA_OFFSET_MIDPOINT_BIT_VALVE;

alias VkVideoEncodeRgbChromaOffsetFlagsVALVE = VkFlags;
