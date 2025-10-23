/**
 * VK_KHR_descriptor_update_template (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.descriptor_update_template;

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

struct VK_KHR_descriptor_update_template {
    @VkProcName("vkCreateDescriptorUpdateTemplate")
    PFN_vkCreateDescriptorUpdateTemplate vkCreateDescriptorUpdateTemplate;
    
    @VkProcName("vkDestroyDescriptorUpdateTemplate")
    PFN_vkDestroyDescriptorUpdateTemplate vkDestroyDescriptorUpdateTemplate;
    
    @VkProcName("vkUpdateDescriptorSetWithTemplate")
    PFN_vkUpdateDescriptorSetWithTemplate vkUpdateDescriptorSetWithTemplate;
    
    @VkProcName("vkCmdPushDescriptorSetWithTemplate")
    PFN_vkCmdPushDescriptorSetWithTemplate vkCmdPushDescriptorSetWithTemplate;
    
}

enum VK_KHR_DESCRIPTOR_UPDATE_TEMPLATE_SPEC_VERSION = 1;
enum VK_KHR_DESCRIPTOR_UPDATE_TEMPLATE_EXTENSION_NAME = "VK_KHR_descriptor_update_template";

alias VkDescriptorUpdateTemplateKHR = VkDescriptorUpdateTemplate;

alias VkDescriptorUpdateTemplateCreateFlagsKHR = VkDescriptorUpdateTemplateCreateFlags;

alias VkDescriptorUpdateTemplateTypeKHR = VkDescriptorUpdateTemplateType;

alias VkDescriptorUpdateTemplateEntryKHR = VkDescriptorUpdateTemplateEntry;

alias VkDescriptorUpdateTemplateCreateInfoKHR = VkDescriptorUpdateTemplateCreateInfo;

alias PFN_vkCreateDescriptorUpdateTemplate = VkResult function(
    VkDevice device,
    const(VkDescriptorUpdateTemplateCreateInfo)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkDescriptorUpdateTemplate pDescriptorUpdateTemplate,
);

alias PFN_vkDestroyDescriptorUpdateTemplate = void function(
    VkDevice device,
    VkDescriptorUpdateTemplate descriptorUpdateTemplate,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkUpdateDescriptorSetWithTemplate = void function(
    VkDevice device,
    VkDescriptorSet descriptorSet,
    VkDescriptorUpdateTemplate descriptorUpdateTemplate,
    const(void)* pData,
);

public import vulkan.khr.push_descriptor;

alias PFN_vkCmdPushDescriptorSetWithTemplate = void function(
    VkCommandBuffer commandBuffer,
    VkDescriptorUpdateTemplate descriptorUpdateTemplate,
    VkPipelineLayout layout,
    uint set,
    const(void)* pData,
);
