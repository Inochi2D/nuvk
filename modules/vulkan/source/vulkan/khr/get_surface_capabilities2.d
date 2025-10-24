/**
 * VK_KHR_get_surface_capabilities2 (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.get_surface_capabilities2;

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

public import vulkan.khr.surface;

struct VK_KHR_get_surface_capabilities2 {
    @VkProcName("vkGetPhysicalDeviceSurfaceCapabilities2KHR")
    PFN_vkGetPhysicalDeviceSurfaceCapabilities2KHR vkGetPhysicalDeviceSurfaceCapabilities2KHR;
    
    @VkProcName("vkGetPhysicalDeviceSurfaceFormats2KHR")
    PFN_vkGetPhysicalDeviceSurfaceFormats2KHR vkGetPhysicalDeviceSurfaceFormats2KHR;
}

enum VK_KHR_GET_SURFACE_CAPABILITIES_2_SPEC_VERSION = 1;
enum VK_KHR_GET_SURFACE_CAPABILITIES_2_EXTENSION_NAME = "VK_KHR_get_surface_capabilities2";

import vulkan.khr.surface : VkSurfaceKHR;
struct VkPhysicalDeviceSurfaceInfo2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR;
    const(void)* pNext;
    VkSurfaceKHR surface;
}

import vulkan.khr.surface : VkSurfaceCapabilitiesKHR;
struct VkSurfaceCapabilities2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR;
    void* pNext;
    VkSurfaceCapabilitiesKHR surfaceCapabilities;
}

import vulkan.khr.surface : VkSurfaceFormatKHR;
struct VkSurfaceFormat2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR;
    void* pNext;
    VkSurfaceFormatKHR surfaceFormat;
}

alias PFN_vkGetPhysicalDeviceSurfaceCapabilities2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceSurfaceInfo2KHR)* pSurfaceInfo,
    VkSurfaceCapabilities2KHR* pSurfaceCapabilities,
);

alias PFN_vkGetPhysicalDeviceSurfaceFormats2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceSurfaceInfo2KHR)* pSurfaceInfo,
    uint* pSurfaceFormatCount,
    VkSurfaceFormat2KHR* pSurfaceFormats,
);
