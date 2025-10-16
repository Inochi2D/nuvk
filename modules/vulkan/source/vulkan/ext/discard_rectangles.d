/**
 * VK_EXT_discard_rectangles
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.discard_rectangles;

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

struct VK_EXT_discard_rectangles {
    
    @VkProcName("vkCmdSetDiscardRectangleEXT")
    PFN_vkCmdSetDiscardRectangleEXT vkCmdSetDiscardRectangleEXT;
    
    @VkProcName("vkCmdSetDiscardRectangleEnableEXT")
    PFN_vkCmdSetDiscardRectangleEnableEXT vkCmdSetDiscardRectangleEnableEXT;
    
    @VkProcName("vkCmdSetDiscardRectangleModeEXT")
    PFN_vkCmdSetDiscardRectangleModeEXT vkCmdSetDiscardRectangleModeEXT;
}

enum VK_EXT_DISCARD_RECTANGLES_SPEC_VERSION = 2;
enum VK_EXT_DISCARD_RECTANGLES_EXTENSION_NAME = "VK_EXT_discard_rectangles";

struct VkPhysicalDeviceDiscardRectanglePropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISCARD_RECTANGLE_PROPERTIES_EXT;
    void* pNext;
    uint maxDiscardRectangles;
}

struct VkPipelineDiscardRectangleStateCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_DISCARD_RECTANGLE_STATE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    VkDiscardRectangleModeEXT discardRectangleMode;
    uint discardRectangleCount;
    const(VkRect2D)* pDiscardRectangles;
}

alias VkPipelineDiscardRectangleStateCreateFlagsEXT = VkFlags;

enum VkDiscardRectangleModeEXT {
    VK_DISCARD_RECTANGLE_MODE_INCLUSIVE_EXT = 0,
    VK_DISCARD_RECTANGLE_MODE_EXCLUSIVE_EXT = 1,
}

enum VK_DISCARD_RECTANGLE_MODE_INCLUSIVE_EXT = VkDiscardRectangleModeEXT.VK_DISCARD_RECTANGLE_MODE_INCLUSIVE_EXT;
enum VK_DISCARD_RECTANGLE_MODE_EXCLUSIVE_EXT = VkDiscardRectangleModeEXT.VK_DISCARD_RECTANGLE_MODE_EXCLUSIVE_EXT;

alias PFN_vkCmdSetDiscardRectangleEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstDiscardRectangle,
    uint discardRectangleCount,
    const(VkRect2D)* pDiscardRectangles,
);

alias PFN_vkCmdSetDiscardRectangleEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 discardRectangleEnable,
);

alias PFN_vkCmdSetDiscardRectangleModeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkDiscardRectangleModeEXT discardRectangleMode,
);
