/**
    VK_KHR_xcb_surface
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_xcb_surface;
import vulkan.khr_surface;
import vulkan.core;
import nuvk.core.loader;

extern (System) @nogc nothrow:

enum uint VK_KHR_XCB_SURFACE_SPEC_VERSION = 6;
enum string VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";

/**
    Opaque xcb_connection_t type.
*/
struct xcb_connection_t;

/**
    xcb_window_t type.
*/
alias xcb_window_t = uint;

/**
    xcb_visualid_t type.
*/
alias xcb_visualid_t = uint;

alias VkXcbSurfaceCreateFlagsKHR = VkFlags;
struct VkXcbSurfaceCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkXcbSurfaceCreateFlagsKHR flags;
    xcb_connection_t* connection;
    xcb_window_t window;
}

alias PFN_vkCreateXcbSurfaceKHR = VkResult function(VkInstance instance, const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface);
alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR = VkBool32 function(VkPhysicalDevice physicalDevice, uint queueFamilyIndex, xcb_connection_t* connection, xcb_visualid_t visual_id);

/**
    VK_KHR_xcb_surface procedures.

    See_Also:
        $(D nuvk.core.loader.loadProcs)
*/
struct VK_KHR_xcb_surface {
    
    @VkProcName("vkCreateXcbSurfaceKHR")
    PFN_vkCreateXcbSurfaceKHR vkCreateXcbSurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceXcbPresentationSupportKHR")
    PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR vkGetPhysicalDeviceXcbPresentationSupportKHR;
}