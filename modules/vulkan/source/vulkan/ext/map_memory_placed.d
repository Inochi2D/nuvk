/**
 * VK_EXT_map_memory_placed
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.map_memory_placed;

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

version (VK_VERSION_1_4) {} else {
    public import vulkan.khr.map_memory2;
}

enum VK_EXT_MAP_MEMORY_PLACED_SPEC_VERSION = 1;
enum VK_EXT_MAP_MEMORY_PLACED_EXTENSION_NAME = "VK_EXT_map_memory_placed";

struct VkPhysicalDeviceMapMemoryPlacedFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAP_MEMORY_PLACED_FEATURES_EXT;
    void* pNext;
    VkBool32 memoryMapPlaced;
    VkBool32 memoryMapRangePlaced;
    VkBool32 memoryUnmapReserve;
}

struct VkPhysicalDeviceMapMemoryPlacedPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAP_MEMORY_PLACED_PROPERTIES_EXT;
    void* pNext;
    VkDeviceSize minPlacedMemoryMapAlignment;
}

struct VkMemoryMapPlacedInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_MAP_PLACED_INFO_EXT;
    const(void)* pNext;
    void* pPlacedAddress;
}
