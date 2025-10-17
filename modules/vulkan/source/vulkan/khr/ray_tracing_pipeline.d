/**
 * VK_KHR_ray_tracing_pipeline (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.ray_tracing_pipeline;

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

public import vulkan.khr.acceleration_structure;
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.spirv_1_4;
}

struct VK_KHR_ray_tracing_pipeline {
    
    @VkProcName("vkCmdTraceRaysKHR")
    PFN_vkCmdTraceRaysKHR vkCmdTraceRaysKHR;
    
    @VkProcName("vkCreateRayTracingPipelinesKHR")
    PFN_vkCreateRayTracingPipelinesKHR vkCreateRayTracingPipelinesKHR;
    
    @VkProcName("vkGetRayTracingShaderGroupHandlesKHR")
    PFN_vkGetRayTracingShaderGroupHandlesKHR vkGetRayTracingShaderGroupHandlesKHR;
    
    @VkProcName("vkGetRayTracingCaptureReplayShaderGroupHandlesKHR")
    PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR vkGetRayTracingCaptureReplayShaderGroupHandlesKHR;
    
    @VkProcName("vkCmdTraceRaysIndirectKHR")
    PFN_vkCmdTraceRaysIndirectKHR vkCmdTraceRaysIndirectKHR;
    
    @VkProcName("vkGetRayTracingShaderGroupStackSizeKHR")
    PFN_vkGetRayTracingShaderGroupStackSizeKHR vkGetRayTracingShaderGroupStackSizeKHR;
    
    @VkProcName("vkCmdSetRayTracingPipelineStackSizeKHR")
    PFN_vkCmdSetRayTracingPipelineStackSizeKHR vkCmdSetRayTracingPipelineStackSizeKHR;
    
}

enum VK_KHR_RAY_TRACING_PIPELINE_SPEC_VERSION = 1;
enum VK_KHR_RAY_TRACING_PIPELINE_EXTENSION_NAME = "VK_KHR_ray_tracing_pipeline";
enum uint VK_SHADER_UNUSED_KHR = ~0U;

struct VkRayTracingShaderGroupCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_KHR;
    const(void)* pNext;
    VkRayTracingShaderGroupTypeKHR type;
    uint generalShader;
    uint closestHitShader;
    uint anyHitShader;
    uint intersectionShader;
    const(void)* pShaderGroupCaptureReplayHandle;
}

enum VkRayTracingShaderGroupTypeKHR {
    VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR = 0,
    VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR = 1,
    VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR = 2,
    VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR,
    VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR,
    VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR,
}

enum VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR = VkRayTracingShaderGroupTypeKHR.VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR;
enum VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR = VkRayTracingShaderGroupTypeKHR.VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR;
enum VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR = VkRayTracingShaderGroupTypeKHR.VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR;
enum VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR;
enum VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR;
enum VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_NV = VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR;

import vulkan.khr.pipeline_library : VkPipelineLibraryCreateInfoKHR;
struct VkRayTracingPipelineCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    uint stageCount;
    const(VkPipelineShaderStageCreateInfo)* pStages;
    uint groupCount;
    const(VkRayTracingShaderGroupCreateInfoKHR)* pGroups;
    uint maxPipelineRayRecursionDepth;
    const(VkPipelineLibraryCreateInfoKHR)* pLibraryInfo;
    const(VkRayTracingPipelineInterfaceCreateInfoKHR)* pLibraryInterface;
    const(VkPipelineDynamicStateCreateInfo)* pDynamicState;
    VkPipelineLayout layout;
    VkPipeline basePipelineHandle;
    int basePipelineIndex;
}

struct VkPhysicalDeviceRayTracingPipelineFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PIPELINE_FEATURES_KHR;
    void* pNext;
    VkBool32 rayTracingPipeline;
    VkBool32 rayTracingPipelineShaderGroupHandleCaptureReplay;
    VkBool32 rayTracingPipelineShaderGroupHandleCaptureReplayMixed;
    VkBool32 rayTracingPipelineTraceRaysIndirect;
    VkBool32 rayTraversalPrimitiveCulling;
}

struct VkPhysicalDeviceRayTracingPipelinePropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PIPELINE_PROPERTIES_KHR;
    void* pNext;
    uint shaderGroupHandleSize;
    uint maxRayRecursionDepth;
    uint maxShaderGroupStride;
    uint shaderGroupBaseAlignment;
    uint shaderGroupHandleCaptureReplaySize;
    uint maxRayDispatchInvocationCount;
    uint shaderGroupHandleAlignment;
    uint maxRayHitAttributeSize;
}

struct VkStridedDeviceAddressRegionKHR {
    VkDeviceAddress deviceAddress;
    VkDeviceSize stride;
    VkDeviceSize size;
}

struct VkTraceRaysIndirectCommandKHR {
    uint width;
    uint height;
    uint depth;
}

struct VkRayTracingPipelineInterfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_INTERFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    uint maxPipelineRayPayloadSize;
    uint maxPipelineRayHitAttributeSize;
}

enum VkShaderGroupShaderKHR {
    VK_SHADER_GROUP_SHADER_GENERAL_KHR = 0,
    VK_SHADER_GROUP_SHADER_CLOSEST_HIT_KHR = 1,
    VK_SHADER_GROUP_SHADER_ANY_HIT_KHR = 2,
    VK_SHADER_GROUP_SHADER_INTERSECTION_KHR = 3,
}

enum VK_SHADER_GROUP_SHADER_GENERAL_KHR = VkShaderGroupShaderKHR.VK_SHADER_GROUP_SHADER_GENERAL_KHR;
enum VK_SHADER_GROUP_SHADER_CLOSEST_HIT_KHR = VkShaderGroupShaderKHR.VK_SHADER_GROUP_SHADER_CLOSEST_HIT_KHR;
enum VK_SHADER_GROUP_SHADER_ANY_HIT_KHR = VkShaderGroupShaderKHR.VK_SHADER_GROUP_SHADER_ANY_HIT_KHR;
enum VK_SHADER_GROUP_SHADER_INTERSECTION_KHR = VkShaderGroupShaderKHR.VK_SHADER_GROUP_SHADER_INTERSECTION_KHR;

alias PFN_vkCmdTraceRaysKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkStridedDeviceAddressRegionKHR)* pRaygenShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pMissShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pHitShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pCallableShaderBindingTable,
    uint width,
    uint height,
    uint depth,
);

import vulkan.khr.deferred_host_operations : VkDeferredOperationKHR;
alias PFN_vkCreateRayTracingPipelinesKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    VkPipelineCache pipelineCache,
    uint createInfoCount,
    const(VkRayTracingPipelineCreateInfoKHR)* pCreateInfos,
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

alias PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR = VkResult function(
    VkDevice device,
    VkPipeline pipeline,
    uint firstGroup,
    uint groupCount,
    size_t dataSize,
    void* pData,
);

alias PFN_vkCmdTraceRaysIndirectKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkStridedDeviceAddressRegionKHR)* pRaygenShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pMissShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pHitShaderBindingTable,
    const(VkStridedDeviceAddressRegionKHR)* pCallableShaderBindingTable,
    VkDeviceAddress indirectDeviceAddress,
);

alias PFN_vkGetRayTracingShaderGroupStackSizeKHR = VkDeviceSize function(
    VkDevice device,
    VkPipeline pipeline,
    uint group,
    VkShaderGroupShaderKHR groupShader,
);

alias PFN_vkCmdSetRayTracingPipelineStackSizeKHR = void function(
    VkCommandBuffer commandBuffer,
    uint pipelineStackSize,
);
