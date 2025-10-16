/**
 * VK_NV_scissor_exclusive (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.scissor_exclusive;

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

struct VK_NV_scissor_exclusive {
    
    @VkProcName("vkCmdSetExclusiveScissorEnableNV")
    PFN_vkCmdSetExclusiveScissorEnableNV vkCmdSetExclusiveScissorEnableNV;
    
    @VkProcName("vkCmdSetExclusiveScissorNV")
    PFN_vkCmdSetExclusiveScissorNV vkCmdSetExclusiveScissorNV;
}

enum VK_NV_SCISSOR_EXCLUSIVE_SPEC_VERSION = 2;
enum VK_NV_SCISSOR_EXCLUSIVE_EXTENSION_NAME = "VK_NV_scissor_exclusive";

struct VkPipelineViewportExclusiveScissorStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_EXCLUSIVE_SCISSOR_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    uint exclusiveScissorCount;
    const(VkRect2D)* pExclusiveScissors;
}

struct VkPhysicalDeviceExclusiveScissorFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXCLUSIVE_SCISSOR_FEATURES_NV;
    void* pNext;
    VkBool32 exclusiveScissor;
}

alias PFN_vkCmdSetExclusiveScissorEnableNV = void function(
    VkCommandBuffer commandBuffer,
    uint firstExclusiveScissor,
    uint exclusiveScissorCount,
    const(VkBool32)* pExclusiveScissorEnables,
);

alias PFN_vkCmdSetExclusiveScissorNV = void function(
    VkCommandBuffer commandBuffer,
    uint firstExclusiveScissor,
    uint exclusiveScissorCount,
    const(VkRect2D)* pExclusiveScissors,
);
