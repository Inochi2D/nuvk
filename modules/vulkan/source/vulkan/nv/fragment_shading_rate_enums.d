/**
 * VK_NV_fragment_shading_rate_enums (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.fragment_shading_rate_enums;

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

public import vulkan.khr.fragment_shading_rate;

struct VK_NV_fragment_shading_rate_enums {
    @VkProcName("vkCmdSetFragmentShadingRateEnumNV")
    PFN_vkCmdSetFragmentShadingRateEnumNV vkCmdSetFragmentShadingRateEnumNV;
}

enum VK_NV_FRAGMENT_SHADING_RATE_ENUMS_SPEC_VERSION = 1;
enum VK_NV_FRAGMENT_SHADING_RATE_ENUMS_EXTENSION_NAME = "VK_NV_fragment_shading_rate_enums";

struct VkPhysicalDeviceFragmentShadingRateEnumsFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_ENUMS_FEATURES_NV;
    void* pNext;
    VkBool32 fragmentShadingRateEnums;
    VkBool32 supersampleFragmentShadingRates;
    VkBool32 noInvocationFragmentShadingRates;
}

struct VkPhysicalDeviceFragmentShadingRateEnumsPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_ENUMS_PROPERTIES_NV;
    void* pNext;
    VkSampleCountFlags maxFragmentShadingRateInvocationCount;
}

import vulkan.khr.fragment_shading_rate : VkFragmentShadingRateCombinerOpKHR;
struct VkPipelineFragmentShadingRateEnumStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_FRAGMENT_SHADING_RATE_ENUM_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkFragmentShadingRateTypeNV shadingRateType;
    VkFragmentShadingRateNV shadingRate;
    VkFragmentShadingRateCombinerOpKHR[2] combinerOps;
}

alias VkFragmentShadingRateNV = uint;
enum VkFragmentShadingRateNV
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_PIXEL_NV = 0,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_1X2_PIXELS_NV = 1,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X1_PIXELS_NV = 4,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X2_PIXELS_NV = 5,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X4_PIXELS_NV = 6,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_4X2_PIXELS_NV = 9,
    VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_4X4_PIXELS_NV = 10,
    VK_FRAGMENT_SHADING_RATE_2_INVOCATIONS_PER_PIXEL_NV = 11,
    VK_FRAGMENT_SHADING_RATE_4_INVOCATIONS_PER_PIXEL_NV = 12,
    VK_FRAGMENT_SHADING_RATE_8_INVOCATIONS_PER_PIXEL_NV = 13,
    VK_FRAGMENT_SHADING_RATE_16_INVOCATIONS_PER_PIXEL_NV = 14,
    VK_FRAGMENT_SHADING_RATE_NO_INVOCATIONS_NV = 15;

alias VkFragmentShadingRateTypeNV = uint;
enum VkFragmentShadingRateTypeNV
    VK_FRAGMENT_SHADING_RATE_TYPE_FRAGMENT_SIZE_NV = 0,
    VK_FRAGMENT_SHADING_RATE_TYPE_ENUMS_NV = 1;

import vulkan.khr.fragment_shading_rate : VkFragmentShadingRateCombinerOpKHR;
alias PFN_vkCmdSetFragmentShadingRateEnumNV = void function(
    VkCommandBuffer commandBuffer,
    VkFragmentShadingRateNV shadingRate,
    const(VkFragmentShadingRateCombinerOpKHR)[2] combinerOps,
);
