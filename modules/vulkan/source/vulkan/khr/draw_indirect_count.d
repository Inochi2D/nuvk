/**
 * VK_KHR_draw_indirect_count
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.draw_indirect_count;

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

struct VK_KHR_draw_indirect_count {
    
    @VkProcName("vkCmdDrawIndirectCount")
    PFN_vkCmdDrawIndirectCount vkCmdDrawIndirectCount;
    
    @VkProcName("vkCmdDrawIndexedIndirectCount")
    PFN_vkCmdDrawIndexedIndirectCount vkCmdDrawIndexedIndirectCount;
}

enum VK_KHR_DRAW_INDIRECT_COUNT_SPEC_VERSION = 1;
enum VK_KHR_DRAW_INDIRECT_COUNT_EXTENSION_NAME = "VK_KHR_draw_indirect_count";

alias PFN_vkCmdDrawIndirectCount = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    VkBuffer countBuffer,
    VkDeviceSize countBufferOffset,
    uint maxDrawCount,
    uint stride,
);

alias PFN_vkCmdDrawIndexedIndirectCount = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    VkBuffer countBuffer,
    VkDeviceSize countBufferOffset,
    uint maxDrawCount,
    uint stride,
);
