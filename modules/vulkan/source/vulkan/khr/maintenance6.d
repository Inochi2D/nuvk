/**
 * VK_KHR_maintenance6 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance6;

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

version (VK_VERSION_1_1):

struct VK_KHR_maintenance6 {
    
    @VkProcName("vkCmdBindDescriptorSets2")
    PFN_vkCmdBindDescriptorSets2 vkCmdBindDescriptorSets2;
    
    @VkProcName("vkCmdPushConstants2")
    PFN_vkCmdPushConstants2 vkCmdPushConstants2;
    
    @VkProcName("vkCmdPushDescriptorSet2")
    PFN_vkCmdPushDescriptorSet2 vkCmdPushDescriptorSet2;
    
    @VkProcName("vkCmdPushDescriptorSetWithTemplate2")
    PFN_vkCmdPushDescriptorSetWithTemplate2 vkCmdPushDescriptorSetWithTemplate2;
    
    @VkProcName("vkCmdSetDescriptorBufferOffsets2EXT")
    PFN_vkCmdSetDescriptorBufferOffsets2EXT vkCmdSetDescriptorBufferOffsets2EXT;
    
    @VkProcName("vkCmdBindDescriptorBufferEmbeddedSamplers2EXT")
    PFN_vkCmdBindDescriptorBufferEmbeddedSamplers2EXT vkCmdBindDescriptorBufferEmbeddedSamplers2EXT;
    
}

enum VK_KHR_MAINTENANCE_6_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_6_EXTENSION_NAME = "VK_KHR_maintenance6";

alias VkPhysicalDeviceMaintenance6FeaturesKHR = VkPhysicalDeviceMaintenance6Features;

alias VkPhysicalDeviceMaintenance6PropertiesKHR = VkPhysicalDeviceMaintenance6Properties;

alias VkBindMemoryStatusKHR = VkBindMemoryStatus;

alias VkBindDescriptorSetsInfoKHR = VkBindDescriptorSetsInfo;

alias VkPushConstantsInfoKHR = VkPushConstantsInfo;

alias PFN_vkCmdBindDescriptorSets2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkBindDescriptorSetsInfo)* pBindDescriptorSetsInfo,
);

alias PFN_vkCmdPushConstants2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkPushConstantsInfo)* pPushConstantsInfo,
);

public import vulkan.khr.push_descriptor;

alias VkPushDescriptorSetInfoKHR = VkPushDescriptorSetInfo;

alias VkPushDescriptorSetWithTemplateInfoKHR = VkPushDescriptorSetWithTemplateInfo;

alias PFN_vkCmdPushDescriptorSet2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkPushDescriptorSetInfo)* pPushDescriptorSetInfo,
);

alias PFN_vkCmdPushDescriptorSetWithTemplate2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkPushDescriptorSetWithTemplateInfo)* pPushDescriptorSetWithTemplateInfo,
);

public import vulkan.ext.descriptor_buffer;

struct VkSetDescriptorBufferOffsetsInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SET_DESCRIPTOR_BUFFER_OFFSETS_INFO_EXT;
    const(void)* pNext;
    VkFlags stageFlags;
    VkPipelineLayout layout;
    uint firstSet;
    uint setCount;
    const(uint)* pBufferIndices;
    const(VkDeviceSize)* pOffsets;
}

struct VkBindDescriptorBufferEmbeddedSamplersInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_DESCRIPTOR_BUFFER_EMBEDDED_SAMPLERS_INFO_EXT;
    const(void)* pNext;
    VkFlags stageFlags;
    VkPipelineLayout layout;
    uint set;
}

alias PFN_vkCmdSetDescriptorBufferOffsets2EXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkSetDescriptorBufferOffsetsInfoEXT)* pSetDescriptorBufferOffsetsInfo,
);

alias PFN_vkCmdBindDescriptorBufferEmbeddedSamplers2EXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkBindDescriptorBufferEmbeddedSamplersInfoEXT)* pBindDescriptorBufferEmbeddedSamplersInfo,
);
