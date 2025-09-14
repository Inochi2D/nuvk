/**
    VK_KHR_wayland_surface
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_wayland_surface;
import vulkan.khr_surface;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_WAYLAND_SURFACE_SPEC_VERSION = 6;
enum string VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";

/**
    Opaque wl_display type.
*/
struct wl_display;

/**
    Opaque wl_surface type.
*/
struct wl_surface;

alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;
struct VkWaylandSurfaceCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkWaylandSurfaceCreateFlagsKHR flags;
    wl_display* display;
    wl_surface* surface;
}

alias PFN_vkCreateWaylandSurfaceKHR = VkResult(VkInstance instance, const(VkWaylandSurfaceCreateInfoKHR) * pCreateInfo, const(
        VkAllocationCallbacks) * pAllocator, VkSurfaceKHR * pSurface);
alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR = VkBool32(
    VkPhysicalDevice physicalDevice, uint queueFamilyIndex, wl_display * display);
