/**
 * VK_KHR_xcb_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     X Window System, Xcb client library
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.xcb_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.xcb;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_KHR_xcb_surface {
    
    @VkProcName("vkCreateXcbSurfaceKHR")
    PFN_vkCreateXcbSurfaceKHR vkCreateXcbSurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceXcbPresentationSupportKHR")
    PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR vkGetPhysicalDeviceXcbPresentationSupportKHR;
}

enum VK_KHR_XCB_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";

alias VkXcbSurfaceCreateFlagsKHR = VkFlags;

struct VkXcbSurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    xcb_connection_t* connection;
    xcb_window_t window;
}

alias PFN_vkCreateXcbSurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);

alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    xcb_connection_t* connection,
    xcb_visualid_t visual_id,
);
