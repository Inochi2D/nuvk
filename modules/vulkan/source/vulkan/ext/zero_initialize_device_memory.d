/**
 * VK_EXT_zero_initialize_device_memory (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.zero_initialize_device_memory;

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

enum VK_EXT_ZERO_INITIALIZE_DEVICE_MEMORY_SPEC_VERSION = 1;
enum VK_EXT_ZERO_INITIALIZE_DEVICE_MEMORY_EXTENSION_NAME = "VK_EXT_zero_initialize_device_memory";

struct VkPhysicalDeviceZeroInitializeDeviceMemoryFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ZERO_INITIALIZE_DEVICE_MEMORY_FEATURES_EXT;
    void* pNext;
    VkBool32 zeroInitializeDeviceMemory;
}
