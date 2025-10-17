/**
 * VK_EXT_directfb_surface (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Platform:
 *     DirectFB library
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.directfb_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.directfb;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_EXT_directfb_surface {
    
    @VkProcName("vkCreateDirectFBSurfaceEXT")
    PFN_vkCreateDirectFBSurfaceEXT vkCreateDirectFBSurfaceEXT;
    
    @VkProcName("vkGetPhysicalDeviceDirectFBPresentationSupportEXT")
    PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
}

enum VK_EXT_DIRECTFB_SURFACE_SPEC_VERSION = 1;
enum VK_EXT_DIRECTFB_SURFACE_EXTENSION_NAME = "VK_EXT_directfb_surface";

alias VkDirectFBSurfaceCreateFlagsEXT = VkFlags;

struct VkDirectFBSurfaceCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DIRECTFB_SURFACE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    IDirectFB* dfb;
    IDirectFBSurface* surface;
}

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkCreateDirectFBSurfaceEXT = VkResult function(
    VkInstance instance,
    const(VkDirectFBSurfaceCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);

alias PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    IDirectFB* dfb,
);
