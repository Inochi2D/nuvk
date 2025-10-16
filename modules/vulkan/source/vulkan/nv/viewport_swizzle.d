/**
 * VK_NV_viewport_swizzle (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.viewport_swizzle;

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

enum VK_NV_VIEWPORT_SWIZZLE_SPEC_VERSION = 1;
enum VK_NV_VIEWPORT_SWIZZLE_EXTENSION_NAME = "VK_NV_viewport_swizzle";

struct VkViewportSwizzleNV {
    VkViewportCoordinateSwizzleNV x;
    VkViewportCoordinateSwizzleNV y;
    VkViewportCoordinateSwizzleNV z;
    VkViewportCoordinateSwizzleNV w;
}

enum VkViewportCoordinateSwizzleNV {
    VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_X_NV = 0,
    VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_X_NV = 1,
    VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Y_NV = 2,
    VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Y_NV = 3,
    VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Z_NV = 4,
    VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Z_NV = 5,
    VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_W_NV = 6,
    VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_W_NV = 7,
}

enum VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_X_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_X_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_X_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_X_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Y_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Y_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Y_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Y_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Z_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Z_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Z_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Z_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_W_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_W_NV;
enum VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_W_NV = VkViewportCoordinateSwizzleNV.VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_W_NV;

struct VkPipelineViewportSwizzleStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SWIZZLE_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkFlags flags;
    uint viewportCount;
    const(VkViewportSwizzleNV)* pViewportSwizzles;
}

alias VkPipelineViewportSwizzleStateCreateFlagsNV = VkFlags;
