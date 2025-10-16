/**
 * VK_NV_cooperative_matrix2 (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.cooperative_matrix2;

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

public import vulkan.khr.cooperative_matrix;

struct VK_NV_cooperative_matrix2 {
    
    @VkProcName("vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV")
    PFN_vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV;
}

enum VK_NV_COOPERATIVE_MATRIX_2_SPEC_VERSION = 1;
enum VK_NV_COOPERATIVE_MATRIX_2_EXTENSION_NAME = "VK_NV_cooperative_matrix2";

struct VkCooperativeMatrixFlexibleDimensionsPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_COOPERATIVE_MATRIX_FLEXIBLE_DIMENSIONS_PROPERTIES_NV;
    void* pNext;
    uint MGranularity;
    uint NGranularity;
    uint KGranularity;
    VkComponentTypeKHR AType;
    VkComponentTypeKHR BType;
    VkComponentTypeKHR CType;
    VkComponentTypeKHR ResultType;
    VkBool32 saturatingAccumulation;
    VkScopeKHR scope_;
    uint workgroupInvocations;
}

struct VkPhysicalDeviceCooperativeMatrix2FeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_2_FEATURES_NV;
    void* pNext;
    VkBool32 cooperativeMatrixWorkgroupScope;
    VkBool32 cooperativeMatrixFlexibleDimensions;
    VkBool32 cooperativeMatrixReductions;
    VkBool32 cooperativeMatrixConversions;
    VkBool32 cooperativeMatrixPerElementOperations;
    VkBool32 cooperativeMatrixTensorAddressing;
    VkBool32 cooperativeMatrixBlockLoads;
}

struct VkPhysicalDeviceCooperativeMatrix2PropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_2_PROPERTIES_NV;
    void* pNext;
    uint cooperativeMatrixWorkgroupScopeMaxWorkgroupSize;
    uint cooperativeMatrixFlexibleDimensionsMaxDimension;
    uint cooperativeMatrixWorkgroupScopeReservedSharedMemory;
}

alias PFN_vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkCooperativeMatrixFlexibleDimensionsPropertiesNV* pProperties,
);
