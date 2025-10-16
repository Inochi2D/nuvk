/**
 * VK_AMDX_shader_enqueue (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amdx.shader_enqueue;

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

public import vulkan.khr.pipeline_library;
public import vulkan.khr.maintenance5;
version (VK_VERSION_1_3) {} else {
    public import vulkan.ext.extended_dynamic_state;
    public import vulkan.khr.spirv_1_4;
    public import vulkan.khr.synchronization2;
}

struct VK_AMDX_shader_enqueue {
    
    @VkProcName("vkCreateExecutionGraphPipelinesAMDX")
    PFN_vkCreateExecutionGraphPipelinesAMDX vkCreateExecutionGraphPipelinesAMDX;
    
    @VkProcName("vkGetExecutionGraphPipelineScratchSizeAMDX")
    PFN_vkGetExecutionGraphPipelineScratchSizeAMDX vkGetExecutionGraphPipelineScratchSizeAMDX;
    
    @VkProcName("vkGetExecutionGraphPipelineNodeIndexAMDX")
    PFN_vkGetExecutionGraphPipelineNodeIndexAMDX vkGetExecutionGraphPipelineNodeIndexAMDX;
    
    @VkProcName("vkCmdInitializeGraphScratchMemoryAMDX")
    PFN_vkCmdInitializeGraphScratchMemoryAMDX vkCmdInitializeGraphScratchMemoryAMDX;
    
    @VkProcName("vkCmdDispatchGraphAMDX")
    PFN_vkCmdDispatchGraphAMDX vkCmdDispatchGraphAMDX;
    
    @VkProcName("vkCmdDispatchGraphIndirectAMDX")
    PFN_vkCmdDispatchGraphIndirectAMDX vkCmdDispatchGraphIndirectAMDX;
    
    @VkProcName("vkCmdDispatchGraphIndirectCountAMDX")
    PFN_vkCmdDispatchGraphIndirectCountAMDX vkCmdDispatchGraphIndirectCountAMDX;
    
}

enum VK_AMDX_SHADER_ENQUEUE_SPEC_VERSION = 2;
enum VK_AMDX_SHADER_ENQUEUE_EXTENSION_NAME = "VK_AMDX_shader_enqueue";
enum uint VK_SHADER_INDEX_UNUSED_AMDX = ~0U;

struct VkPhysicalDeviceShaderEnqueueFeaturesAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ENQUEUE_FEATURES_AMDX;
    void* pNext;
    VkBool32 shaderEnqueue;
    VkBool32 shaderMeshEnqueue;
}

struct VkPhysicalDeviceShaderEnqueuePropertiesAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ENQUEUE_PROPERTIES_AMDX;
    void* pNext;
    uint maxExecutionGraphDepth;
    uint maxExecutionGraphShaderOutputNodes;
    uint maxExecutionGraphShaderPayloadSize;
    uint maxExecutionGraphShaderPayloadCount;
    uint executionGraphDispatchAddressAlignment;
    uint maxExecutionGraphWorkgroupCount;
    uint maxExecutionGraphWorkgroups;
}

struct VkExecutionGraphPipelineScratchSizeAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXECUTION_GRAPH_PIPELINE_SCRATCH_SIZE_AMDX;
    void* pNext;
    VkDeviceSize minSize;
    VkDeviceSize maxSize;
    VkDeviceSize sizeGranularity;
}

struct VkExecutionGraphPipelineCreateInfoAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXECUTION_GRAPH_PIPELINE_CREATE_INFO_AMDX;
    const(void)* pNext;
    VkFlags flags;
    uint stageCount;
    const(VkPipelineShaderStageCreateInfo)* pStages;
    const(VkPipelineLibraryCreateInfoKHR)* pLibraryInfo;
    VkPipelineLayout layout;
    VkPipeline basePipelineHandle;
    int basePipelineIndex;
}

struct VkDispatchGraphInfoAMDX {
    uint nodeIndex;
    uint payloadCount;
    VkDeviceOrHostAddressConstAMDX payloads;
    ulong payloadStride;
}

struct VkDispatchGraphCountInfoAMDX {
    uint count;
    VkDeviceOrHostAddressConstAMDX infos;
    ulong stride;
}

struct VkPipelineShaderStageNodeCreateInfoAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_NODE_CREATE_INFO_AMDX;
    const(void)* pNext;
    const(char)* pName;
    uint index;
}

union VkDeviceOrHostAddressConstAMDX {
    VkDeviceAddress deviceAddress;
    const(void)* hostAddress;
}

alias PFN_vkCreateExecutionGraphPipelinesAMDX = VkResult function(
    VkDevice device,
    VkPipelineCache pipelineCache,
    uint createInfoCount,
    const(VkExecutionGraphPipelineCreateInfoAMDX)* pCreateInfos,
    const(VkAllocationCallbacks)* pAllocator,
    VkPipeline* pPipelines,
);

alias PFN_vkGetExecutionGraphPipelineScratchSizeAMDX = VkResult function(
    VkDevice device,
    VkPipeline executionGraph,
    VkExecutionGraphPipelineScratchSizeAMDX* pSizeInfo,
);

alias PFN_vkGetExecutionGraphPipelineNodeIndexAMDX = VkResult function(
    VkDevice device,
    VkPipeline executionGraph,
    const(VkPipelineShaderStageNodeCreateInfoAMDX)* pNodeInfo,
    uint* pNodeIndex,
);

alias PFN_vkCmdInitializeGraphScratchMemoryAMDX = void function(
    VkCommandBuffer commandBuffer,
    VkPipeline executionGraph,
    VkDeviceAddress scratch,
    VkDeviceSize scratchSize,
);

alias PFN_vkCmdDispatchGraphAMDX = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress scratch,
    VkDeviceSize scratchSize,
    const(VkDispatchGraphCountInfoAMDX)* pCountInfo,
);

alias PFN_vkCmdDispatchGraphIndirectAMDX = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress scratch,
    VkDeviceSize scratchSize,
    const(VkDispatchGraphCountInfoAMDX)* pCountInfo,
);

alias PFN_vkCmdDispatchGraphIndirectCountAMDX = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress scratch,
    VkDeviceSize scratchSize,
    VkDeviceAddress countInfo,
);
