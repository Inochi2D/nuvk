/**
 * VK_KHR_dynamic_rendering_local_read (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.dynamic_rendering_local_read;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

struct VK_KHR_dynamic_rendering_local_read {
    
    @VkProcName("vkCmdSetRenderingAttachmentLocations")
    PFN_vkCmdSetRenderingAttachmentLocations vkCmdSetRenderingAttachmentLocations;
    
    @VkProcName("vkCmdSetRenderingInputAttachmentIndices")
    PFN_vkCmdSetRenderingInputAttachmentIndices vkCmdSetRenderingInputAttachmentIndices;
}

enum VK_KHR_DYNAMIC_RENDERING_LOCAL_READ_SPEC_VERSION = 1;
enum VK_KHR_DYNAMIC_RENDERING_LOCAL_READ_EXTENSION_NAME = "VK_KHR_dynamic_rendering_local_read";

alias VkPhysicalDeviceDynamicRenderingLocalReadFeaturesKHR = VkPhysicalDeviceDynamicRenderingLocalReadFeatures;

alias VkRenderingAttachmentLocationInfoKHR = VkRenderingAttachmentLocationInfo;

alias VkRenderingInputAttachmentIndexInfoKHR = VkRenderingInputAttachmentIndexInfo;

alias PFN_vkCmdSetRenderingAttachmentLocations = void function(
    VkCommandBuffer commandBuffer,
    const(VkRenderingAttachmentLocationInfo)* pLocationInfo,
);

alias PFN_vkCmdSetRenderingInputAttachmentIndices = void function(
    VkCommandBuffer commandBuffer,
    const(VkRenderingInputAttachmentIndexInfo)* pInputAttachmentIndexInfo,
);
