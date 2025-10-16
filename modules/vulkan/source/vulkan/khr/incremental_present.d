/**
 * VK_KHR_incremental_present
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.incremental_present;

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

public import vulkan.khr.swapchain;

enum VK_KHR_INCREMENTAL_PRESENT_SPEC_VERSION = 2;
enum VK_KHR_INCREMENTAL_PRESENT_EXTENSION_NAME = "VK_KHR_incremental_present";

struct VkPresentRegionsKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_REGIONS_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(VkPresentRegionKHR)* pRegions;
}

struct VkPresentRegionKHR {
    uint rectangleCount;
    const(VkRectLayerKHR)* pRectangles;
}

struct VkRectLayerKHR {
    VkOffset2D offset;
    VkExtent2D extent;
    uint layer;
}
