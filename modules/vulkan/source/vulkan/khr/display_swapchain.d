/**
 * VK_KHR_display_swapchain (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.display_swapchain;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.display;
public import vulkan.khr.swapchain;

struct VK_KHR_display_swapchain {
    
    @VkProcName("vkCreateSharedSwapchainsKHR")
    PFN_vkCreateSharedSwapchainsKHR vkCreateSharedSwapchainsKHR;
}

enum VK_KHR_DISPLAY_SWAPCHAIN_SPEC_VERSION = 10;
enum VK_KHR_DISPLAY_SWAPCHAIN_EXTENSION_NAME = "VK_KHR_display_swapchain";

struct VkDisplayPresentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR;
    const(void)* pNext;
    VkRect2D srcRect;
    VkRect2D dstRect;
    VkBool32 persistent;
}

import vulkan.khr.swapchain : VkSwapchainCreateInfoKHR, VkSwapchainKHR;
alias PFN_vkCreateSharedSwapchainsKHR = VkResult function(
    VkDevice device,
    uint swapchainCount,
    const(VkSwapchainCreateInfoKHR)* pCreateInfos,
    const(VkAllocationCallbacks)* pAllocator,
    VkSwapchainKHR* pSwapchains,
);
