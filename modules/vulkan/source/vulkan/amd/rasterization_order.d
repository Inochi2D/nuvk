/**
 * VK_AMD_rasterization_order (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.rasterization_order;

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

enum VK_AMD_RASTERIZATION_ORDER_SPEC_VERSION = 1;
enum VK_AMD_RASTERIZATION_ORDER_EXTENSION_NAME = "VK_AMD_rasterization_order";

alias VkRasterizationOrderAMD = uint;
enum VkRasterizationOrderAMD
    VK_RASTERIZATION_ORDER_STRICT_AMD = 0,
    VK_RASTERIZATION_ORDER_RELAXED_AMD = 1;

struct VkPipelineRasterizationStateRasterizationOrderAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_RASTERIZATION_ORDER_AMD;
    const(void)* pNext;
    VkRasterizationOrderAMD rasterizationOrder;
}
