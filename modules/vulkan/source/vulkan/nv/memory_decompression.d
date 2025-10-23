/**
 * VK_NV_memory_decompression (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.memory_decompression;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.buffer_device_address;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_NV_memory_decompression {
    @VkProcName("vkCmdDecompressMemoryNV")
    PFN_vkCmdDecompressMemoryNV vkCmdDecompressMemoryNV;
    
    @VkProcName("vkCmdDecompressMemoryIndirectCountNV")
    PFN_vkCmdDecompressMemoryIndirectCountNV vkCmdDecompressMemoryIndirectCountNV;
}

enum VK_NV_MEMORY_DECOMPRESSION_SPEC_VERSION = 1;
enum VK_NV_MEMORY_DECOMPRESSION_EXTENSION_NAME = "VK_NV_memory_decompression";

alias VkMemoryDecompressionMethodFlagsNV = ulong;
enum VkMemoryDecompressionMethodFlagsNV
    VK_MEMORY_DECOMPRESSION_METHOD_GDEFLATE_1_0_BIT_NV = 1;


struct VkDecompressMemoryRegionNV {
    VkDeviceAddress srcAddress;
    VkDeviceAddress dstAddress;
    VkDeviceSize compressedSize;
    VkDeviceSize decompressedSize;
    VkMemoryDecompressionMethodFlagsNV decompressionMethod;
}

struct VkPhysicalDeviceMemoryDecompressionFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_DECOMPRESSION_FEATURES_NV;
    void* pNext;
    VkBool32 memoryDecompression;
}

struct VkPhysicalDeviceMemoryDecompressionPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_DECOMPRESSION_PROPERTIES_NV;
    void* pNext;
    VkMemoryDecompressionMethodFlagsNV decompressionMethods;
    ulong maxDecompressionIndirectCount;
}

alias PFN_vkCmdDecompressMemoryNV = void function(
    VkCommandBuffer commandBuffer,
    uint decompressRegionCount,
    const(VkDecompressMemoryRegionNV)* pDecompressMemoryRegions,
);

alias PFN_vkCmdDecompressMemoryIndirectCountNV = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress indirectCommandsAddress,
    VkDeviceAddress indirectCommandsCountAddress,
    uint stride,
);
