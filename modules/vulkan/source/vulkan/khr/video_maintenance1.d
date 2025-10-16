/**
 * VK_KHR_video_maintenance1
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.video_maintenance1;

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

public import vulkan.khr.video_queue;

enum VK_KHR_VIDEO_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_KHR_VIDEO_MAINTENANCE_1_EXTENSION_NAME = "VK_KHR_video_maintenance1";

struct VkPhysicalDeviceVideoMaintenance1FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_MAINTENANCE_1_FEATURES_KHR;
    void* pNext;
    VkBool32 videoMaintenance1;
}

struct VkVideoInlineQueryInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_INLINE_QUERY_INFO_KHR;
    const(void)* pNext;
    VkQueryPool queryPool;
    uint firstQuery;
    uint queryCount;
}
