/**
 * VK_NV_device_generated_commands_compute (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.device_generated_commands_compute;

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

public import vulkan.nv.device_generated_commands;

struct VK_NV_device_generated_commands_compute {
    @VkProcName("vkGetPipelineIndirectMemoryRequirementsNV")
    PFN_vkGetPipelineIndirectMemoryRequirementsNV vkGetPipelineIndirectMemoryRequirementsNV;
    
    @VkProcName("vkCmdUpdatePipelineIndirectBufferNV")
    PFN_vkCmdUpdatePipelineIndirectBufferNV vkCmdUpdatePipelineIndirectBufferNV;
    
    @VkProcName("vkGetPipelineIndirectDeviceAddressNV")
    PFN_vkGetPipelineIndirectDeviceAddressNV vkGetPipelineIndirectDeviceAddressNV;
}

enum VK_NV_DEVICE_GENERATED_COMMANDS_COMPUTE_SPEC_VERSION = 2;
enum VK_NV_DEVICE_GENERATED_COMMANDS_COMPUTE_EXTENSION_NAME = "VK_NV_device_generated_commands_compute";

struct VkPhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_COMPUTE_FEATURES_NV;
    void* pNext;
    VkBool32 deviceGeneratedCompute;
    VkBool32 deviceGeneratedComputePipelines;
    VkBool32 deviceGeneratedComputeCaptureReplay;
}

struct VkComputePipelineIndirectBufferInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_INDIRECT_BUFFER_INFO_NV;
    const(void)* pNext;
    VkDeviceAddress deviceAddress;
    VkDeviceSize size;
    VkDeviceAddress pipelineDeviceAddressCaptureReplay;
}

struct VkPipelineIndirectDeviceAddressInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_INDIRECT_DEVICE_ADDRESS_INFO_NV;
    const(void)* pNext;
    VkPipelineBindPoint pipelineBindPoint;
    VkPipeline pipeline;
}

struct VkBindPipelineIndirectCommandNV {
    VkDeviceAddress pipelineAddress;
}

alias PFN_vkGetPipelineIndirectMemoryRequirementsNV = void function(
    VkDevice device,
    const(VkComputePipelineCreateInfo)* pCreateInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkCmdUpdatePipelineIndirectBufferNV = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineBindPoint pipelineBindPoint,
    VkPipeline pipeline,
);

alias PFN_vkGetPipelineIndirectDeviceAddressNV = VkDeviceAddress function(
    VkDevice device,
    const(VkPipelineIndirectDeviceAddressInfoNV)* pInfo,
);
