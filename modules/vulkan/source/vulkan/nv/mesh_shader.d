/**
 * VK_NV_mesh_shader (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.mesh_shader;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_NV_mesh_shader {
    
    @VkProcName("vkCmdDrawMeshTasksNV")
    PFN_vkCmdDrawMeshTasksNV vkCmdDrawMeshTasksNV;
    
    @VkProcName("vkCmdDrawMeshTasksIndirectNV")
    PFN_vkCmdDrawMeshTasksIndirectNV vkCmdDrawMeshTasksIndirectNV;
    @VkProcName("vkCmdDrawMeshTasksIndirectCountNV")
    PFN_vkCmdDrawMeshTasksIndirectCountNV vkCmdDrawMeshTasksIndirectCountNV;
    
}

enum VK_NV_MESH_SHADER_SPEC_VERSION = 1;
enum VK_NV_MESH_SHADER_EXTENSION_NAME = "VK_NV_mesh_shader";

struct VkPhysicalDeviceMeshShaderFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_NV;
    void* pNext;
    VkBool32 taskShader;
    VkBool32 meshShader;
}

struct VkPhysicalDeviceMeshShaderPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_NV;
    void* pNext;
    uint maxDrawMeshTasksCount;
    uint maxTaskWorkGroupInvocations;
    uint maxTaskWorkGroupSize;
    uint maxTaskTotalMemorySize;
    uint maxTaskOutputCount;
    uint maxMeshWorkGroupInvocations;
    uint maxMeshWorkGroupSize;
    uint maxMeshTotalMemorySize;
    uint maxMeshOutputVertices;
    uint maxMeshOutputPrimitives;
    uint maxMeshMultiviewViewCount;
    uint meshOutputPerVertexGranularity;
    uint meshOutputPerPrimitiveGranularity;
}

struct VkDrawMeshTasksIndirectCommandNV {
    uint taskCount;
    uint firstTask;
}

alias PFN_vkCmdDrawMeshTasksNV = void function(
    VkCommandBuffer commandBuffer,
    uint taskCount,
    uint firstTask,
);

alias PFN_vkCmdDrawMeshTasksIndirectNV = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    uint drawCount,
    uint stride,
);

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.draw_indirect_count;
}
public import vulkan.amd.draw_indirect_count;

alias PFN_vkCmdDrawMeshTasksIndirectCountNV = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    VkBuffer countBuffer,
    VkDeviceSize countBufferOffset,
    uint maxDrawCount,
    uint stride,
);
