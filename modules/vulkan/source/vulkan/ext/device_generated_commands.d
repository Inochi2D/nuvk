/**
 * VK_EXT_device_generated_commands (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.device_generated_commands;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.maintenance5;
    version (VK_VERSION_1_2) {} else {
        public import vulkan.khr.buffer_device_address;
    }
}

struct VK_EXT_device_generated_commands {
    
    @VkProcName("vkGetGeneratedCommandsMemoryRequirementsEXT")
    PFN_vkGetGeneratedCommandsMemoryRequirementsEXT vkGetGeneratedCommandsMemoryRequirementsEXT;
    
    @VkProcName("vkCmdPreprocessGeneratedCommandsEXT")
    PFN_vkCmdPreprocessGeneratedCommandsEXT vkCmdPreprocessGeneratedCommandsEXT;
    
    @VkProcName("vkCmdExecuteGeneratedCommandsEXT")
    PFN_vkCmdExecuteGeneratedCommandsEXT vkCmdExecuteGeneratedCommandsEXT;
    
    @VkProcName("vkCreateIndirectCommandsLayoutEXT")
    PFN_vkCreateIndirectCommandsLayoutEXT vkCreateIndirectCommandsLayoutEXT;
    
    @VkProcName("vkDestroyIndirectCommandsLayoutEXT")
    PFN_vkDestroyIndirectCommandsLayoutEXT vkDestroyIndirectCommandsLayoutEXT;
    
    @VkProcName("vkCreateIndirectExecutionSetEXT")
    PFN_vkCreateIndirectExecutionSetEXT vkCreateIndirectExecutionSetEXT;
    
    @VkProcName("vkDestroyIndirectExecutionSetEXT")
    PFN_vkDestroyIndirectExecutionSetEXT vkDestroyIndirectExecutionSetEXT;
    
    @VkProcName("vkUpdateIndirectExecutionSetPipelineEXT")
    PFN_vkUpdateIndirectExecutionSetPipelineEXT vkUpdateIndirectExecutionSetPipelineEXT;
    
    @VkProcName("vkUpdateIndirectExecutionSetShaderEXT")
    PFN_vkUpdateIndirectExecutionSetShaderEXT vkUpdateIndirectExecutionSetShaderEXT;
    
}

enum VK_EXT_DEVICE_GENERATED_COMMANDS_SPEC_VERSION = 1;
enum VK_EXT_DEVICE_GENERATED_COMMANDS_EXTENSION_NAME = "VK_EXT_device_generated_commands";

struct VkPhysicalDeviceDeviceGeneratedCommandsFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_FEATURES_EXT;
    void* pNext;
    VkBool32 deviceGeneratedCommands;
    VkBool32 dynamicGeneratedPipelineLayout;
}

struct VkPhysicalDeviceDeviceGeneratedCommandsPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_PROPERTIES_EXT;
    void* pNext;
    uint maxIndirectPipelineCount;
    uint maxIndirectShaderObjectCount;
    uint maxIndirectSequenceCount;
    uint maxIndirectCommandsTokenCount;
    uint maxIndirectCommandsTokenOffset;
    uint maxIndirectCommandsIndirectStride;
    VkFlags supportedIndirectCommandsInputModes;
    VkFlags supportedIndirectCommandsShaderStages;
    VkFlags supportedIndirectCommandsShaderStagesPipelineBinding;
    VkFlags supportedIndirectCommandsShaderStagesShaderBinding;
    VkBool32 deviceGeneratedCommandsTransformFeedback;
    VkBool32 deviceGeneratedCommandsMultiDrawIndirectCount;
}

struct VkGeneratedCommandsMemoryRequirementsInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_MEMORY_REQUIREMENTS_INFO_EXT;
    const(void)* pNext;
    VkIndirectExecutionSetEXT indirectExecutionSet;
    VkIndirectCommandsLayoutEXT indirectCommandsLayout;
    uint maxSequenceCount;
    uint maxDrawCount;
}

struct VkIndirectExecutionSetCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_CREATE_INFO_EXT;
    const(void)* pNext;
    VkIndirectExecutionSetInfoTypeEXT type;
    VkIndirectExecutionSetInfoEXT info;
}

union VkIndirectExecutionSetInfoEXT {
    const(VkIndirectExecutionSetPipelineInfoEXT)* pPipelineInfo;
    const(VkIndirectExecutionSetShaderInfoEXT)* pShaderInfo;
}

struct VkIndirectExecutionSetPipelineInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_PIPELINE_INFO_EXT;
    const(void)* pNext;
    VkPipeline initialPipeline;
    uint maxPipelineCount;
}

struct VkIndirectExecutionSetShaderInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_SHADER_INFO_EXT;
    const(void)* pNext;
    uint shaderCount;
    const(VkShaderEXT)* pInitialShaders;
    const(VkIndirectExecutionSetShaderLayoutInfoEXT)* pSetLayoutInfos;
    uint maxShaderCount;
    uint pushConstantRangeCount;
    const(VkPushConstantRange)* pPushConstantRanges;
}

struct VkGeneratedCommandsInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_INFO_EXT;
    const(void)* pNext;
    VkFlags shaderStages;
    VkIndirectExecutionSetEXT indirectExecutionSet;
    VkIndirectCommandsLayoutEXT indirectCommandsLayout;
    VkDeviceAddress indirectAddress;
    VkDeviceSize indirectAddressSize;
    VkDeviceAddress preprocessAddress;
    VkDeviceSize preprocessSize;
    uint maxSequenceCount;
    VkDeviceAddress sequenceCountAddress;
    uint maxDrawCount;
}

struct VkWriteIndirectExecutionSetPipelineEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_INDIRECT_EXECUTION_SET_PIPELINE_EXT;
    const(void)* pNext;
    uint index;
    VkPipeline pipeline;
}

struct VkIndirectCommandsLayoutCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    VkFlags shaderStages;
    uint indirectStride;
    VkPipelineLayout pipelineLayout;
    uint tokenCount;
    const(VkIndirectCommandsLayoutTokenEXT)* pTokens;
}

struct VkIndirectCommandsLayoutTokenEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_TOKEN_EXT;
    const(void)* pNext;
    VkIndirectCommandsTokenTypeEXT type;
    VkIndirectCommandsTokenDataEXT data;
    uint offset;
}

struct VkDrawIndirectCountIndirectCommandEXT {
    VkDeviceAddress bufferAddress;
    uint stride;
    uint commandCount;
}

struct VkIndirectCommandsVertexBufferTokenEXT {
    uint vertexBindingUnit;
}

struct VkBindVertexBufferIndirectCommandEXT {
    VkDeviceAddress bufferAddress;
    uint size;
    uint stride;
}

struct VkIndirectCommandsIndexBufferTokenEXT {
    VkIndirectCommandsInputModeFlagBitsEXT mode;
}

struct VkBindIndexBufferIndirectCommandEXT {
    VkDeviceAddress bufferAddress;
    uint size;
    VkIndexType indexType;
}

struct VkIndirectCommandsPushConstantTokenEXT {
    VkPushConstantRange updateRange;
}

struct VkIndirectCommandsExecutionSetTokenEXT {
    VkIndirectExecutionSetInfoTypeEXT type;
    VkFlags shaderStages;
}

union VkIndirectCommandsTokenDataEXT {
    const(VkIndirectCommandsPushConstantTokenEXT)* pPushConstant;
    const(VkIndirectCommandsVertexBufferTokenEXT)* pVertexBuffer;
    const(VkIndirectCommandsIndexBufferTokenEXT)* pIndexBuffer;
    const(VkIndirectCommandsExecutionSetTokenEXT)* pExecutionSet;
}

alias VkIndirectCommandsLayoutEXT = OpaqueHandle!("VkIndirectCommandsLayoutEXT");
alias VkIndirectExecutionSetEXT = OpaqueHandle!("VkIndirectExecutionSetEXT");

enum VkIndirectCommandsTokenTypeEXT {
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_EXECUTION_SET_EXT = 0,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_EXT = 1,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_SEQUENCE_INDEX_EXT = 2,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_EXT = 3,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_EXT = 4,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_EXT = 5,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_EXT = 6,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_COUNT_EXT = 7,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_COUNT_EXT = 8,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_EXT = 9,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV_EXT = 1000202002,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_NV_EXT = 1000202003,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_EXT = 1000328000,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_EXT = 1000328001,
    VK_INDIRECT_COMMANDS_TOKEN_TYPE_TRACE_RAYS2_EXT = 1000386004,
}

enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_EXECUTION_SET_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_EXECUTION_SET_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_SEQUENCE_INDEX_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_SEQUENCE_INDEX_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_COUNT_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_COUNT_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_COUNT_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_COUNT_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_NV_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_NV_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_EXT;
enum VK_INDIRECT_COMMANDS_TOKEN_TYPE_TRACE_RAYS2_EXT = VkIndirectCommandsTokenTypeEXT.VK_INDIRECT_COMMANDS_TOKEN_TYPE_TRACE_RAYS2_EXT;

enum VkIndirectExecutionSetInfoTypeEXT {
    VK_INDIRECT_EXECUTION_SET_INFO_TYPE_PIPELINES_EXT = 0,
    VK_INDIRECT_EXECUTION_SET_INFO_TYPE_SHADER_OBJECTS_EXT = 1,
}

enum VK_INDIRECT_EXECUTION_SET_INFO_TYPE_PIPELINES_EXT = VkIndirectExecutionSetInfoTypeEXT.VK_INDIRECT_EXECUTION_SET_INFO_TYPE_PIPELINES_EXT;
enum VK_INDIRECT_EXECUTION_SET_INFO_TYPE_SHADER_OBJECTS_EXT = VkIndirectExecutionSetInfoTypeEXT.VK_INDIRECT_EXECUTION_SET_INFO_TYPE_SHADER_OBJECTS_EXT;

alias VkIndirectCommandsLayoutUsageFlagsEXT = VkFlags;

enum VkIndirectCommandsLayoutUsageFlagBitsEXT : uint {
    VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_EXT = 1,
    VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_EXT = 2,
}

enum VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_EXT = VkIndirectCommandsLayoutUsageFlagBitsEXT.VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_EXT;
enum VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_EXT = VkIndirectCommandsLayoutUsageFlagBitsEXT.VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_EXT;

alias VkIndirectCommandsInputModeFlagsEXT = VkFlags;

enum VkIndirectCommandsInputModeFlagBitsEXT : uint {
    VK_INDIRECT_COMMANDS_INPUT_MODE_VULKAN_INDEX_BUFFER_EXT = 1,
    VK_INDIRECT_COMMANDS_INPUT_MODE_DXGI_INDEX_BUFFER_EXT = 2,
}

enum VK_INDIRECT_COMMANDS_INPUT_MODE_VULKAN_INDEX_BUFFER_EXT = VkIndirectCommandsInputModeFlagBitsEXT.VK_INDIRECT_COMMANDS_INPUT_MODE_VULKAN_INDEX_BUFFER_EXT;
enum VK_INDIRECT_COMMANDS_INPUT_MODE_DXGI_INDEX_BUFFER_EXT = VkIndirectCommandsInputModeFlagBitsEXT.VK_INDIRECT_COMMANDS_INPUT_MODE_DXGI_INDEX_BUFFER_EXT;

struct VkIndirectExecutionSetShaderLayoutInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_SHADER_LAYOUT_INFO_EXT;
    const(void)* pNext;
    uint setLayoutCount;
    const(VkDescriptorSetLayout)* pSetLayouts;
}

struct VkGeneratedCommandsPipelineInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_PIPELINE_INFO_EXT;
    void* pNext;
    VkPipeline pipeline;
}

struct VkGeneratedCommandsShaderInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_GENERATED_COMMANDS_SHADER_INFO_EXT;
    void* pNext;
    uint shaderCount;
    const(VkShaderEXT)* pShaders;
}

alias PFN_vkGetGeneratedCommandsMemoryRequirementsEXT = void function(
    VkDevice device,
    const(VkGeneratedCommandsMemoryRequirementsInfoEXT)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkCmdPreprocessGeneratedCommandsEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkGeneratedCommandsInfoEXT)* pGeneratedCommandsInfo,
    VkCommandBuffer stateCommandBuffer,
);

alias PFN_vkCmdExecuteGeneratedCommandsEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 isPreprocessed,
    const(VkGeneratedCommandsInfoEXT)* pGeneratedCommandsInfo,
);

alias PFN_vkCreateIndirectCommandsLayoutEXT = VkResult function(
    VkDevice device,
    const(VkIndirectCommandsLayoutCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkIndirectCommandsLayoutEXT pIndirectCommandsLayout,
);

alias PFN_vkDestroyIndirectCommandsLayoutEXT = void function(
    VkDevice device,
    VkIndirectCommandsLayoutEXT indirectCommandsLayout,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCreateIndirectExecutionSetEXT = VkResult function(
    VkDevice device,
    const(VkIndirectExecutionSetCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkIndirectExecutionSetEXT pIndirectExecutionSet,
);

alias PFN_vkDestroyIndirectExecutionSetEXT = void function(
    VkDevice device,
    VkIndirectExecutionSetEXT indirectExecutionSet,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkUpdateIndirectExecutionSetPipelineEXT = void function(
    VkDevice device,
    VkIndirectExecutionSetEXT indirectExecutionSet,
    uint executionSetWriteCount,
    const(VkWriteIndirectExecutionSetPipelineEXT)* pExecutionSetWrites,
);

alias PFN_vkUpdateIndirectExecutionSetShaderEXT = void function(
    VkDevice device,
    VkIndirectExecutionSetEXT indirectExecutionSet,
    uint executionSetWriteCount,
    const(VkWriteIndirectExecutionSetShaderEXT)* pExecutionSetWrites,
);

public import vulkan.ext.shader_object;

struct VkWriteIndirectExecutionSetShaderEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_INDIRECT_EXECUTION_SET_SHADER_EXT;
    const(void)* pNext;
    uint index;
    VkShaderEXT shader;
}
