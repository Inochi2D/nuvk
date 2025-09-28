/**
    VK_KHR_push_descriptor
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.push_descriptor;
import vulkan.core;

extern (System) @nogc nothrow:

// TODO: Implement core part
version(none):

enum uint VK_KHR_PUSH_DESCRIPTOR_SPEC_VERSION = 2;
enum string VK_KHR_PUSH_DESCRIPTOR_EXTENSION_NAME = "VK_KHR_push_descriptor";

alias VkPhysicalDevicePushDescriptorPropertiesKHR = VkPhysicalDevicePushDescriptorProperties;

alias PFN_vkCmdPushDescriptorSetKHR = void function(VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint set, uint descriptorWriteCount, const(VkWriteDescriptorSet)* pDescriptorWrites);
alias PFN_vkCmdPushDescriptorSetWithTemplateKHR = void function(VkCommandBuffer commandBuffer, VkDescriptorUpdateTemplate descriptorUpdateTemplate, VkPipelineLayout layout, uint set, const(void)* pData);
