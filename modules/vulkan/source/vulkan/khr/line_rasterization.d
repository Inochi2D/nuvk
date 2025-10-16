/**
 * VK_KHR_line_rasterization (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.line_rasterization;

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

struct VK_KHR_line_rasterization {
    
    @VkProcName("vkCmdSetLineStipple")
    PFN_vkCmdSetLineStipple vkCmdSetLineStipple;
}

enum VK_KHR_LINE_RASTERIZATION_SPEC_VERSION = 1;
enum VK_KHR_LINE_RASTERIZATION_EXTENSION_NAME = "VK_KHR_line_rasterization";

alias VkPhysicalDeviceLineRasterizationFeaturesKHR = VkPhysicalDeviceLineRasterizationFeatures;

alias VkPhysicalDeviceLineRasterizationPropertiesKHR = VkPhysicalDeviceLineRasterizationProperties;

alias VkPipelineRasterizationLineStateCreateInfoKHR = VkPipelineRasterizationLineStateCreateInfo;

alias VkLineRasterizationModeKHR = VkLineRasterizationMode;

alias PFN_vkCmdSetLineStipple = void function(
    VkCommandBuffer commandBuffer,
    uint lineStippleFactor,
    ushort lineStipplePattern,
);
