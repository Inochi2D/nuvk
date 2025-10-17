/**
 * VK_KHR_wayland_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     Wayland display server protocol
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.wayland_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.wayland;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_KHR_wayland_surface {
    
    @VkProcName("vkCreateWaylandSurfaceKHR")
    PFN_vkCreateWaylandSurfaceKHR vkCreateWaylandSurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceWaylandPresentationSupportKHR")
    PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR vkGetPhysicalDeviceWaylandPresentationSupportKHR;
}

enum VK_KHR_WAYLAND_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";

alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;

struct VkWaylandSurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    wl_display* display;
    wl_surface* surface;
}

alias PFN_vkCreateWaylandSurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkWaylandSurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);

alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR = VkBool32 function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    wl_display* display,
);
