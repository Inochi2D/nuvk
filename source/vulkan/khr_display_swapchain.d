/**
    VK_KHR_display_swapchain
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_display_swapchain;
import vulkan.khr_swapchain;
import vulkan.khr_surface;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_DISPLAY_SWAPCHAIN_SPEC_VERSION = 10;
enum string VK_KHR_DISPLAY_SWAPCHAIN_EXTENSION_NAME = "VK_KHR_display_swapchain";

struct VkDisplayPresentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR;
    const(void)* pNext;
    VkRect2D srcRect;
    VkRect2D dstRect;
    VkBool32 persistent;
}

alias PFN_vkCreateSharedSwapchainsKHR = VkResult function(VkDevice device, uint swapchainCount, const(
        VkSwapchainCreateInfoKHR)* pCreateInfos, const(VkAllocationCallbacks)* pAllocator, VkSwapchainKHR* pSwapchains);
