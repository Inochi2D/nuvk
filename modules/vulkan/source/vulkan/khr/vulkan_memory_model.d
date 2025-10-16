/**
 * VK_KHR_vulkan_memory_model (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.vulkan_memory_model;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_KHR_VULKAN_MEMORY_MODEL_SPEC_VERSION = 3;
enum VK_KHR_VULKAN_MEMORY_MODEL_EXTENSION_NAME = "VK_KHR_vulkan_memory_model";

alias VkPhysicalDeviceVulkanMemoryModelFeaturesKHR = VkPhysicalDeviceVulkanMemoryModelFeatures;
