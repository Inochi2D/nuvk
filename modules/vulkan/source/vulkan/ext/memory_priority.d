/**
 * VK_EXT_memory_priority
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.memory_priority;

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

enum VK_EXT_MEMORY_PRIORITY_SPEC_VERSION = 1;
enum VK_EXT_MEMORY_PRIORITY_EXTENSION_NAME = "VK_EXT_memory_priority";

struct VkPhysicalDeviceMemoryPriorityFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PRIORITY_FEATURES_EXT;
    void* pNext;
    VkBool32 memoryPriority;
}

struct VkMemoryPriorityAllocateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_PRIORITY_ALLOCATE_INFO_EXT;
    const(void)* pNext;
    float priority;
}
