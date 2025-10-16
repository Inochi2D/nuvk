/**
 * VK_EXT_depth_clamp_control (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.depth_clamp_control;

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

struct VK_EXT_depth_clamp_control {
    
    @VkProcName("vkCmdSetDepthClampRangeEXT")
    PFN_vkCmdSetDepthClampRangeEXT vkCmdSetDepthClampRangeEXT;
}

enum VK_EXT_DEPTH_CLAMP_CONTROL_SPEC_VERSION = 1;
enum VK_EXT_DEPTH_CLAMP_CONTROL_EXTENSION_NAME = "VK_EXT_depth_clamp_control";

struct VkPhysicalDeviceDepthClampControlFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLAMP_CONTROL_FEATURES_EXT;
    void* pNext;
    VkBool32 depthClampControl;
}

struct VkPipelineViewportDepthClampControlCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_DEPTH_CLAMP_CONTROL_CREATE_INFO_EXT;
    const(void)* pNext;
    VkDepthClampModeEXT depthClampMode;
    const(VkDepthClampRangeEXT)* pDepthClampRange;
}

enum VkDepthClampModeEXT {
    VK_DEPTH_CLAMP_MODE_VIEWPORT_RANGE_EXT = 0,
    VK_DEPTH_CLAMP_MODE_USER_DEFINED_RANGE_EXT = 1,
}

enum VK_DEPTH_CLAMP_MODE_VIEWPORT_RANGE_EXT = VkDepthClampModeEXT.VK_DEPTH_CLAMP_MODE_VIEWPORT_RANGE_EXT;
enum VK_DEPTH_CLAMP_MODE_USER_DEFINED_RANGE_EXT = VkDepthClampModeEXT.VK_DEPTH_CLAMP_MODE_USER_DEFINED_RANGE_EXT;

struct VkDepthClampRangeEXT {
    float minDepthClamp;
    float maxDepthClamp;
}

alias PFN_vkCmdSetDepthClampRangeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkDepthClampModeEXT depthClampMode,
    const(VkDepthClampRangeEXT)* pDepthClampRange,
);
