/**
    VK_KHR_dynamic_rendering
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_dynamic_rendering;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_DYNAMIC_RENDERING_SPEC_VERSION = 1;
enum string VK_KHR_DYNAMIC_RENDERING_EXTENSION_NAME = "VK_KHR_dynamic_rendering";

alias VkRenderingFlagsKHR = VkRenderingFlags;
alias VkRenderingFlagBitsKHR = VkRenderingFlags;
alias VkRenderingInfoKHR = VkRenderingInfo;
alias VkRenderingAttachmentInfoKHR = VkRenderingAttachmentInfo;
alias VkPipelineRenderingCreateInfoKHR = VkPipelineRenderingCreateInfo;
alias VkPhysicalDeviceDynamicRenderingFeaturesKHR = VkPhysicalDeviceDynamicRenderingFeatures;
alias VkCommandBufferInheritanceRenderingInfoKHR = VkCommandBufferInheritanceRenderingInfo;

alias PFN_vkCmdBeginRenderingKHR = void function(VkCommandBuffer commandBuffer, const(VkRenderingInfo)* pRenderingInfo);
alias PFN_vkCmdEndRenderingKHR = void function(VkCommandBuffer commandBuffer);
