/**
 * VK_ARM_data_graph (Device)
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.data_graph;

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

public import vulkan.khr.deferred_host_operations;
version (VK_VERSION_1_3):
public import vulkan.khr.maintenance5;

struct VK_ARM_data_graph {
    
    @VkProcName("vkCreateDataGraphPipelinesARM")
    PFN_vkCreateDataGraphPipelinesARM vkCreateDataGraphPipelinesARM;
    
    @VkProcName("vkCreateDataGraphPipelineSessionARM")
    PFN_vkCreateDataGraphPipelineSessionARM vkCreateDataGraphPipelineSessionARM;
    
    @VkProcName("vkGetDataGraphPipelineSessionBindPointRequirementsARM")
    PFN_vkGetDataGraphPipelineSessionBindPointRequirementsARM vkGetDataGraphPipelineSessionBindPointRequirementsARM;
    
    @VkProcName("vkGetDataGraphPipelineSessionMemoryRequirementsARM")
    PFN_vkGetDataGraphPipelineSessionMemoryRequirementsARM vkGetDataGraphPipelineSessionMemoryRequirementsARM;
    
    @VkProcName("vkBindDataGraphPipelineSessionMemoryARM")
    PFN_vkBindDataGraphPipelineSessionMemoryARM vkBindDataGraphPipelineSessionMemoryARM;
    
    @VkProcName("vkDestroyDataGraphPipelineSessionARM")
    PFN_vkDestroyDataGraphPipelineSessionARM vkDestroyDataGraphPipelineSessionARM;
    
    @VkProcName("vkCmdDispatchDataGraphARM")
    PFN_vkCmdDispatchDataGraphARM vkCmdDispatchDataGraphARM;
    
    @VkProcName("vkGetDataGraphPipelineAvailablePropertiesARM")
    PFN_vkGetDataGraphPipelineAvailablePropertiesARM vkGetDataGraphPipelineAvailablePropertiesARM;
    
    @VkProcName("vkGetDataGraphPipelinePropertiesARM")
    PFN_vkGetDataGraphPipelinePropertiesARM vkGetDataGraphPipelinePropertiesARM;
    
    @VkProcName("vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM")
    PFN_vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM;
    
    @VkProcName("vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM")
    PFN_vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM;
    
}

enum VK_ARM_DATA_GRAPH_SPEC_VERSION = 1;
enum VK_ARM_DATA_GRAPH_EXTENSION_NAME = "VK_ARM_data_graph";
enum uint VK_MAX_PHYSICAL_DEVICE_DATA_GRAPH_OPERATION_SET_NAME_SIZE_ARM = 128;

struct VkPhysicalDeviceDataGraphFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DATA_GRAPH_FEATURES_ARM;
    void* pNext;
    VkBool32 dataGraph;
    VkBool32 dataGraphUpdateAfterBind;
    VkBool32 dataGraphSpecializationConstants;
    VkBool32 dataGraphDescriptorBuffer;
    VkBool32 dataGraphShaderModule;
}

alias VkDataGraphPipelineSessionARM = OpaqueHandle!("VkDataGraphPipelineSessionARM");

enum VkDataGraphPipelineSessionBindPointARM {
    VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TRANSIENT_ARM = 0,
}

enum VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TRANSIENT_ARM = VkDataGraphPipelineSessionBindPointARM.VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TRANSIENT_ARM;

enum VkDataGraphPipelineSessionBindPointTypeARM {
    VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TYPE_MEMORY_ARM = 0,
}

enum VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TYPE_MEMORY_ARM = VkDataGraphPipelineSessionBindPointTypeARM.VK_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_TYPE_MEMORY_ARM;

struct VkDataGraphPipelineConstantARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_CONSTANT_ARM;
    const(void)* pNext;
    uint id;
    const(void)* pConstantData;
}

struct VkDataGraphPipelineResourceInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_RESOURCE_INFO_ARM;
    const(void)* pNext;
    uint descriptorSet;
    uint binding;
    uint arrayElement;
}

struct VkDataGraphPipelineCompilerControlCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_COMPILER_CONTROL_CREATE_INFO_ARM;
    const(void)* pNext;
    const(char)* pVendorOptions;
}

struct VkDataGraphPipelineCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_CREATE_INFO_ARM;
    const(void)* pNext;
    VkFlags64 flags;
    VkPipelineLayout layout;
    uint resourceInfoCount;
    const(VkDataGraphPipelineResourceInfoARM)* pResourceInfos;
}

struct VkDataGraphPipelineShaderModuleCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_SHADER_MODULE_CREATE_INFO_ARM;
    const(void)* pNext;
    VkShaderModule module_;
    const(char)* pName;
    const(VkSpecializationInfo)* pSpecializationInfo;
    uint constantCount;
    const(VkDataGraphPipelineConstantARM)* pConstants;
}

struct VkDataGraphPipelineSessionCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_SESSION_CREATE_INFO_ARM;
    const(void)* pNext;
    VkFlags64 flags;
    VkPipeline dataGraphPipeline;
}

alias VkDataGraphPipelineSessionCreateFlagsARM = VkFlags64;

enum VkDataGraphPipelineSessionCreateFlagBitsARM : ulong {
    VK_DATA_GRAPH_PIPELINE_SESSION_CREATE_PROTECTED_BIT_ARM = 1,
}

enum VK_DATA_GRAPH_PIPELINE_SESSION_CREATE_PROTECTED_BIT_ARM = VkDataGraphPipelineSessionCreateFlagBitsARM.VK_DATA_GRAPH_PIPELINE_SESSION_CREATE_PROTECTED_BIT_ARM;

struct VkDataGraphPipelineSessionBindPointRequirementsInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_REQUIREMENTS_INFO_ARM;
    const(void)* pNext;
    VkDataGraphPipelineSessionARM session;
}

struct VkDataGraphPipelineSessionBindPointRequirementARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_SESSION_BIND_POINT_REQUIREMENT_ARM;
    const(void)* pNext;
    VkDataGraphPipelineSessionBindPointARM bindPoint;
    VkDataGraphPipelineSessionBindPointTypeARM bindPointType;
    uint numObjects;
}

struct VkDataGraphPipelineSessionMemoryRequirementsInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_SESSION_MEMORY_REQUIREMENTS_INFO_ARM;
    const(void)* pNext;
    VkDataGraphPipelineSessionARM session;
    VkDataGraphPipelineSessionBindPointARM bindPoint;
    uint objectIndex;
}

struct VkBindDataGraphPipelineSessionMemoryInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_DATA_GRAPH_PIPELINE_SESSION_MEMORY_INFO_ARM;
    const(void)* pNext;
    VkDataGraphPipelineSessionARM session;
    VkDataGraphPipelineSessionBindPointARM bindPoint;
    uint objectIndex;
    VkDeviceMemory memory;
    VkDeviceSize memoryOffset;
}

struct VkDataGraphPipelineInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_INFO_ARM;
    const(void)* pNext;
    VkPipeline dataGraphPipeline;
}

struct VkDataGraphPipelinePropertyQueryResultARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_PROPERTY_QUERY_RESULT_ARM;
    const(void)* pNext;
    VkDataGraphPipelinePropertyARM property;
    VkBool32 isText;
    size_t dataSize;
    void* pData;
}

enum VkDataGraphPipelinePropertyARM {
    VK_DATA_GRAPH_PIPELINE_PROPERTY_CREATION_LOG_ARM = 0,
    VK_DATA_GRAPH_PIPELINE_PROPERTY_IDENTIFIER_ARM = 1,
}

enum VK_DATA_GRAPH_PIPELINE_PROPERTY_CREATION_LOG_ARM = VkDataGraphPipelinePropertyARM.VK_DATA_GRAPH_PIPELINE_PROPERTY_CREATION_LOG_ARM;
enum VK_DATA_GRAPH_PIPELINE_PROPERTY_IDENTIFIER_ARM = VkDataGraphPipelinePropertyARM.VK_DATA_GRAPH_PIPELINE_PROPERTY_IDENTIFIER_ARM;

struct VkDataGraphPipelineIdentifierCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_IDENTIFIER_CREATE_INFO_ARM;
    const(void)* pNext;
    uint identifierSize;
    const(ubyte)* pIdentifier;
}

alias VkDataGraphPipelineDispatchFlagsARM = VkFlags64;

enum VkDataGraphPipelineDispatchFlagBitsARM : ulong;

struct VkDataGraphPipelineDispatchInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_DISPATCH_INFO_ARM;
    void* pNext;
    VkFlags64 flags;
}

enum VkPhysicalDeviceDataGraphProcessingEngineTypeARM {
    VK_PHYSICAL_DEVICE_DATA_GRAPH_PROCESSING_ENGINE_TYPE_DEFAULT_ARM = 0,
}

enum VK_PHYSICAL_DEVICE_DATA_GRAPH_PROCESSING_ENGINE_TYPE_DEFAULT_ARM = VkPhysicalDeviceDataGraphProcessingEngineTypeARM.VK_PHYSICAL_DEVICE_DATA_GRAPH_PROCESSING_ENGINE_TYPE_DEFAULT_ARM;

enum VkPhysicalDeviceDataGraphOperationTypeARM {
    VK_PHYSICAL_DEVICE_DATA_GRAPH_OPERATION_TYPE_SPIRV_EXTENDED_INSTRUCTION_SET_ARM = 0,
}

enum VK_PHYSICAL_DEVICE_DATA_GRAPH_OPERATION_TYPE_SPIRV_EXTENDED_INSTRUCTION_SET_ARM = VkPhysicalDeviceDataGraphOperationTypeARM.VK_PHYSICAL_DEVICE_DATA_GRAPH_OPERATION_TYPE_SPIRV_EXTENDED_INSTRUCTION_SET_ARM;

struct VkPhysicalDeviceDataGraphProcessingEngineARM {
    VkPhysicalDeviceDataGraphProcessingEngineTypeARM type;
    VkBool32 isForeign;
}

struct VkQueueFamilyDataGraphPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_DATA_GRAPH_PROPERTIES_ARM;
    const(void)* pNext;
    VkPhysicalDeviceDataGraphProcessingEngineARM engine;
    VkPhysicalDeviceDataGraphOperationSupportARM operation;
}

struct VkDataGraphProcessingEngineCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PROCESSING_ENGINE_CREATE_INFO_ARM;
    const(void)* pNext;
    uint processingEngineCount;
    VkPhysicalDeviceDataGraphProcessingEngineARM* pProcessingEngines;
}

struct VkPhysicalDeviceQueueFamilyDataGraphProcessingEngineInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_QUEUE_FAMILY_DATA_GRAPH_PROCESSING_ENGINE_INFO_ARM;
    const(void)* pNext;
    uint queueFamilyIndex;
    VkPhysicalDeviceDataGraphProcessingEngineTypeARM engineType;
}

struct VkQueueFamilyDataGraphProcessingEnginePropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_DATA_GRAPH_PROCESSING_ENGINE_PROPERTIES_ARM;
    const(void)* pNext;
    VkFlags foreignSemaphoreHandleTypes;
    VkFlags foreignMemoryHandleTypes;
}

struct VkPhysicalDeviceDataGraphOperationSupportARM {
    VkPhysicalDeviceDataGraphOperationTypeARM operationType;
    char[VK_MAX_PHYSICAL_DEVICE_DATA_GRAPH_OPERATION_SET_NAME_SIZE_ARM] name;
    uint version_;
}

alias PFN_vkCreateDataGraphPipelinesARM = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    VkPipelineCache pipelineCache,
    uint createInfoCount,
    const(VkDataGraphPipelineCreateInfoARM)* pCreateInfos,
    const(VkAllocationCallbacks)* pAllocator,
    VkPipeline* pPipelines,
);

alias PFN_vkCreateDataGraphPipelineSessionARM = VkResult function(
    VkDevice device,
    const(VkDataGraphPipelineSessionCreateInfoARM)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkDataGraphPipelineSessionARM* pSession,
);

alias PFN_vkGetDataGraphPipelineSessionBindPointRequirementsARM = VkResult function(
    VkDevice device,
    const(VkDataGraphPipelineSessionBindPointRequirementsInfoARM)* pInfo,
    uint* pBindPointRequirementCount,
    VkDataGraphPipelineSessionBindPointRequirementARM* pBindPointRequirements,
);

alias PFN_vkGetDataGraphPipelineSessionMemoryRequirementsARM = void function(
    VkDevice device,
    const(VkDataGraphPipelineSessionMemoryRequirementsInfoARM)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkBindDataGraphPipelineSessionMemoryARM = VkResult function(
    VkDevice device,
    uint bindInfoCount,
    const(VkBindDataGraphPipelineSessionMemoryInfoARM)* pBindInfos,
);

alias PFN_vkDestroyDataGraphPipelineSessionARM = void function(
    VkDevice device,
    VkDataGraphPipelineSessionARM session,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCmdDispatchDataGraphARM = void function(
    VkCommandBuffer commandBuffer,
    VkDataGraphPipelineSessionARM session,
    const(VkDataGraphPipelineDispatchInfoARM)* pInfo,
);

alias PFN_vkGetDataGraphPipelineAvailablePropertiesARM = VkResult function(
    VkDevice device,
    const(VkDataGraphPipelineInfoARM)* pPipelineInfo,
    uint* pPropertiesCount,
    VkDataGraphPipelinePropertyARM* pProperties,
);

alias PFN_vkGetDataGraphPipelinePropertiesARM = VkResult function(
    VkDevice device,
    const(VkDataGraphPipelineInfoARM)* pPipelineInfo,
    uint propertiesCount,
    VkDataGraphPipelinePropertyQueryResultARM* pProperties,
);

alias PFN_vkGetPhysicalDeviceQueueFamilyDataGraphPropertiesARM = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    uint* pQueueFamilyDataGraphPropertyCount,
    VkQueueFamilyDataGraphPropertiesARM* pQueueFamilyDataGraphProperties,
);

alias PFN_vkGetPhysicalDeviceQueueFamilyDataGraphProcessingEnginePropertiesARM = void function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceQueueFamilyDataGraphProcessingEngineInfoARM)* pQueueFamilyDataGraphProcessingEngineInfo,
    VkQueueFamilyDataGraphProcessingEnginePropertiesARM* pQueueFamilyDataGraphProcessingEngineProperties,
);

public import vulkan.arm.tensors;

struct VkDataGraphPipelineConstantTensorSemiStructuredSparsityInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DATA_GRAPH_PIPELINE_CONSTANT_TENSOR_SEMI_STRUCTURED_SPARSITY_INFO_ARM;
    const(void)* pNext;
    uint dimension;
    uint zeroCount;
    uint groupSize;
}
