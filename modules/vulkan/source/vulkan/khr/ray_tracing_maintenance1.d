/**
 * VK_KHR_ray_tracing_maintenance1 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.ray_tracing_maintenance1;

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

struct VK_KHR_ray_tracing_maintenance1 {
    
    @VkProcName("vkCmdTraceRaysIndirect2KHR")
    PFN_vkCmdTraceRaysIndirect2KHR vkCmdTraceRaysIndirect2KHR;
    
}

enum VK_KHR_RAY_TRACING_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_KHR_RAY_TRACING_MAINTENANCE_1_EXTENSION_NAME = "VK_KHR_ray_tracing_maintenance1";

struct VkPhysicalDeviceRayTracingMaintenance1FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_MAINTENANCE_1_FEATURES_KHR;
    void* pNext;
    VkBool32 rayTracingMaintenance1;
    VkBool32 rayTracingPipelineTraceRaysIndirect2;
}

public import vulkan.khr.ray_tracing_pipeline;

struct VkTraceRaysIndirectCommand2KHR {
    VkDeviceAddress raygenShaderRecordAddress;
    VkDeviceSize raygenShaderRecordSize;
    VkDeviceAddress missShaderBindingTableAddress;
    VkDeviceSize missShaderBindingTableSize;
    VkDeviceSize missShaderBindingTableStride;
    VkDeviceAddress hitShaderBindingTableAddress;
    VkDeviceSize hitShaderBindingTableSize;
    VkDeviceSize hitShaderBindingTableStride;
    VkDeviceAddress callableShaderBindingTableAddress;
    VkDeviceSize callableShaderBindingTableSize;
    VkDeviceSize callableShaderBindingTableStride;
    uint width;
    uint height;
    uint depth;
}

alias PFN_vkCmdTraceRaysIndirect2KHR = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress indirectDeviceAddress,
);
