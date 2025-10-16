/**
 * VK_QCOM_tile_memory_heap
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.tile_memory_heap;

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
    public import vulkan.khr.get_memory_requirements2;
}

struct VK_QCOM_tile_memory_heap {
    
    @VkProcName("vkCmdBindTileMemoryQCOM")
    PFN_vkCmdBindTileMemoryQCOM vkCmdBindTileMemoryQCOM;
    
}

enum VK_QCOM_TILE_MEMORY_HEAP_SPEC_VERSION = 1;
enum VK_QCOM_TILE_MEMORY_HEAP_EXTENSION_NAME = "VK_QCOM_tile_memory_heap";

struct VkPhysicalDeviceTileMemoryHeapFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_MEMORY_HEAP_FEATURES_QCOM;
    void* pNext;
    VkBool32 tileMemoryHeap;
}

struct VkPhysicalDeviceTileMemoryHeapPropertiesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_MEMORY_HEAP_PROPERTIES_QCOM;
    void* pNext;
    VkBool32 queueSubmitBoundary;
    VkBool32 tileBufferTransfers;
}

struct VkTileMemoryRequirementsQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TILE_MEMORY_REQUIREMENTS_QCOM;
    void* pNext;
    VkDeviceSize size;
    VkDeviceSize alignment;
}

struct VkTileMemoryBindInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TILE_MEMORY_BIND_INFO_QCOM;
    const(void)* pNext;
    VkDeviceMemory memory;
}

alias PFN_vkCmdBindTileMemoryQCOM = void function(
    VkCommandBuffer commandBuffer,
    const(VkTileMemoryBindInfoQCOM)* pTileMemoryBindInfo,
);

public import vulkan.qcom.tile_properties;

struct VkTileMemorySizeInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TILE_MEMORY_SIZE_INFO_QCOM;
    const(void)* pNext;
    VkDeviceSize size;
}
