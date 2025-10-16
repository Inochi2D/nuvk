/**
 * VK_KHR_present_wait2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.present_wait2;

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

public import vulkan.khr.present_id2;
public import vulkan.khr.swapchain;
public import vulkan.khr.surface;
public import vulkan.khr.get_surface_capabilities2;

struct VK_KHR_present_wait2 {
    
    @VkProcName("vkWaitForPresent2KHR")
    PFN_vkWaitForPresent2KHR vkWaitForPresent2KHR;
}

enum VK_KHR_PRESENT_WAIT_2_SPEC_VERSION = 1;
enum VK_KHR_PRESENT_WAIT_2_EXTENSION_NAME = "VK_KHR_present_wait2";

struct VkSurfaceCapabilitiesPresentWait2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_PRESENT_WAIT_2_KHR;
    void* pNext;
    VkBool32 presentWait2Supported;
}

struct VkPhysicalDevicePresentWait2FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_WAIT_2_FEATURES_KHR;
    void* pNext;
    VkBool32 presentWait2;
}

struct VkPresentWait2InfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_WAIT_2_INFO_KHR;
    const(void)* pNext;
    ulong presentId;
    ulong timeout;
}

alias PFN_vkWaitForPresent2KHR = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    const(VkPresentWait2InfoKHR)* pPresentWait2Info,
);
