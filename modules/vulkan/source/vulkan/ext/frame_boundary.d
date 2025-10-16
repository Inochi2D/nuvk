/**
 * VK_EXT_frame_boundary (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.frame_boundary;

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

enum VK_EXT_FRAME_BOUNDARY_SPEC_VERSION = 1;
enum VK_EXT_FRAME_BOUNDARY_EXTENSION_NAME = "VK_EXT_frame_boundary";

struct VkPhysicalDeviceFrameBoundaryFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAME_BOUNDARY_FEATURES_EXT;
    void* pNext;
    VkBool32 frameBoundary;
}

struct VkFrameBoundaryEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_FRAME_BOUNDARY_EXT;
    const(void)* pNext;
    VkFlags flags;
    ulong frameID;
    uint imageCount;
    const(VkImage)* pImages;
    uint bufferCount;
    const(VkBuffer)* pBuffers;
    ulong tagName;
    size_t tagSize;
    const(void)* pTag;
}

enum VkFrameBoundaryFlagBitsEXT : uint {
    VK_FRAME_BOUNDARY_FRAME_END_BIT_EXT = 1,
}

enum VK_FRAME_BOUNDARY_FRAME_END_BIT_EXT = VkFrameBoundaryFlagBitsEXT.VK_FRAME_BOUNDARY_FRAME_END_BIT_EXT;

alias VkFrameBoundaryFlagsEXT = VkFlags;
