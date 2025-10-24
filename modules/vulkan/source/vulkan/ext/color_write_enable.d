/**
 * VK_EXT_color_write_enable (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.color_write_enable;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_EXT_color_write_enable {
    @VkProcName("vkCmdSetColorWriteEnableEXT")
    PFN_vkCmdSetColorWriteEnableEXT vkCmdSetColorWriteEnableEXT;
}

enum VK_EXT_COLOR_WRITE_ENABLE_SPEC_VERSION = 1;
enum VK_EXT_COLOR_WRITE_ENABLE_EXTENSION_NAME = "VK_EXT_color_write_enable";

struct VkPhysicalDeviceColorWriteEnableFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COLOR_WRITE_ENABLE_FEATURES_EXT;
    void* pNext;
    VkBool32 colorWriteEnable;
}

struct VkPipelineColorWriteCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_WRITE_CREATE_INFO_EXT;
    const(void)* pNext;
    uint attachmentCount;
    const(VkBool32)* pColorWriteEnables;
}

alias PFN_vkCmdSetColorWriteEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    uint attachmentCount,
    const(VkBool32)* pColorWriteEnables,
);
