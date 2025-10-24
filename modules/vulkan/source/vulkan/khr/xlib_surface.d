/**
 * VK_KHR_xlib_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     X Window System, Xlib client library
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.xlib_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.xlib;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_KHR_xlib_surface {
    @VkProcName("vkCreateXlibSurfaceKHR")
    PFN_vkCreateXlibSurfaceKHR vkCreateXlibSurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceXlibPresentationSupportKHR")
    PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR vkGetPhysicalDeviceXlibPresentationSupportKHR;
}

enum VK_KHR_XLIB_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_XLIB_SURFACE_EXTENSION_NAME = "VK_KHR_xlib_surface";

alias VkXlibSurfaceCreateFlagsKHR = VkFlags;

struct VkXlibSurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkXlibSurfaceCreateFlagsKHR flags;
    Display* dpy;
    Window window;
}

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkCreateXlibSurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkXlibSurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);

alias PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    Display* dpy,
    VisualID visualID,
);
