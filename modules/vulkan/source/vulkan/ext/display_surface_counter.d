/**
 * VK_EXT_display_surface_counter (Instance)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.display_surface_counter;

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

struct VK_EXT_display_surface_counter {
    @VkProcName("vkGetPhysicalDeviceSurfaceCapabilities2EXT")
    PFN_vkGetPhysicalDeviceSurfaceCapabilities2EXT vkGetPhysicalDeviceSurfaceCapabilities2EXT;
}

enum VK_EXT_DISPLAY_SURFACE_COUNTER_SPEC_VERSION = 1;
enum VK_EXT_DISPLAY_SURFACE_COUNTER_EXTENSION_NAME = "VK_EXT_display_surface_counter";


alias VkSurfaceCounterFlagsEXT = uint;
enum VkSurfaceCounterFlagsEXT
    VK_SURFACE_COUNTER_VBLANK_BIT_EXT = 1,
    VK_SURFACE_COUNTER_VBLANK_EXT = VK_SURFACE_COUNTER_VBLANK_BIT_EXT;

import vulkan.khr.surface : VkSurfaceTransformFlagsKHR, VkSurfaceTransformFlagsKHR, VkCompositeAlphaFlagsKHR;
struct VkSurfaceCapabilities2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT;
    void* pNext;
    uint minImageCount;
    uint maxImageCount;
    VkExtent2D currentExtent;
    VkExtent2D minImageExtent;
    VkExtent2D maxImageExtent;
    uint maxImageArrayLayers;
    VkSurfaceTransformFlagsKHR supportedTransforms;
    VkSurfaceTransformFlagsKHR currentTransform;
    VkCompositeAlphaFlagsKHR supportedCompositeAlpha;
    VkImageUsageFlags supportedUsageFlags;
    VkSurfaceCounterFlagsEXT supportedSurfaceCounters;
}

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkGetPhysicalDeviceSurfaceCapabilities2EXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    VkSurfaceCapabilities2EXT* pSurfaceCapabilities,
);
