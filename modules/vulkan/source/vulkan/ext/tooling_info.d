/**
 * VK_EXT_tooling_info
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.tooling_info;

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

struct VK_EXT_tooling_info {
    
    @VkProcName("vkGetPhysicalDeviceToolProperties")
    PFN_vkGetPhysicalDeviceToolProperties vkGetPhysicalDeviceToolProperties;
    
    
    
}

enum VK_EXT_TOOLING_INFO_SPEC_VERSION = 1;
enum VK_EXT_TOOLING_INFO_EXTENSION_NAME = "VK_EXT_tooling_info";

alias VkToolPurposeFlagBitsEXT = VkToolPurposeFlagBits;

alias VkToolPurposeFlagsEXT = VkToolPurposeFlags;

alias VkPhysicalDeviceToolPropertiesEXT = VkPhysicalDeviceToolProperties;

alias PFN_vkGetPhysicalDeviceToolProperties = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pToolCount,
    VkPhysicalDeviceToolProperties* pToolProperties,
);
