/**
 * VK_EXT_hdr_metadata (Device)
 * 
 * Author:
 *     Google LLC
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.hdr_metadata;

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

public import vulkan.khr.swapchain;

struct VK_EXT_hdr_metadata {
    @VkProcName("vkSetHdrMetadataEXT")
    PFN_vkSetHdrMetadataEXT vkSetHdrMetadataEXT;
}

enum VK_EXT_HDR_METADATA_SPEC_VERSION = 3;
enum VK_EXT_HDR_METADATA_EXTENSION_NAME = "VK_EXT_hdr_metadata";

struct VkHdrMetadataEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_HDR_METADATA_EXT;
    const(void)* pNext;
    VkXYColorEXT displayPrimaryRed;
    VkXYColorEXT displayPrimaryGreen;
    VkXYColorEXT displayPrimaryBlue;
    VkXYColorEXT whitePoint;
    float maxLuminance;
    float minLuminance;
    float maxContentLightLevel;
    float maxFrameAverageLightLevel;
}

struct VkXYColorEXT {
    float x;
    float y;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkSetHdrMetadataEXT = void function(
    VkDevice device,
    uint swapchainCount,
    const(VkSwapchainKHR)* pSwapchains,
    const(VkHdrMetadataEXT)* pMetadata,
);
