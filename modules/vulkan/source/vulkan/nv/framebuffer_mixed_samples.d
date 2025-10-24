/**
 * VK_NV_framebuffer_mixed_samples (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.framebuffer_mixed_samples;

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

enum VK_NV_FRAMEBUFFER_MIXED_SAMPLES_SPEC_VERSION = 1;
enum VK_NV_FRAMEBUFFER_MIXED_SAMPLES_EXTENSION_NAME = "VK_NV_framebuffer_mixed_samples";

struct VkPipelineCoverageModulationStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_MODULATION_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkPipelineCoverageModulationStateCreateFlagsNV flags;
    VkCoverageModulationModeNV coverageModulationMode;
    VkBool32 coverageModulationTableEnable;
    uint coverageModulationTableCount;
    const(float)* pCoverageModulationTable;
}

alias VkPipelineCoverageModulationStateCreateFlagsNV = VkFlags;

alias VkCoverageModulationModeNV = uint;
enum VkCoverageModulationModeNV
    VK_COVERAGE_MODULATION_MODE_NONE_NV = 0,
    VK_COVERAGE_MODULATION_MODE_RGB_NV = 1,
    VK_COVERAGE_MODULATION_MODE_ALPHA_NV = 2,
    VK_COVERAGE_MODULATION_MODE_RGBA_NV = 3;

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

import vulkan.amd.mixed_attachment_samples : VkAttachmentSampleCountInfoAMD;
alias VkAttachmentSampleCountInfoNV = VkAttachmentSampleCountInfoAMD;
