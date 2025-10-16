/**
 * VK_KHR_video_maintenance2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_maintenance2;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.video.av1std;
import vulkan.video.h264std;
import vulkan.video.h265std;
import vulkan.video.vp9std;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.video_queue;

enum VK_KHR_VIDEO_MAINTENANCE_2_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_MAINTENANCE_2_EXTENSION_NAME = "VK_KHR_video_maintenance2";

struct VkPhysicalDeviceVideoMaintenance2FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_MAINTENANCE_2_FEATURES_KHR;
    void* pNext;
    VkBool32 videoMaintenance2;
}

public import vulkan.khr.video_decode_h264;

struct VkVideoDecodeH264InlineSessionParametersInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_INLINE_SESSION_PARAMETERS_INFO_KHR;
    const(void)* pNext;
    const(StdVideoH264SequenceParameterSet)* pStdSPS;
    const(StdVideoH264PictureParameterSet)* pStdPPS;
}

public import vulkan.khr.video_decode_h265;

struct VkVideoDecodeH265InlineSessionParametersInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_INLINE_SESSION_PARAMETERS_INFO_KHR;
    const(void)* pNext;
    const(StdVideoH265VideoParameterSet)* pStdVPS;
    const(StdVideoH265SequenceParameterSet)* pStdSPS;
    const(StdVideoH265PictureParameterSet)* pStdPPS;
}

public import vulkan.khr.video_decode_av1;

struct VkVideoDecodeAV1InlineSessionParametersInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_INLINE_SESSION_PARAMETERS_INFO_KHR;
    const(void)* pNext;
    const(StdVideoAV1SequenceHeader)* pStdSequenceHeader;
}
