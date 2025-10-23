/**
 * VK_EXT_mesh_shader (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.mesh_shader;

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
    public import vulkan.khr.spirv_1_4;
}

struct VK_EXT_mesh_shader {
    @VkProcName("vkCmdDrawMeshTasksEXT")
    PFN_vkCmdDrawMeshTasksEXT vkCmdDrawMeshTasksEXT;
    
    @VkProcName("vkCmdDrawMeshTasksIndirectEXT")
    PFN_vkCmdDrawMeshTasksIndirectEXT vkCmdDrawMeshTasksIndirectEXT;
    @VkProcName("vkCmdDrawMeshTasksIndirectCountEXT")
    PFN_vkCmdDrawMeshTasksIndirectCountEXT vkCmdDrawMeshTasksIndirectCountEXT;
    
    
}

enum VK_EXT_MESH_SHADER_SPEC_VERSION = 1;
enum VK_EXT_MESH_SHADER_EXTENSION_NAME = "VK_EXT_mesh_shader";

struct VkPhysicalDeviceMeshShaderFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_EXT;
    void* pNext;
    VkBool32 taskShader;
    VkBool32 meshShader;
    VkBool32 multiviewMeshShader;
    VkBool32 primitiveFragmentShadingRateMeshShader;
    VkBool32 meshShaderQueries;
}

struct VkPhysicalDeviceMeshShaderPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_EXT;
    void* pNext;
    uint maxTaskWorkGroupTotalCount;
    uint[3] maxTaskWorkGroupCount;
    uint maxTaskWorkGroupInvocations;
    uint[3] maxTaskWorkGroupSize;
    uint maxTaskPayloadSize;
    uint maxTaskSharedMemorySize;
    uint maxTaskPayloadAndSharedMemorySize;
    uint maxMeshWorkGroupTotalCount;
    uint[3] maxMeshWorkGroupCount;
    uint maxMeshWorkGroupInvocations;
    uint[3] maxMeshWorkGroupSize;
    uint maxMeshSharedMemorySize;
    uint maxMeshPayloadAndSharedMemorySize;
    uint maxMeshOutputMemorySize;
    uint maxMeshPayloadAndOutputMemorySize;
    uint maxMeshOutputComponents;
    uint maxMeshOutputVertices;
    uint maxMeshOutputPrimitives;
    uint maxMeshOutputLayers;
    uint maxMeshMultiviewViewCount;
    uint meshOutputPerVertexGranularity;
    uint meshOutputPerPrimitiveGranularity;
    uint maxPreferredTaskWorkGroupInvocations;
    uint maxPreferredMeshWorkGroupInvocations;
    VkBool32 prefersLocalInvocationVertexOutput;
    VkBool32 prefersLocalInvocationPrimitiveOutput;
    VkBool32 prefersCompactVertexOutput;
    VkBool32 prefersCompactPrimitiveOutput;
}

struct VkDrawMeshTasksIndirectCommandEXT {
    uint groupCountX;
    uint groupCountY;
    uint groupCountZ;
}

alias PFN_vkCmdDrawMeshTasksEXT = void function(
    VkCommandBuffer commandBuffer,
    uint groupCountX,
    uint groupCountY,
    uint groupCountZ,
);

alias PFN_vkCmdDrawMeshTasksIndirectEXT = void function(
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

alias PFN_vkCmdDrawMeshTasksIndirectCountEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    VkBuffer countBuffer,
    VkDeviceSize countBufferOffset,
    uint maxDrawCount,
    uint stride,
);
