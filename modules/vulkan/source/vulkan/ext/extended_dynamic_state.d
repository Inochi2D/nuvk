/**
 * VK_EXT_extended_dynamic_state (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.extended_dynamic_state;

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

struct VK_EXT_extended_dynamic_state {
    
    @VkProcName("vkCmdSetCullMode")
    PFN_vkCmdSetCullMode vkCmdSetCullMode;
    
    @VkProcName("vkCmdSetFrontFace")
    PFN_vkCmdSetFrontFace vkCmdSetFrontFace;
    
    @VkProcName("vkCmdSetPrimitiveTopology")
    PFN_vkCmdSetPrimitiveTopology vkCmdSetPrimitiveTopology;
    
    @VkProcName("vkCmdSetViewportWithCount")
    PFN_vkCmdSetViewportWithCount vkCmdSetViewportWithCount;
    
    @VkProcName("vkCmdSetScissorWithCount")
    PFN_vkCmdSetScissorWithCount vkCmdSetScissorWithCount;
    
    @VkProcName("vkCmdBindVertexBuffers2")
    PFN_vkCmdBindVertexBuffers2 vkCmdBindVertexBuffers2;
    
    @VkProcName("vkCmdSetDepthTestEnable")
    PFN_vkCmdSetDepthTestEnable vkCmdSetDepthTestEnable;
    
    @VkProcName("vkCmdSetDepthWriteEnable")
    PFN_vkCmdSetDepthWriteEnable vkCmdSetDepthWriteEnable;
    
    @VkProcName("vkCmdSetDepthCompareOp")
    PFN_vkCmdSetDepthCompareOp vkCmdSetDepthCompareOp;
    
    @VkProcName("vkCmdSetDepthBoundsTestEnable")
    PFN_vkCmdSetDepthBoundsTestEnable vkCmdSetDepthBoundsTestEnable;
    
    @VkProcName("vkCmdSetStencilTestEnable")
    PFN_vkCmdSetStencilTestEnable vkCmdSetStencilTestEnable;
    
    @VkProcName("vkCmdSetStencilOp")
    PFN_vkCmdSetStencilOp vkCmdSetStencilOp;
}

enum VK_EXT_EXTENDED_DYNAMIC_STATE_SPEC_VERSION = 1;
enum VK_EXT_EXTENDED_DYNAMIC_STATE_EXTENSION_NAME = "VK_EXT_extended_dynamic_state";

struct VkPhysicalDeviceExtendedDynamicStateFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_FEATURES_EXT;
    void* pNext;
    VkBool32 extendedDynamicState;
}

alias PFN_vkCmdSetCullMode = void function(
    VkCommandBuffer commandBuffer,
    VkCullModeFlags cullMode,
);

alias PFN_vkCmdSetFrontFace = void function(
    VkCommandBuffer commandBuffer,
    VkFrontFace frontFace,
);

alias PFN_vkCmdSetPrimitiveTopology = void function(
    VkCommandBuffer commandBuffer,
    VkPrimitiveTopology primitiveTopology,
);

alias PFN_vkCmdSetViewportWithCount = void function(
    VkCommandBuffer commandBuffer,
    uint viewportCount,
    const(VkViewport)* pViewports,
);

alias PFN_vkCmdSetScissorWithCount = void function(
    VkCommandBuffer commandBuffer,
    uint scissorCount,
    const(VkRect2D)* pScissors,
);

alias PFN_vkCmdBindVertexBuffers2 = void function(
    VkCommandBuffer commandBuffer,
    uint firstBinding,
    uint bindingCount,
    const(VkBuffer)* pBuffers,
    const(VkDeviceSize)* pOffsets,
    const(VkDeviceSize)* pSizes,
    const(VkDeviceSize)* pStrides,
);

alias PFN_vkCmdSetDepthTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthTestEnable,
);

alias PFN_vkCmdSetDepthWriteEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthWriteEnable,
);

alias PFN_vkCmdSetDepthCompareOp = void function(
    VkCommandBuffer commandBuffer,
    VkCompareOp depthCompareOp,
);

alias PFN_vkCmdSetDepthBoundsTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthBoundsTestEnable,
);

alias PFN_vkCmdSetStencilTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 stencilTestEnable,
);

alias PFN_vkCmdSetStencilOp = void function(
    VkCommandBuffer commandBuffer,
    VkStencilFaceFlags faceMask,
    VkStencilOp failOp,
    VkStencilOp passOp,
    VkStencilOp depthFailOp,
    VkCompareOp compareOp,
);
