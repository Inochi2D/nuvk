/**
 * VK_KHR_shared_presentable_image (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shared_presentable_image;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}
public import vulkan.khr.get_surface_capabilities2;
public import vulkan.khr.swapchain;

struct VK_KHR_shared_presentable_image {
    
    @VkProcName("vkGetSwapchainStatusKHR")
    PFN_vkGetSwapchainStatusKHR vkGetSwapchainStatusKHR;
}

enum VK_KHR_SHARED_PRESENTABLE_IMAGE_SPEC_VERSION = 1;
enum VK_KHR_SHARED_PRESENTABLE_IMAGE_EXTENSION_NAME = "VK_KHR_shared_presentable_image";

struct VkSharedPresentSurfaceCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR;
    void* pNext;
    VkFlags sharedPresentSupportedUsageFlags;
}

alias PFN_vkGetSwapchainStatusKHR = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
);
