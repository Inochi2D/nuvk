/**
 * VK_KHR_present_wait (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.present_wait;

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

public import vulkan.khr.present_id;
public import vulkan.khr.swapchain;

struct VK_KHR_present_wait {
    @VkProcName("vkWaitForPresentKHR")
    PFN_vkWaitForPresentKHR vkWaitForPresentKHR;
}

enum VK_KHR_PRESENT_WAIT_SPEC_VERSION = 1;
enum VK_KHR_PRESENT_WAIT_EXTENSION_NAME = "VK_KHR_present_wait";

struct VkPhysicalDevicePresentWaitFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_WAIT_FEATURES_KHR;
    void* pNext;
    VkBool32 presentWait;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkWaitForPresentKHR = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    ulong presentId,
    ulong timeout,
);
