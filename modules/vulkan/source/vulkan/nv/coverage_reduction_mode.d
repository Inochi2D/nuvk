/**
 * VK_NV_coverage_reduction_mode (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.coverage_reduction_mode;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}
public import vulkan.nv.framebuffer_mixed_samples;

struct VK_NV_coverage_reduction_mode {
    @VkProcName("vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV")
    PFN_vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV;
}

enum VK_NV_COVERAGE_REDUCTION_MODE_SPEC_VERSION = 1;
enum VK_NV_COVERAGE_REDUCTION_MODE_EXTENSION_NAME = "VK_NV_coverage_reduction_mode";

struct VkPhysicalDeviceCoverageReductionModeFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COVERAGE_REDUCTION_MODE_FEATURES_NV;
    void* pNext;
    VkBool32 coverageReductionMode;
}

struct VkPipelineCoverageReductionStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_REDUCTION_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkPipelineCoverageReductionStateCreateFlagsNV flags;
    VkCoverageReductionModeNV coverageReductionMode;
}

alias VkPipelineCoverageReductionStateCreateFlagsNV = VkFlags;

alias VkCoverageReductionModeNV = uint;
enum VkCoverageReductionModeNV
    VK_COVERAGE_REDUCTION_MODE_MERGE_NV = 0,
    VK_COVERAGE_REDUCTION_MODE_TRUNCATE_NV = 1;

struct VkFramebufferMixedSamplesCombinationNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_MIXED_SAMPLES_COMBINATION_NV;
    void* pNext;
    VkCoverageReductionModeNV coverageReductionMode;
    VkSampleCountFlags rasterizationSamples;
    VkSampleCountFlags depthStencilSamples;
    VkSampleCountFlags colorSamples;
}

alias PFN_vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pCombinationCount,
    VkFramebufferMixedSamplesCombinationNV* pCombinations,
);
