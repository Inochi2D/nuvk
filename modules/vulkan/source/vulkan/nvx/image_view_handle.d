/**
 * VK_NVX_image_view_handle (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nvx.image_view_handle;

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

struct VK_NVX_image_view_handle {
    
    @VkProcName("vkGetImageViewHandleNVX")
    PFN_vkGetImageViewHandleNVX vkGetImageViewHandleNVX;
    
    @VkProcName("vkGetImageViewHandle64NVX")
    PFN_vkGetImageViewHandle64NVX vkGetImageViewHandle64NVX;
    
    @VkProcName("vkGetImageViewAddressNVX")
    PFN_vkGetImageViewAddressNVX vkGetImageViewAddressNVX;
}

enum VK_NVX_IMAGE_VIEW_HANDLE_SPEC_VERSION = 3;
enum VK_NVX_IMAGE_VIEW_HANDLE_EXTENSION_NAME = "VK_NVX_image_view_handle";

struct VkImageViewHandleInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_HANDLE_INFO_NVX;
    const(void)* pNext;
    VkImageView imageView;
    VkDescriptorType descriptorType;
    VkSampler sampler;
}

struct VkImageViewAddressPropertiesNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_ADDRESS_PROPERTIES_NVX;
    void* pNext;
    VkDeviceAddress deviceAddress;
    VkDeviceSize size;
}

alias PFN_vkGetImageViewHandleNVX = uint function(
    VkDevice device,
    const(VkImageViewHandleInfoNVX)* pInfo,
);

alias PFN_vkGetImageViewHandle64NVX = ulong function(
    VkDevice device,
    const(VkImageViewHandleInfoNVX)* pInfo,
);

alias PFN_vkGetImageViewAddressNVX = VkResult function(
    VkDevice device,
    VkImageView imageView,
    VkImageViewAddressPropertiesNVX* pProperties,
);
