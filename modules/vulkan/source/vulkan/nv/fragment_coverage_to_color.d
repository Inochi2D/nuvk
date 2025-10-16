/**
 * VK_NV_fragment_coverage_to_color (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.fragment_coverage_to_color;

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

enum VK_NV_FRAGMENT_COVERAGE_TO_COLOR_SPEC_VERSION = 1;
enum VK_NV_FRAGMENT_COVERAGE_TO_COLOR_EXTENSION_NAME = "VK_NV_fragment_coverage_to_color";

alias VkPipelineCoverageToColorStateCreateFlagsNV = VkFlags;

struct VkPipelineCoverageToColorStateCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_TO_COLOR_STATE_CREATE_INFO_NV;
    const(void)* pNext;
    VkFlags flags;
    VkBool32 coverageToColorEnable;
    uint coverageToColorLocation;
}
