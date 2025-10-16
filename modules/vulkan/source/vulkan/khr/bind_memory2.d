/**
 * VK_KHR_bind_memory2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.bind_memory2;

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

struct VK_KHR_bind_memory2 {
    
    @VkProcName("vkBindBufferMemory2")
    PFN_vkBindBufferMemory2 vkBindBufferMemory2;
    
    @VkProcName("vkBindImageMemory2")
    PFN_vkBindImageMemory2 vkBindImageMemory2;
}

enum VK_KHR_BIND_MEMORY_2_SPEC_VERSION = 1;
enum VK_KHR_BIND_MEMORY_2_EXTENSION_NAME = "VK_KHR_bind_memory2";

alias VkBindBufferMemoryInfoKHR = VkBindBufferMemoryInfo;

alias VkBindImageMemoryInfoKHR = VkBindImageMemoryInfo;

alias PFN_vkBindBufferMemory2 = VkResult function(
    VkDevice device,
    uint bindInfoCount,
    const(VkBindBufferMemoryInfo)* pBindInfos,
);

alias PFN_vkBindImageMemory2 = VkResult function(
    VkDevice device,
    uint bindInfoCount,
    const(VkBindImageMemoryInfo)* pBindInfos,
);
