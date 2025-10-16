/**
 * VK_KHR_create_renderpass2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.create_renderpass2;

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
    public import vulkan.khr.maintenance2;
    public import vulkan.khr.multiview;
}

struct VK_KHR_create_renderpass2 {
    
    @VkProcName("vkCreateRenderPass2")
    PFN_vkCreateRenderPass2 vkCreateRenderPass2;
    
    @VkProcName("vkCmdBeginRenderPass2")
    PFN_vkCmdBeginRenderPass2 vkCmdBeginRenderPass2;
    
    @VkProcName("vkCmdNextSubpass2")
    PFN_vkCmdNextSubpass2 vkCmdNextSubpass2;
    
    @VkProcName("vkCmdEndRenderPass2")
    PFN_vkCmdEndRenderPass2 vkCmdEndRenderPass2;
}

enum VK_KHR_CREATE_RENDERPASS_2_SPEC_VERSION = 1;
enum VK_KHR_CREATE_RENDERPASS_2_EXTENSION_NAME = "VK_KHR_create_renderpass2";

alias VkRenderPassCreateInfo2KHR = VkRenderPassCreateInfo2;

alias VkAttachmentDescription2KHR = VkAttachmentDescription2;

alias VkAttachmentReference2KHR = VkAttachmentReference2;

alias VkSubpassDescription2KHR = VkSubpassDescription2;

alias VkSubpassDependency2KHR = VkSubpassDependency2;

alias VkSubpassBeginInfoKHR = VkSubpassBeginInfo;

alias VkSubpassEndInfoKHR = VkSubpassEndInfo;

alias PFN_vkCreateRenderPass2 = VkResult function(
    VkDevice device,
    const(VkRenderPassCreateInfo2)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkRenderPass* pRenderPass,
);

alias PFN_vkCmdBeginRenderPass2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkRenderPassBeginInfo)* pRenderPassBegin,
    const(VkSubpassBeginInfo)* pSubpassBeginInfo,
);

alias PFN_vkCmdNextSubpass2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkSubpassBeginInfo)* pSubpassBeginInfo,
    const(VkSubpassEndInfo)* pSubpassEndInfo,
);

alias PFN_vkCmdEndRenderPass2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkSubpassEndInfo)* pSubpassEndInfo,
);
