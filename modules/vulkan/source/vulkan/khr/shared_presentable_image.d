/**
    VK_KHR_shared_presentable_image
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.shared_presentable_image;
import vulkan.khr.swapchain;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_SHARED_PRESENTABLE_IMAGE_SPEC_VERSION = 1;
enum string VK_KHR_SHARED_PRESENTABLE_IMAGE_EXTENSION_NAME = "VK_KHR_shared_presentable_image";

struct VkSharedPresentSurfaceCapabilitiesKHR {
    VkStructureType      sType = VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR;
    void*                pNext;
    VkImageUsageFlags    sharedPresentSupportedUsageFlags;
}

alias PFN_vkGetSwapchainStatusKHR = VkResult function(VkDevice device, VkSwapchainKHR swapchain);