/**
 * VK_EXT_headless_surface (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.headless_surface;

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

public import vulkan.khr.surface;

struct VK_EXT_headless_surface {
    
    @VkProcName("vkCreateHeadlessSurfaceEXT")
    PFN_vkCreateHeadlessSurfaceEXT vkCreateHeadlessSurfaceEXT;
}

enum VK_EXT_HEADLESS_SURFACE_SPEC_VERSION = 1;
enum VK_EXT_HEADLESS_SURFACE_EXTENSION_NAME = "VK_EXT_headless_surface";

alias VkHeadlessSurfaceCreateFlagsEXT = VkFlags;

struct VkHeadlessSurfaceCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_HEADLESS_SURFACE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
}

alias PFN_vkCreateHeadlessSurfaceEXT = VkResult function(
    VkInstance instance,
    const(VkHeadlessSurfaceCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
