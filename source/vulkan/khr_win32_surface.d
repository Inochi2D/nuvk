/**
    VK_KHR_win32_surface
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_win32_surface;
import vulkan.khr_surface;
import vulkan.core;
import nuvk.core.loader;

extern(System) @nogc nothrow:

enum uint VK_KHR_WIN32_SURFACE_SPEC_VERSION = 6;
enum string VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";

alias VkWin32SurfaceCreateFlagsKHR = VkFlags;
struct VkWin32SurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkWin32SurfaceCreateFlagsKHR flags;
    void* hinstance;
    void* hwnd;
}

alias PFN_vkCreateWin32SurfaceKHR = VkResult function(VkInstance instance, const(VkWin32SurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface);
alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR = VkBool32 function(VkPhysicalDevice physicalDevice, uint queueFamilyIndex);

/**
    VK_KHR_win32_surface procedures.

    See_Also:
        $(D nuvk.core.loader.loadProcs)
*/
struct VK_KHR_win32_surface {
    
    @VkProcName("vkCreateWin32SurfaceKHR")
    PFN_vkCreateWin32SurfaceKHR vkCreateWin32SurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceWin32PresentationSupportKHR")
    PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR vkGetPhysicalDeviceWin32PresentationSupportKHR;
}