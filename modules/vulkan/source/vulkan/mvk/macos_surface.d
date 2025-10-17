/**
 * VK_MVK_macos_surface (Instance)
 * 
 * Author:
 *     The Brenwill Workshop Ltd.
 * 
 * Platform:
 *     Apple MacOS
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.mvk.macos_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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
version (OSX):

struct VK_MVK_macos_surface {
    
    @VkProcName("vkCreateMacOSSurfaceMVK")
    PFN_vkCreateMacOSSurfaceMVK vkCreateMacOSSurfaceMVK;
}

enum VK_MVK_MACOS_SURFACE_SPEC_VERSION = 3;
enum VK_MVK_MACOS_SURFACE_EXTENSION_NAME = "VK_MVK_macos_surface";

alias VkMacOSSurfaceCreateFlagsMVK = VkFlags;

struct VkMacOSSurfaceCreateInfoMVK {
    VkStructureType sType = VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
    const(void)* pNext;
    VkFlags flags;
    const(void)* pView;
}

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkCreateMacOSSurfaceMVK = VkResult function(
    VkInstance instance,
    const(VkMacOSSurfaceCreateInfoMVK)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);
