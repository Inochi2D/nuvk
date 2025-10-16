/**
 * VK_KHR_get_display_properties2 (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.get_display_properties2;

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

struct VK_KHR_get_display_properties2 {
    
    @VkProcName("vkGetPhysicalDeviceDisplayProperties2KHR")
    PFN_vkGetPhysicalDeviceDisplayProperties2KHR vkGetPhysicalDeviceDisplayProperties2KHR;
    
    @VkProcName("vkGetPhysicalDeviceDisplayPlaneProperties2KHR")
    PFN_vkGetPhysicalDeviceDisplayPlaneProperties2KHR vkGetPhysicalDeviceDisplayPlaneProperties2KHR;
    
    @VkProcName("vkGetDisplayModeProperties2KHR")
    PFN_vkGetDisplayModeProperties2KHR vkGetDisplayModeProperties2KHR;
    
    @VkProcName("vkGetDisplayPlaneCapabilities2KHR")
    PFN_vkGetDisplayPlaneCapabilities2KHR vkGetDisplayPlaneCapabilities2KHR;
}

enum VK_KHR_GET_DISPLAY_PROPERTIES_2_SPEC_VERSION = 1;
enum VK_KHR_GET_DISPLAY_PROPERTIES_2_EXTENSION_NAME = "VK_KHR_get_display_properties2";

struct VkDisplayProperties2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PROPERTIES_2_KHR;
    void* pNext;
    VkDisplayPropertiesKHR displayProperties;
}

struct VkDisplayPlaneProperties2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PLANE_PROPERTIES_2_KHR;
    void* pNext;
    VkDisplayPlanePropertiesKHR displayPlaneProperties;
}

struct VkDisplayModeProperties2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_MODE_PROPERTIES_2_KHR;
    void* pNext;
    VkDisplayModePropertiesKHR displayModeProperties;
}

struct VkDisplayPlaneInfo2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PLANE_INFO_2_KHR;
    const(void)* pNext;
    VkDisplayModeKHR mode;
    uint planeIndex;
}

struct VkDisplayPlaneCapabilities2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_PLANE_CAPABILITIES_2_KHR;
    void* pNext;
    VkDisplayPlaneCapabilitiesKHR capabilities;
}

alias PFN_vkGetPhysicalDeviceDisplayProperties2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkDisplayProperties2KHR* pProperties,
);

alias PFN_vkGetPhysicalDeviceDisplayPlaneProperties2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkDisplayPlaneProperties2KHR* pProperties,
);

alias PFN_vkGetDisplayModeProperties2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayKHR display,
    uint* pPropertyCount,
    VkDisplayModeProperties2KHR* pProperties,
);

alias PFN_vkGetDisplayPlaneCapabilities2KHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkDisplayPlaneInfo2KHR)* pDisplayPlaneInfo,
    VkDisplayPlaneCapabilities2KHR* pCapabilities,
);
