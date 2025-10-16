/**
 * VK_KHR_device_group_creation (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.device_group_creation;

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

struct VK_KHR_device_group_creation {
    
    @VkProcName("vkEnumeratePhysicalDeviceGroups")
    PFN_vkEnumeratePhysicalDeviceGroups vkEnumeratePhysicalDeviceGroups;
}

enum VK_KHR_DEVICE_GROUP_CREATION_SPEC_VERSION = 1;
enum VK_KHR_DEVICE_GROUP_CREATION_EXTENSION_NAME = "VK_KHR_device_group_creation";
enum VK_MAX_DEVICE_GROUP_SIZE_KHR = VK_MAX_DEVICE_GROUP_SIZE;

alias VkPhysicalDeviceGroupPropertiesKHR = VkPhysicalDeviceGroupProperties;

alias VkDeviceGroupDeviceCreateInfoKHR = VkDeviceGroupDeviceCreateInfo;

alias PFN_vkEnumeratePhysicalDeviceGroups = VkResult function(
    VkInstance instance,
    uint* pPhysicalDeviceGroupCount,
    VkPhysicalDeviceGroupProperties* pPhysicalDeviceGroupProperties,
);
