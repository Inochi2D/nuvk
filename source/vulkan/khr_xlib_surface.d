/**
    VK_KHR_xlib_surface
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_xlib_surface;
import vulkan.khr_surface;
import vulkan.core;
import nuvk.core.loader;

extern (System) @nogc nothrow:

enum VK_KHR_XLIB_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_XLIB_SURFACE_EXTENSION_NAME = "VK_KHR_xlib_surface";

/**
    Opaque Display type.
*/
struct Display;

/**
    Window type.
*/
alias Window = uint;

/**
    VisualID type.
*/
alias VisualID = uint;

alias VkXlibSurfaceCreateFlagsKHR = VkFlags;

struct VkXlibSurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkXlibSurfaceCreateFlagsKHR flags;
    Display* dpy;
    Window window;
}

alias PFN_vkCreateXlibSurfaceKHR = VkResult function(VkInstance instance, const(VkXlibSurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface);
alias PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR = VkBool32 function(VkPhysicalDevice physicalDevice, uint queueFamilyIndex, Display* dpy, VisualID visualID);

/**
    VK_KHR_xlib_surface procedures.

    See_Also:
        $(D nuvk.core.loader.loadProcs)
*/
struct VK_KHR_xlib_surface {
    
    @VkProcName("vkCreateXlibSurfaceKHR")
    PFN_vkCreateXlibSurfaceKHR vkCreateXlibSurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceXlibPresentationSupportKHR")
    PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR vkGetPhysicalDeviceXlibPresentationSupportKHR;
}