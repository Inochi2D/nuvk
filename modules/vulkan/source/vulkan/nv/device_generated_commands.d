/**
 * VK_NV_device_generated_commands (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.device_generated_commands;

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
    public import vulkan.khr.buffer_device_address;
}

struct VK_NV_device_generated_commands {
    
    @VkProcName("vkGetGeneratedCommandsMemoryRequirementsNV")
    PFN_vkGetGeneratedCommandsMemoryRequirementsNV vkGetGeneratedCommandsMemoryRequirementsNV;
    
    @VkProcName("vkCmdPreprocessGeneratedCommandsNV")
    PFN_vkCmdPreprocessGeneratedCommandsNV vkCmdPreprocessGeneratedCommandsNV;
    
    @VkProcName("vkCmdExecuteGeneratedCommandsNV")
    PFN_vkCmdExecuteGeneratedCommandsNV vkCmdExecuteGeneratedCommandsNV;
    
    @VkProcName("vkCmdBindPipelineShaderGroupNV")
    PFN_vkCmdBindPipelineShaderGroupNV vkCmdBindPipelineShaderGroupNV;
    
    @VkProcName("vkCreateIndirectCommandsLayoutNV")
    PFN_vkCreateIndirectCommandsLayoutNV vkCreateIndirectCommandsLayoutNV;
    
    @VkProcName("vkDestroyIndirectCommandsLayoutNV")
    PFN_vkDestroyIndirectCommandsLayoutNV vkDestroyIndirectCommandsLayoutNV;
}

enum VK_NV_DEVICE_GENERATED_COMMANDS_SPEC_VERSION = 3;
enum VK_NV_DEVICE_GENERATED_COMMANDS_EXTENSION_NAME = "VK_NV_device_generated_commands";

struct VkPhysicalDeviceDeviceGeneratedCommandsPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_PROPERTIES_NV;
    void* pNext;
    uint maxGraphicsShaderGroupCount;
    uint maxIndirectSequenceCount;
    uint maxIndirectCommandsTokenCount;
    uint maxIndirectCommandsStreamCount;
    uint maxIndirectCommandsTokenOffset;
    uint maxIndirectCommandsStreamStride;
    uint minSequencesCountBufferOffsetAlignment;
    uint minSequencesIndexBufferOffsetAlignment;
    uint minIndirectCommandsBufferOffsetAlignment;
}

struct VkPhysicalDeviceDeviceGeneratedCommandsFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_FEATURES_NV;
    void* pNext;
    VkBool32 deviceGeneratedCommands;
}

struct VkGraphicsShaderGroupCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GRAPHICS_SHADER_GROUP_CREATE_INFO_NV;
    const(void)* pNext;
    uint stageCount;
    const(VkPipelineShaderStageCreateInfo)* pStages;
    const(VkPipelineVertexInputStateCreateInfo)* pVertexInputState;
    const(VkPipelineTessellationStateCreateInfo)* pTessellationState;
}

struct VkGraphicsPipelineShaderGroupsCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_SHADER_GROUPS_CREATE_INFO_NV;
    const(void)* pNext;
    uint groupCount;
    const(VkGraphicsShaderGroupCreateInfoNV)* pGroups;
    uint pipelineCount;
    const(VkPipeline)* pPipelines;
}

struct VkBindShaderGroupIndirectCommandNV {
    uint groupIndex;
}

struct VkBindIndexBufferIndirectCommandNV {
    VkDeviceAddress bufferAddress;
    uint size;
    VkIndexType indexType;
}

struct VkBindVertexBufferIndirectCommandNV {
    VkDeviceAddress bufferAddress;
    uint size;
    uint stride;
}

struct VkSetStateFlagsIndirectCommandNV {
    uint data;
}

enum VkIndirectStateFlagBitsNV : uint {
    VK_INDIRECT_STATE_FLAG_FRONTFACE_BIT_NV = 1,
}

enum VK_INDIRECT_STATE_FLAG_FRONTFACE_BIT_NV = VkIndirectStateFlagBitsNV.VK_INDIRECT_STATE_FLAG_FRONTFACE_BIT_NV;

alias VkIndirectStateFlagsNV = VkBitFlagsBase!(VkFlags, VkIndirectStateFlagBitsNV);

alias VkIndirectCommandsLayoutNV = OpaqueHandle!("VkIndirectCommandsLayoutNV");

enum VkIndirectCommandsTokenTypeNV {
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_SHADER_GROUP_NV = 0,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_STATE_FLAGS_NV = 1,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_NV = 2,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_NV = 3,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_NV = 4,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_NV = 5,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_NV = 6,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_TASKS_NV = 7,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV = 1000328000,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_PIPELINE_NV = 1000428003,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_NV = 1000428004,
}

enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_SHADER_GROUP_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_SHADER_GROUP_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_STATE_FLAGS_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_STATE_FLAGS_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_TASKS_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_TASKS_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_PIPELINE_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_PIPELINE_NV;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_NV = VkIndirectCommandsTokenTypeNV.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_NV;

enum VkIndirectCommandsLayoutUsageFlagBitsNV : uint {
    VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_NV = 1,
    VK_INDIRECT_COMMANDS_LAYOUT_USAGE_INDEXED_SEQUENCES_BIT_NV = 2,
    VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_NV = 4,
}

enum VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_NV = VkIndirectCommandsLayoutUsageFlagBitsNV.VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_NV;
enum VK_INDIRECT_COMMANDS_LAYOUT_USAGE_INDEXED_SEQUENCES_BIT_NV = VkIndirectCommandsLayoutUsageFlagBitsNV.VK_INDIRECT_COMMANDS_LAYOUT_USAGE_INDEXED_SEQUENCES_BIT_NV;
enum VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_NV = VkIndirectCommandsLayoutUsageFlagBitsNV.VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_NV;

alias VkIndirectCommandsLayoutUsageFlagsNV = VkBitFlagsBase!(VkFlags, VkIndirectCommandsLayoutUsageFlagBitsNV);

struct VkIndirectCommandsStreamNV {
    VkBuffer buffer;
    VkDeviceSize offset;
}

struct VkIndirectCommandsLayoutTokenNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_TOKEN_NV;
    const(void)* pNext;
    VkIndirectCommandsTokenTypeNV tokenType;
    uint stream;
    uint offset;
    uint vertexBindingUnit;
    VkBool32 vertexDynamicStride;
    VkPipelineLayout pushconstantPipelineLayout;
    VkFlags pushconstantShaderStageFlags;
    uint pushconstantOffset;
    uint pushconstantSize;
    VkFlags indirectStateFlags;
    uint indexTypeCount;
    const(VkIndexType)* pIndexTypes;
    const(uint)* pIndexTypeValues;
}

struct VkIndirectCommandsLayoutCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_NV;
    const(void)* pNext;
    VkFlags flags;
    VkPipelineBindPoint pipelineBindPoint;
    uint tokenCount;
    const(VkIndirectCommandsLayoutTokenNV)* pTokens;
    uint streamCount;
    const(uint)* pStreamStrides;
}

struct VkGeneratedCommandsInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_INFO_NV;
    const(void)* pNext;
    VkPipelineBindPoint pipelineBindPoint;
    VkPipeline pipeline;
    VkIndirectCommandsLayoutNV indirectCommandsLayout;
    uint streamCount;
    const(VkIndirectCommandsStreamNV)* pStreams;
    uint sequencesCount;
    VkBuffer preprocessBuffer;
    VkDeviceSize preprocessOffset;
    VkDeviceSize preprocessSize;
    VkBuffer sequencesCountBuffer;
    VkDeviceSize sequencesCountOffset;
    VkBuffer sequencesIndexBuffer;
    VkDeviceSize sequencesIndexOffset;
}

struct VkGeneratedCommandsMemoryRequirementsInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_MEMORY_REQUIREMENTS_INFO_NV;
    const(void)* pNext;
    VkPipelineBindPoint pipelineBindPoint;
    VkPipeline pipeline;
    VkIndirectCommandsLayoutNV indirectCommandsLayout;
    uint maxSequencesCount;
}

alias PFN_vkGetGeneratedCommandsMemoryRequirementsNV = void function(
    VkDevice device,
    const(VkGeneratedCommandsMemoryRequirementsInfoNV)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkCmdPreprocessGeneratedCommandsNV = void function(
    VkCommandBuffer commandBuffer,
    const(VkGeneratedCommandsInfoNV)* pGeneratedCommandsInfo,
);

alias PFN_vkCmdExecuteGeneratedCommandsNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 isPreprocessed,
    const(VkGeneratedCommandsInfoNV)* pGeneratedCommandsInfo,
);

alias PFN_vkCmdBindPipelineShaderGroupNV = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineBindPoint pipelineBindPoint,
    VkPipeline pipeline,
    uint groupIndex,
);

alias PFN_vkCreateIndirectCommandsLayoutNV = VkResult function(
    VkDevice device,
    const(VkIndirectCommandsLayoutCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkIndirectCommandsLayoutNV pIndirectCommandsLayout,
);

alias PFN_vkDestroyIndirectCommandsLayoutNV = void function(
    VkDevice device,
    VkIndirectCommandsLayoutNV indirectCommandsLayout,
    const(VkAllocationCallbacks)* pAllocator,
);
