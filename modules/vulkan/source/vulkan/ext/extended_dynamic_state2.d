/**
 * VK_EXT_extended_dynamic_state2 (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.extended_dynamic_state2;

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

struct VK_EXT_extended_dynamic_state2 {
    
    @VkProcName("vkCmdSetPatchControlPointsEXT")
    PFN_vkCmdSetPatchControlPointsEXT vkCmdSetPatchControlPointsEXT;
    
    @VkProcName("vkCmdSetRasterizerDiscardEnable")
    PFN_vkCmdSetRasterizerDiscardEnable vkCmdSetRasterizerDiscardEnable;
    
    @VkProcName("vkCmdSetDepthBiasEnable")
    PFN_vkCmdSetDepthBiasEnable vkCmdSetDepthBiasEnable;
    
    @VkProcName("vkCmdSetLogicOpEXT")
    PFN_vkCmdSetLogicOpEXT vkCmdSetLogicOpEXT;
    
    @VkProcName("vkCmdSetPrimitiveRestartEnable")
    PFN_vkCmdSetPrimitiveRestartEnable vkCmdSetPrimitiveRestartEnable;
}

enum VK_EXT_EXTENDED_DYNAMIC_STATE_2_SPEC_VERSION = 1;
enum VK_EXT_EXTENDED_DYNAMIC_STATE_2_EXTENSION_NAME = "VK_EXT_extended_dynamic_state2";

struct VkPhysicalDeviceExtendedDynamicState2FeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_2_FEATURES_EXT;
    void* pNext;
    VkBool32 extendedDynamicState2;
    VkBool32 extendedDynamicState2LogicOp;
    VkBool32 extendedDynamicState2PatchControlPoints;
}

alias PFN_vkCmdSetPatchControlPointsEXT = void function(
    VkCommandBuffer commandBuffer,
    uint patchControlPoints,
);

alias PFN_vkCmdSetRasterizerDiscardEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 rasterizerDiscardEnable,
);

alias PFN_vkCmdSetDepthBiasEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthBiasEnable,
);

alias PFN_vkCmdSetLogicOpEXT = void function(
    VkCommandBuffer commandBuffer,
    VkLogicOp logicOp,
);

alias PFN_vkCmdSetPrimitiveRestartEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 primitiveRestartEnable,
);
