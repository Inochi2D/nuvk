/**
 * VK_EXT_memory_budget
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.memory_budget;

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

enum VK_EXT_MEMORY_BUDGET_SPEC_VERSION = 1;
enum VK_EXT_MEMORY_BUDGET_EXTENSION_NAME = "VK_EXT_memory_budget";

struct VkPhysicalDeviceMemoryBudgetPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_BUDGET_PROPERTIES_EXT;
    void* pNext;
    VkDeviceSize[VK_MAX_MEMORY_HEAPS] heapBudget;
    VkDeviceSize[VK_MAX_MEMORY_HEAPS] heapUsage;
}
