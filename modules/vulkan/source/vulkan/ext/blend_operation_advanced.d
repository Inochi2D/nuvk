/**
 * VK_EXT_blend_operation_advanced
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.blend_operation_advanced;

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

enum VK_EXT_BLEND_OPERATION_ADVANCED_SPEC_VERSION = 2;
enum VK_EXT_BLEND_OPERATION_ADVANCED_EXTENSION_NAME = "VK_EXT_blend_operation_advanced";

struct VkPhysicalDeviceBlendOperationAdvancedFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_FEATURES_EXT;
    void* pNext;
    VkBool32 advancedBlendCoherentOperations;
}

struct VkPhysicalDeviceBlendOperationAdvancedPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_PROPERTIES_EXT;
    void* pNext;
    uint advancedBlendMaxColorAttachments;
    VkBool32 advancedBlendIndependentBlend;
    VkBool32 advancedBlendNonPremultipliedSrcColor;
    VkBool32 advancedBlendNonPremultipliedDstColor;
    VkBool32 advancedBlendCorrelatedOverlap;
    VkBool32 advancedBlendAllOperations;
}

struct VkPipelineColorBlendAdvancedStateCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_ADVANCED_STATE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkBool32 srcPremultiplied;
    VkBool32 dstPremultiplied;
    VkBlendOverlapEXT blendOverlap;
}

enum VkBlendOverlapEXT {
    VK_BLEND_OVERLAP_UNCORRELATED_EXT = 0,
    VK_BLEND_OVERLAP_DISJOINT_EXT = 1,
    VK_BLEND_OVERLAP_CONJOINT_EXT = 2,
}

enum VK_BLEND_OVERLAP_UNCORRELATED_EXT = VkBlendOverlapEXT.VK_BLEND_OVERLAP_UNCORRELATED_EXT;
enum VK_BLEND_OVERLAP_DISJOINT_EXT = VkBlendOverlapEXT.VK_BLEND_OVERLAP_DISJOINT_EXT;
enum VK_BLEND_OVERLAP_CONJOINT_EXT = VkBlendOverlapEXT.VK_BLEND_OVERLAP_CONJOINT_EXT;
