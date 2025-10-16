/**
 * VK_KHR_map_memory2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.map_memory2;

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

struct VK_KHR_map_memory2 {
    
    @VkProcName("vkMapMemory2")
    PFN_vkMapMemory2 vkMapMemory2;
    
    @VkProcName("vkUnmapMemory2")
    PFN_vkUnmapMemory2 vkUnmapMemory2;
}

enum VK_KHR_MAP_MEMORY_2_SPEC_VERSION = 1;
enum VK_KHR_MAP_MEMORY_2_EXTENSION_NAME = "VK_KHR_map_memory2";

alias VkMemoryMapInfoKHR = VkMemoryMapInfo;

alias VkMemoryUnmapInfoKHR = VkMemoryUnmapInfo;

alias VkMemoryUnmapFlagBitsKHR = VkMemoryUnmapFlagBits;

alias VkMemoryUnmapFlagsKHR = VkMemoryUnmapFlags;

alias PFN_vkMapMemory2 = VkResult function(
    VkDevice device,
    const(VkMemoryMapInfo)* pMemoryMapInfo,
    void** ppData,
);

alias PFN_vkUnmapMemory2 = VkResult function(
    VkDevice device,
    const(VkMemoryUnmapInfo)* pMemoryUnmapInfo,
);
