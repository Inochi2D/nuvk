/**
 * VK_EXT_conditional_rendering
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.conditional_rendering;

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

struct VK_EXT_conditional_rendering {
    
    @VkProcName("vkCmdBeginConditionalRenderingEXT")
    PFN_vkCmdBeginConditionalRenderingEXT vkCmdBeginConditionalRenderingEXT;
    
    @VkProcName("vkCmdEndConditionalRenderingEXT")
    PFN_vkCmdEndConditionalRenderingEXT vkCmdEndConditionalRenderingEXT;
}

enum VK_EXT_CONDITIONAL_RENDERING_SPEC_VERSION = 2;
enum VK_EXT_CONDITIONAL_RENDERING_EXTENSION_NAME = "VK_EXT_conditional_rendering";

alias VkConditionalRenderingFlagsEXT = VkFlags;

enum VkConditionalRenderingFlagBitsEXT : uint {
    VK_CONDITIONAL_RENDERING_INVERTED_BIT_EXT = 1,
}

enum VK_CONDITIONAL_RENDERING_INVERTED_BIT_EXT = VkConditionalRenderingFlagBitsEXT.VK_CONDITIONAL_RENDERING_INVERTED_BIT_EXT;

struct VkConditionalRenderingBeginInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_CONDITIONAL_RENDERING_BEGIN_INFO_EXT;
    const(void)* pNext;
    VkBuffer buffer;
    VkDeviceSize offset;
    VkFlags flags;
}

struct VkPhysicalDeviceConditionalRenderingFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONDITIONAL_RENDERING_FEATURES_EXT;
    void* pNext;
    VkBool32 conditionalRendering;
    VkBool32 inheritedConditionalRendering;
}

struct VkCommandBufferInheritanceConditionalRenderingInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_CONDITIONAL_RENDERING_INFO_EXT;
    const(void)* pNext;
    VkBool32 conditionalRenderingEnable;
}

alias PFN_vkCmdBeginConditionalRenderingEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkConditionalRenderingBeginInfoEXT)* pConditionalRenderingBegin,
);

alias PFN_vkCmdEndConditionalRenderingEXT = void function(
    VkCommandBuffer commandBuffer,
);
