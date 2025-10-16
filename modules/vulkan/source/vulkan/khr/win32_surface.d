/**
 * VK_KHR_win32_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     Microsoft Win32 API (also refers to Win64 apps)
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.win32_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.windows;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;
version (Windows):

struct VK_KHR_win32_surface {
    
    @VkProcName("vkCreateWin32SurfaceKHR")
    PFN_vkCreateWin32SurfaceKHR vkCreateWin32SurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceWin32PresentationSupportKHR")
    PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR vkGetPhysicalDeviceWin32PresentationSupportKHR;
}

enum VK_KHR_WIN32_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";

alias VkWin32SurfaceCreateFlagsKHR = VkFlags;

struct VkWin32SurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    HINSTANCE hinstance;
    HWND hwnd;
}

alias PFN_vkCreateWin32SurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkWin32SurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);

alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
);
