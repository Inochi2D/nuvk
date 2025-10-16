/**
 * VK_MVK_ios_surface
 * 
 * Author:
 *     The Brenwill Workshop Ltd.
 * 
 * Platform:
 *     Apple IOS
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.mvk.ios_surface;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.ext.metal_surface;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;
version (iOS):

struct VK_MVK_ios_surface {
    
    @VkProcName("vkCreateIOSSurfaceMVK")
    PFN_vkCreateIOSSurfaceMVK vkCreateIOSSurfaceMVK;
}

enum VK_MVK_IOS_SURFACE_SPEC_VERSION = 3;
enum VK_MVK_IOS_SURFACE_EXTENSION_NAME = "VK_MVK_ios_surface";

alias VkIOSSurfaceCreateFlagsMVK = VkFlags;

struct VkIOSSurfaceCreateInfoMVK {
    VkStructureType sType = VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK;
    const(void)* pNext;
    VkFlags flags;
    const(void)* pView;
}

alias PFN_vkCreateIOSSurfaceMVK = VkResult function(
    VkInstance instance,
    const(VkIOSSurfaceCreateInfoMVK)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
