/**
 * VK_NV_clip_space_w_scaling (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.clip_space_w_scaling;

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

struct VK_NV_clip_space_w_scaling {
    
    @VkProcName("vkCmdSetViewportWScalingNV")
    PFN_vkCmdSetViewportWScalingNV vkCmdSetViewportWScalingNV;
}

enum VK_NV_CLIP_SPACE_W_SCALING_SPEC_VERSION = 1;
enum VK_NV_CLIP_SPACE_W_SCALING_EXTENSION_NAME = "VK_NV_clip_space_w_scaling";

struct VkViewportWScalingNV {
    float xcoeff;
    float ycoeff;
}

struct VkPipelineViewportWScalingStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_W_SCALING_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkBool32 viewportWScalingEnable;
    uint viewportCount;
    const(VkViewportWScalingNV)* pViewportWScalings;
}

alias PFN_vkCmdSetViewportWScalingNV = void function(
    VkCommandBuffer commandBuffer,
    uint firstViewport,
    uint viewportCount,
    const(VkViewportWScalingNV)* pViewportWScalings,
);
