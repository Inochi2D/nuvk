/**
 * VK_EXT_metal_surface
 * 
 * Author:
 *     Multivendor
 * 
 * Platform:
 *     Metal on CoreAnimation on Apple platforms
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.metal_surface;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.metal;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_EXT_metal_surface {
    
    @VkProcName("vkCreateMetalSurfaceEXT")
    PFN_vkCreateMetalSurfaceEXT vkCreateMetalSurfaceEXT;
}

enum VK_EXT_METAL_SURFACE_SPEC_VERSION = 1;
enum VK_EXT_METAL_SURFACE_EXTENSION_NAME = "VK_EXT_metal_surface";

alias VkMetalSurfaceCreateFlagsEXT = VkFlags;

struct VkMetalSurfaceCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_METAL_SURFACE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    const(CAMetalLayer)* pLayer;
}


alias PFN_vkCreateMetalSurfaceEXT = VkResult function(
    VkInstance instance,
    const(VkMetalSurfaceCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
