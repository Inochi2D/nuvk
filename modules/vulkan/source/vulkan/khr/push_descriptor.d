/**
 * VK_KHR_push_descriptor (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.push_descriptor;

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

struct VK_KHR_push_descriptor {
    
    @VkProcName("vkCmdPushDescriptorSet")
    PFN_vkCmdPushDescriptorSet vkCmdPushDescriptorSet;
    @VkProcName("vkCmdPushDescriptorSetWithTemplate")
    PFN_vkCmdPushDescriptorSetWithTemplate vkCmdPushDescriptorSetWithTemplate;
}

enum VK_KHR_PUSH_DESCRIPTOR_SPEC_VERSION = 2;
enum VK_KHR_PUSH_DESCRIPTOR_EXTENSION_NAME = "VK_KHR_push_descriptor";

alias VkPhysicalDevicePushDescriptorPropertiesKHR = VkPhysicalDevicePushDescriptorProperties;

alias PFN_vkCmdPushDescriptorSet = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineBindPoint pipelineBindPoint,
    VkPipelineLayout layout,
    uint set,
    uint descriptorWriteCount,
    const(VkWriteDescriptorSet)* pDescriptorWrites,
);

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.descriptor_update_template;
}

alias PFN_vkCmdPushDescriptorSetWithTemplate = void function(
    VkCommandBuffer commandBuffer,
    VkDescriptorUpdateTemplate descriptorUpdateTemplate,
    VkPipelineLayout layout,
    uint set,
    const(void)* pData,
);
