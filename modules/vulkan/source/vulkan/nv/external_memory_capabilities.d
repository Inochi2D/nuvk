/**
 * VK_NV_external_memory_capabilities (Instance)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.external_memory_capabilities;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.external_memory_capabilities;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

struct VK_NV_external_memory_capabilities {
    @VkProcName("vkGetPhysicalDeviceExternalImageFormatPropertiesNV")
    PFN_vkGetPhysicalDeviceExternalImageFormatPropertiesNV vkGetPhysicalDeviceExternalImageFormatPropertiesNV;
}

enum VK_NV_EXTERNAL_MEMORY_CAPABILITIES_SPEC_VERSION = 1;
enum VK_NV_EXTERNAL_MEMORY_CAPABILITIES_EXTENSION_NAME = "VK_NV_external_memory_capabilities";


alias VkExternalMemoryHandleTypeFlagsNV = uint;
enum VkExternalMemoryHandleTypeFlagsNV
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_NV = 1,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_NV = 2,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_IMAGE_BIT_NV = 4,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_IMAGE_KMT_BIT_NV = 8;


alias VkExternalMemoryFeatureFlagsNV = uint;
enum VkExternalMemoryFeatureFlagsNV
    VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_NV = 1,
    VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_NV = 2,
    VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_NV = 4;

struct VkExternalImageFormatPropertiesNV {
    VkImageFormatProperties imageFormatProperties;
    VkExternalMemoryFeatureFlagsNV externalMemoryFeatures;
    VkExternalMemoryHandleTypeFlagsNV exportFromImportedHandleTypes;
    VkExternalMemoryHandleTypeFlagsNV compatibleHandleTypes;
}

alias PFN_vkGetPhysicalDeviceExternalImageFormatPropertiesNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkFormat format,
    VkImageType type,
    VkImageTiling tiling,
    VkImageUsageFlags usage,
    VkImageCreateFlags flags,
    VkExternalMemoryHandleTypeFlagsNV externalHandleType,
    VkExternalImageFormatPropertiesNV* pExternalImageFormatProperties,
);
