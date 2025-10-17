/**
 * VK_NV_ray_tracing (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.ray_tracing;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.ray_tracing_pipeline;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_memory_requirements2;
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_NV_ray_tracing {
    
    @VkProcName("vkCreateAccelerationStructureNV")
    PFN_vkCreateAccelerationStructureNV vkCreateAccelerationStructureNV;
    
    @VkProcName("vkDestroyAccelerationStructureNV")
    PFN_vkDestroyAccelerationStructureNV vkDestroyAccelerationStructureNV;
    
    @VkProcName("vkGetAccelerationStructureMemoryRequirementsNV")
    PFN_vkGetAccelerationStructureMemoryRequirementsNV vkGetAccelerationStructureMemoryRequirementsNV;
    
    @VkProcName("vkBindAccelerationStructureMemoryNV")
    PFN_vkBindAccelerationStructureMemoryNV vkBindAccelerationStructureMemoryNV;
    
    @VkProcName("vkCmdBuildAccelerationStructureNV")
    PFN_vkCmdBuildAccelerationStructureNV vkCmdBuildAccelerationStructureNV;
    
    @VkProcName("vkCmdCopyAccelerationStructureNV")
    PFN_vkCmdCopyAccelerationStructureNV vkCmdCopyAccelerationStructureNV;
    
    @VkProcName("vkCmdTraceRaysNV")
    PFN_vkCmdTraceRaysNV vkCmdTraceRaysNV;
    
    @VkProcName("vkCreateRayTracingPipelinesNV")
    PFN_vkCreateRayTracingPipelinesNV vkCreateRayTracingPipelinesNV;
    
    @VkProcName("vkGetRayTracingShaderGroupHandlesKHR")
    PFN_vkGetRayTracingShaderGroupHandlesKHR vkGetRayTracingShaderGroupHandlesKHR;
    
    @VkProcName("vkGetAccelerationStructureHandleNV")
    PFN_vkGetAccelerationStructureHandleNV vkGetAccelerationStructureHandleNV;
    
    @VkProcName("vkCmdWriteAccelerationStructuresPropertiesNV")
    PFN_vkCmdWriteAccelerationStructuresPropertiesNV vkCmdWriteAccelerationStructuresPropertiesNV;
    
    @VkProcName("vkCompileDeferredNV")
    PFN_vkCompileDeferredNV vkCompileDeferredNV;
    
}

enum VK_NV_RAY_TRACING_SPEC_VERSION = 3;
enum VK_NV_RAY_TRACING_EXTENSION_NAME = "VK_NV_ray_tracing";
enum VK_SHADER_UNUSED_NV = VK_SHADER_UNUSED_KHR;

import vulkan.khr.ray_tracing_pipeline : VkRayTracingShaderGroupTypeKHR;
struct VkRayTracingShaderGroupCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_NV;
    const(void)* pNext;
    VkRayTracingShaderGroupTypeKHR type;
    uint generalShader;
    uint closestHitShader;
    uint anyHitShader;
    uint intersectionShader;
}

import vulkan.khr.ray_tracing_pipeline : VkRayTracingShaderGroupTypeKHR;
alias VkRayTracingShaderGroupTypeNV = VkRayTracingShaderGroupTypeKHR;

struct VkRayTracingPipelineCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_NV;
    const(void)* pNext;
    VkFlags flags;
    uint stageCount;
    const(VkPipelineShaderStageCreateInfo)* pStages;
    uint groupCount;
    const(VkRayTracingShaderGroupCreateInfoNV)* pGroups;
    uint maxRecursionDepth;
    VkPipelineLayout layout;
    VkPipeline basePipelineHandle;
    int basePipelineIndex;
}

import vulkan.khr.acceleration_structure : VkGeometryTypeKHR;
alias VkGeometryTypeNV = VkGeometryTypeKHR;

import vulkan.khr.acceleration_structure : VkAccelerationStructureTypeKHR;
alias VkAccelerationStructureTypeNV = VkAccelerationStructureTypeKHR;

struct VkGeometryTrianglesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GEOMETRY_TRIANGLES_NV;
    const(void)* pNext;
    VkBuffer vertexData;
    VkDeviceSize vertexOffset;
    uint vertexCount;
    VkDeviceSize vertexStride;
    VkFormat vertexFormat;
    VkBuffer indexData;
    VkDeviceSize indexOffset;
    uint indexCount;
    VkIndexType indexType;
    VkBuffer transformData;
    VkDeviceSize transformOffset;
}

struct VkGeometryAABBNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GEOMETRY_AABB_NV;
    const(void)* pNext;
    VkBuffer aabbData;
    uint numAABBs;
    uint stride;
    VkDeviceSize offset;
}

struct VkGeometryDataNV {
    VkGeometryTrianglesNV triangles;
    VkGeometryAABBNV aabbs;
}

import vulkan.khr.acceleration_structure : VkGeometryTypeKHR, VkGeometryFlagsKHR;
struct VkGeometryNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GEOMETRY_NV;
    const(void)* pNext;
    VkGeometryTypeKHR geometryType;
    VkGeometryDataNV geometry;
    VkFlags flags;
}

alias VkGeometryFlagsNV = VkGeometryFlagsKHR;

import vulkan.khr.acceleration_structure : VkGeometryFlagBitsKHR;
alias VkGeometryFlagBitsNV = VkGeometryFlagBitsKHR;

alias VkGeometryInstanceFlagsNV = VkGeometryInstanceFlagsKHR;

import vulkan.khr.acceleration_structure : VkGeometryInstanceFlagBitsKHR;
alias VkGeometryInstanceFlagBitsNV = VkGeometryInstanceFlagBitsKHR;

struct VkAccelerationStructureInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_INFO_NV;
    const(void)* pNext;
    VkAccelerationStructureTypeNV type;
    VkFlags flags;
    uint instanceCount;
    uint geometryCount;
    const(VkGeometryNV)* pGeometries;
}

struct VkAccelerationStructureCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_NV;
    const(void)* pNext;
    VkDeviceSize compactedSize;
    VkAccelerationStructureInfoNV info;
}

alias VkAccelerationStructureNV = OpaqueHandle!("VkAccelerationStructureNV");

import vulkan.khr.acceleration_structure : VkBuildAccelerationStructureFlagBitsKHR;
alias VkBuildAccelerationStructureFlagBitsNV = VkBuildAccelerationStructureFlagBitsKHR;

alias VkBuildAccelerationStructureFlagsNV = VkBuildAccelerationStructureFlagsKHR;

import vulkan.khr.acceleration_structure : VkCopyAccelerationStructureModeKHR;
alias VkCopyAccelerationStructureModeNV = VkCopyAccelerationStructureModeKHR;

struct VkBindAccelerationStructureMemoryInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_ACCELERATION_STRUCTURE_MEMORY_INFO_NV;
    const(void)* pNext;
    VkAccelerationStructureNV accelerationStructure;
    VkDeviceMemory memory;
    VkDeviceSize memoryOffset;
    uint deviceIndexCount;
    const(uint)* pDeviceIndices;
}

struct VkWriteDescriptorSetAccelerationStructureNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_NV;
    const(void)* pNext;
    uint accelerationStructureCount;
    const(VkAccelerationStructureNV)* pAccelerationStructures;
}

struct VkAccelerationStructureMemoryRequirementsInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_NV;
    const(void)* pNext;
    VkAccelerationStructureMemoryRequirementsTypeNV type;
    VkAccelerationStructureNV accelerationStructure;
}

struct VkPhysicalDeviceRayTracingPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_NV;
    void* pNext;
    uint shaderGroupHandleSize;
    uint maxRecursionDepth;
    uint maxShaderGroupStride;
    uint shaderGroupBaseAlignment;
    ulong maxGeometryCount;
    ulong maxInstanceCount;
    ulong maxTriangleCount;
    uint maxDescriptorSetAccelerationStructures;
}

enum VkAccelerationStructureMemoryRequirementsTypeNV {
    VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_OBJECT_NV = 0,
    VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_BUILD_SCRATCH_NV = 1,
    VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_UPDATE_SCRATCH_NV = 2,
}

enum VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_OBJECT_NV = VkAccelerationStructureMemoryRequirementsTypeNV.VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_OBJECT_NV;
enum VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_BUILD_SCRATCH_NV = VkAccelerationStructureMemoryRequirementsTypeNV.VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_BUILD_SCRATCH_NV;
enum VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_UPDATE_SCRATCH_NV = VkAccelerationStructureMemoryRequirementsTypeNV.VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_UPDATE_SCRATCH_NV;

import vulkan.khr.acceleration_structure : VkTransformMatrixKHR;
alias VkTransformMatrixNV = VkTransformMatrixKHR;

import vulkan.khr.acceleration_structure : VkAabbPositionsKHR;
alias VkAabbPositionsNV = VkAabbPositionsKHR;

import vulkan.khr.acceleration_structure : VkAccelerationStructureInstanceKHR;
alias VkAccelerationStructureInstanceNV = VkAccelerationStructureInstanceKHR;

alias PFN_vkCreateAccelerationStructureNV = VkResult function(
    VkDevice device,
    const(VkAccelerationStructureCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkAccelerationStructureNV pAccelerationStructure,
);

alias PFN_vkDestroyAccelerationStructureNV = void function(
    VkDevice device,
    VkAccelerationStructureNV accelerationStructure,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetAccelerationStructureMemoryRequirementsNV = void function(
    VkDevice device,
    const(VkAccelerationStructureMemoryRequirementsInfoNV)* pInfo,
    VkMemoryRequirements2KHR* pMemoryRequirements,
);

alias PFN_vkBindAccelerationStructureMemoryNV = VkResult function(
    VkDevice device,
    uint bindInfoCount,
    const(VkBindAccelerationStructureMemoryInfoNV)* pBindInfos,
);

alias PFN_vkCmdBuildAccelerationStructureNV = void function(
    VkCommandBuffer commandBuffer,
    const(VkAccelerationStructureInfoNV)* pInfo,
    VkBuffer instanceData,
    VkDeviceSize instanceOffset,
    VkBool32 update,
    VkAccelerationStructureNV dst,
    VkAccelerationStructureNV src,
    VkBuffer scratch,
    VkDeviceSize scratchOffset,
);

import vulkan.khr.acceleration_structure : VkCopyAccelerationStructureModeKHR;
alias PFN_vkCmdCopyAccelerationStructureNV = void function(
    VkCommandBuffer commandBuffer,
    VkAccelerationStructureNV dst,
    VkAccelerationStructureNV src,
    VkCopyAccelerationStructureModeKHR mode,
);

alias PFN_vkCmdTraceRaysNV = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer raygenShaderBindingTableBuffer,
    VkDeviceSize raygenShaderBindingOffset,
    VkBuffer missShaderBindingTableBuffer,
    VkDeviceSize missShaderBindingOffset,
    VkDeviceSize missShaderBindingStride,
    VkBuffer hitShaderBindingTableBuffer,
    VkDeviceSize hitShaderBindingOffset,
    VkDeviceSize hitShaderBindingStride,
    VkBuffer callableShaderBindingTableBuffer,
    VkDeviceSize callableShaderBindingOffset,
    VkDeviceSize callableShaderBindingStride,
    uint width,
    uint height,
    uint depth,
);

alias PFN_vkCreateRayTracingPipelinesNV = VkResult function(
    VkDevice device,
    VkPipelineCache pipelineCache,
    uint createInfoCount,
    const(VkRayTracingPipelineCreateInfoNV)* pCreateInfos,
    const(VkAllocationCallbacks)* pAllocator,
    VkPipeline* pPipelines,
);

alias PFN_vkGetRayTracingShaderGroupHandlesKHR = VkResult function(
    VkDevice device,
    VkPipeline pipeline,
    uint firstGroup,
    uint groupCount,
    size_t dataSize,
    void* pData,
);

alias PFN_vkGetAccelerationStructureHandleNV = VkResult function(
    VkDevice device,
    VkAccelerationStructureNV accelerationStructure,
    size_t dataSize,
    void* pData,
);

alias PFN_vkCmdWriteAccelerationStructuresPropertiesNV = void function(
    VkCommandBuffer commandBuffer,
    uint accelerationStructureCount,
    const(VkAccelerationStructureNV)* pAccelerationStructures,
    VkQueryType queryType,
    VkQueryPool queryPool,
    uint firstQuery,
);

alias PFN_vkCompileDeferredNV = VkResult function(
    VkDevice device,
    VkPipeline pipeline,
    uint shader,
);

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_memory_requirements2;
}

alias VkMemoryRequirements2KHR = VkMemoryRequirements2;
