/**
 * VK_KHR_video_encode_intra_refresh (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_encode_intra_refresh;

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

public import vulkan.khr.video_encode_queue;

enum VK_KHR_VIDEO_ENCODE_INTRA_REFRESH_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_ENCODE_INTRA_REFRESH_EXTENSION_NAME = "VK_KHR_video_encode_intra_refresh";


alias VkVideoEncodeIntraRefreshModeFlagsKHR = uint;
enum VkVideoEncodeIntraRefreshModeFlagsKHR
    VK_VIDEO_ENCODE_INTRA_REFRESH_MODE_NONE_KHR = 0,
    VK_VIDEO_ENCODE_INTRA_REFRESH_MODE_PER_PICTURE_PARTITION_BIT_KHR = 1,
    VK_VIDEO_ENCODE_INTRA_REFRESH_MODE_BLOCK_BASED_BIT_KHR = 2,
    VK_VIDEO_ENCODE_INTRA_REFRESH_MODE_BLOCK_ROW_BASED_BIT_KHR = 4,
    VK_VIDEO_ENCODE_INTRA_REFRESH_MODE_BLOCK_COLUMN_BASED_BIT_KHR = 8;

struct VkVideoEncodeIntraRefreshCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_INTRA_REFRESH_CAPABILITIES_KHR;
    void* pNext;
    VkVideoEncodeIntraRefreshModeFlagsKHR intraRefreshModes;
    uint maxIntraRefreshCycleDuration;
    uint maxIntraRefreshActiveReferencePictures;
    VkBool32 partitionIndependentIntraRefreshRegions;
    VkBool32 nonRectangularIntraRefreshRegions;
}

struct VkVideoEncodeSessionIntraRefreshCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_INTRA_REFRESH_CREATE_INFO_KHR;
    const(void)* pNext;
    VkVideoEncodeIntraRefreshModeFlagsKHR intraRefreshMode;
}

struct VkVideoEncodeIntraRefreshInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_INTRA_REFRESH_INFO_KHR;
    const(void)* pNext;
    uint intraRefreshCycleDuration;
    uint intraRefreshIndex;
}

struct VkVideoReferenceIntraRefreshInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_REFERENCE_INTRA_REFRESH_INFO_KHR;
    const(void)* pNext;
    uint dirtyIntraRefreshRegions;
}

struct VkPhysicalDeviceVideoEncodeIntraRefreshFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_INTRA_REFRESH_FEATURES_KHR;
    void* pNext;
    VkBool32 videoEncodeIntraRefresh;
}
