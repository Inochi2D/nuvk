/**
 * VK_KHR_dynamic_rendering (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.dynamic_rendering;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.depth_stencil_resolve;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_KHR_dynamic_rendering {
    @VkProcName("vkCmdBeginRendering")
    PFN_vkCmdBeginRendering vkCmdBeginRendering;
    
    @VkProcName("vkCmdEndRendering")
    PFN_vkCmdEndRendering vkCmdEndRendering;
}

enum VK_KHR_DYNAMIC_RENDERING_SPEC_VERSION = 1;
enum VK_KHR_DYNAMIC_RENDERING_EXTENSION_NAME = "VK_KHR_dynamic_rendering";

alias VkRenderingInfoKHR = VkRenderingInfo;

alias VkRenderingAttachmentInfoKHR = VkRenderingAttachmentInfo;

alias VkPipelineRenderingCreateInfoKHR = VkPipelineRenderingCreateInfo;

alias VkPhysicalDeviceDynamicRenderingFeaturesKHR = VkPhysicalDeviceDynamicRenderingFeatures;

alias VkCommandBufferInheritanceRenderingInfoKHR = VkCommandBufferInheritanceRenderingInfo;

alias VkRenderingFlagsKHR = VkRenderingFlags;

alias VkRenderingFlagBitsKHR = VkRenderingFlags;

alias PFN_vkCmdBeginRendering = void function(
    VkCommandBuffer commandBuffer,
    const(VkRenderingInfo)* pRenderingInfo,
);

alias PFN_vkCmdEndRendering = void function(
    VkCommandBuffer commandBuffer,
);
