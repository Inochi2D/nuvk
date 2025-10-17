/**
 * VK_QNX_screen_surface (Instance)
 * 
 * Author:
 *     BlackBerry Limited
 * 
 * Platform:
 *     QNX Screen Graphics Subsystem
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qnx.screen_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.qnx;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_QNX_screen_surface {
    
    @VkProcName("vkCreateScreenSurfaceQNX")
    PFN_vkCreateScreenSurfaceQNX vkCreateScreenSurfaceQNX;
    
    @VkProcName("vkGetPhysicalDeviceScreenPresentationSupportQNX")
    PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX vkGetPhysicalDeviceScreenPresentationSupportQNX;
}

enum VK_QNX_SCREEN_SURFACE_SPEC_VERSION = 1;
enum VK_QNX_SCREEN_SURFACE_EXTENSION_NAME = "VK_QNX_screen_surface";

alias VkScreenSurfaceCreateFlagsQNX = VkFlags;

struct VkScreenSurfaceCreateInfoQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_SCREEN_SURFACE_CREATE_INFO_QNX;
    const(void)* pNext;
    VkFlags flags;
    _screen_context* context;
    _screen_window* window;
}

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkCreateScreenSurfaceQNX = VkResult function(
    VkInstance instance,
    const(VkScreenSurfaceCreateInfoQNX)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);

alias PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    _screen_window* window,
);
