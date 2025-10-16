/**
 * VK_AMD_mixed_attachment_samples (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.mixed_attachment_samples;

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

enum VK_AMD_MIXED_ATTACHMENT_SAMPLES_SPEC_VERSION = 1;
enum VK_AMD_MIXED_ATTACHMENT_SAMPLES_EXTENSION_NAME = "VK_AMD_mixed_attachment_samples";

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

struct VkAttachmentSampleCountInfoAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_ATTACHMENT_SAMPLE_COUNT_INFO_AMD;
    const(void)* pNext;
    uint colorAttachmentCount;
    const(VkSampleCountFlagBits)* pColorAttachmentSamples;
    VkSampleCountFlagBits depthStencilAttachmentSamples;
}
