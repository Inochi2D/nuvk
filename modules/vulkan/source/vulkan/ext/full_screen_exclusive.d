/**
 * VK_EXT_full_screen_exclusive (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Platform:
 *     Microsoft Win32 API (also refers to Win64 apps)
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.full_screen_exclusive;

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

public import vulkan.khr.swapchain;
public import vulkan.khr.get_surface_capabilities2;
public import vulkan.khr.surface;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}
version (Windows):

struct VK_EXT_full_screen_exclusive {
    @VkProcName("vkGetPhysicalDeviceSurfacePresentModes2EXT")
    PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT vkGetPhysicalDeviceSurfacePresentModes2EXT;
    
    @VkProcName("vkAcquireFullScreenExclusiveModeEXT")
    PFN_vkAcquireFullScreenExclusiveModeEXT vkAcquireFullScreenExclusiveModeEXT;
    
    @VkProcName("vkReleaseFullScreenExclusiveModeEXT")
    PFN_vkReleaseFullScreenExclusiveModeEXT vkReleaseFullScreenExclusiveModeEXT;
    
    @VkProcName("vkGetDeviceGroupSurfacePresentModes2EXT")
    PFN_vkGetDeviceGroupSurfacePresentModes2EXT vkGetDeviceGroupSurfacePresentModes2EXT;
}

enum VK_EXT_FULL_SCREEN_EXCLUSIVE_SPEC_VERSION = 4;
enum VK_EXT_FULL_SCREEN_EXCLUSIVE_EXTENSION_NAME = "VK_EXT_full_screen_exclusive";

alias VkFullScreenExclusiveEXT = uint;
enum VkFullScreenExclusiveEXT
    VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT = 0,
    VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT = 1,
    VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT = 2,
    VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT = 3;

struct VkSurfaceFullScreenExclusiveInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_INFO_EXT;
    void* pNext;
    VkFullScreenExclusiveEXT fullScreenExclusive;
}

struct VkSurfaceCapabilitiesFullScreenExclusiveEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_FULL_SCREEN_EXCLUSIVE_EXT;
    void* pNext;
    VkBool32 fullScreenExclusiveSupported;
}

import vulkan.khr.get_surface_capabilities2 : VkPhysicalDeviceSurfaceInfo2KHR;
import vulkan.khr.surface : VkPresentModeKHR;
alias PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceSurfaceInfo2KHR)* pSurfaceInfo,
    uint* pPresentModeCount,
    VkPresentModeKHR* pPresentModes,
);

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkAcquireFullScreenExclusiveModeEXT = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
);

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkReleaseFullScreenExclusiveModeEXT = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
);

public import vulkan.khr.win32_surface;

struct VkSurfaceFullScreenExclusiveWin32InfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_WIN32_INFO_EXT;
    const(void)* pNext;
    HMONITOR hmonitor;
}

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.device_group;
}

import vulkan.khr.get_surface_capabilities2 : VkPhysicalDeviceSurfaceInfo2KHR;
import vulkan.khr.device_group : VkDeviceGroupPresentModeFlagsKHR;
alias PFN_vkGetDeviceGroupSurfacePresentModes2EXT = VkResult function(
    VkDevice device,
    const(VkPhysicalDeviceSurfaceInfo2KHR)* pSurfaceInfo,
    VkDeviceGroupPresentModeFlagsKHR* pModes,
);
