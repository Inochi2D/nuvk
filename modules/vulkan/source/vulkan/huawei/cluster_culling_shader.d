/**
 * VK_HUAWEI_cluster_culling_shader (Device)
 * 
 * Author:
 *     Huawei Technologies Co. Ltd.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.huawei.cluster_culling_shader;

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

struct VK_HUAWEI_cluster_culling_shader {
    
    @VkProcName("vkCmdDrawClusterHUAWEI")
    PFN_vkCmdDrawClusterHUAWEI vkCmdDrawClusterHUAWEI;
    
    @VkProcName("vkCmdDrawClusterIndirectHUAWEI")
    PFN_vkCmdDrawClusterIndirectHUAWEI vkCmdDrawClusterIndirectHUAWEI;
}

enum VK_HUAWEI_CLUSTER_CULLING_SHADER_SPEC_VERSION = 3;
enum VK_HUAWEI_CLUSTER_CULLING_SHADER_EXTENSION_NAME = "VK_HUAWEI_cluster_culling_shader";

struct VkPhysicalDeviceClusterCullingShaderFeaturesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_FEATURES_HUAWEI;
    void* pNext;
    VkBool32 clustercullingShader;
    VkBool32 multiviewClusterCullingShader;
}

struct VkPhysicalDeviceClusterCullingShaderPropertiesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_PROPERTIES_HUAWEI;
    void* pNext;
    uint[3] maxWorkGroupCount;
    uint[3] maxWorkGroupSize;
    uint maxOutputClusterCount;
    VkDeviceSize indirectBufferOffsetAlignment;
}

struct VkPhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_VRS_FEATURES_HUAWEI;
    void* pNext;
    VkBool32 clusterShadingRate;
}

alias PFN_vkCmdDrawClusterHUAWEI = void function(
    VkCommandBuffer commandBuffer,
    uint groupCountX,
    uint groupCountY,
    uint groupCountZ,
);

alias PFN_vkCmdDrawClusterIndirectHUAWEI = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
);
