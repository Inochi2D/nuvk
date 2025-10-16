/**
 * VK_NV_cooperative_matrix
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.cooperative_matrix;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.shader_bfloat16;
import vulkan.khr.cooperative_matrix;

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

struct VK_NV_cooperative_matrix {
    
    @VkProcName("vkGetPhysicalDeviceCooperativeMatrixPropertiesNV")
    PFN_vkGetPhysicalDeviceCooperativeMatrixPropertiesNV vkGetPhysicalDeviceCooperativeMatrixPropertiesNV;
}

enum VK_NV_COOPERATIVE_MATRIX_SPEC_VERSION = 1;
enum VK_NV_COOPERATIVE_MATRIX_EXTENSION_NAME = "VK_NV_cooperative_matrix";

struct VkCooperativeMatrixPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_COOPERATIVE_MATRIX_PROPERTIES_NV;
    void* pNext;
    uint MSize;
    uint NSize;
    uint KSize;
    VkComponentTypeNV AType;
    VkComponentTypeNV BType;
    VkComponentTypeNV CType;
    VkComponentTypeNV DType;
    VkScopeNV scope_;
}

alias VkScopeNV = VkScopeKHR;

alias VkComponentTypeNV = VkComponentTypeKHR;

struct VkPhysicalDeviceCooperativeMatrixFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_FEATURES_NV;
    void* pNext;
    VkBool32 cooperativeMatrix;
    VkBool32 cooperativeMatrixRobustBufferAccess;
}

struct VkPhysicalDeviceCooperativeMatrixPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_PROPERTIES_NV;
    void* pNext;
    VkFlags cooperativeMatrixSupportedStages;
}

alias PFN_vkGetPhysicalDeviceCooperativeMatrixPropertiesNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkCooperativeMatrixPropertiesNV* pProperties,
);
