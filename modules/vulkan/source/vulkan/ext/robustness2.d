/**
 * VK_EXT_robustness2
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.robustness2;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.robustness2;

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

enum VK_EXT_ROBUSTNESS_2_SPEC_VERSION = 1;
enum VK_EXT_ROBUSTNESS_2_EXTENSION_NAME = "VK_EXT_robustness2";

alias VkPhysicalDeviceRobustness2FeaturesEXT = VkPhysicalDeviceRobustness2FeaturesKHR;

alias VkPhysicalDeviceRobustness2PropertiesEXT = VkPhysicalDeviceRobustness2PropertiesKHR;
