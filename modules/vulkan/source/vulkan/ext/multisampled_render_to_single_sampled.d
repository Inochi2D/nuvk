/**
 * VK_EXT_multisampled_render_to_single_sampled (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.multisampled_render_to_single_sampled;

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
    public import vulkan.khr.depth_stencil_resolve;
    public import vulkan.khr.create_renderpass2;
}

enum VK_EXT_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_SPEC_VERSION = 1;
enum VK_EXT_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_EXTENSION_NAME = "VK_EXT_multisampled_render_to_single_sampled";

struct VkPhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_FEATURES_EXT;
    void* pNext;
    VkBool32 multisampledRenderToSingleSampled;
}

struct VkSubpassResolvePerformanceQueryEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SUBPASS_RESOLVE_PERFORMANCE_QUERY_EXT;
    void* pNext;
    VkBool32 optimal;
}

struct VkMultisampledRenderToSingleSampledInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_INFO_EXT;
    const(void)* pNext;
    VkBool32 multisampledRenderToSingleSampledEnable;
    VkSampleCountFlagBits rasterizationSamples;
}
