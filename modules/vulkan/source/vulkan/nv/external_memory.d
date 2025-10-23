/**
 * VK_NV_external_memory (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.external_memory;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.external_memory;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.nv.external_memory_capabilities;

enum VK_NV_EXTERNAL_MEMORY_SPEC_VERSION = 1;
enum VK_NV_EXTERNAL_MEMORY_EXTENSION_NAME = "VK_NV_external_memory";

import vulkan.nv.external_memory_capabilities : VkExternalMemoryHandleTypeFlagsNV;
struct VkExternalMemoryImageCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_NV;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagsNV handleTypes;
}

import vulkan.nv.external_memory_capabilities : VkExternalMemoryHandleTypeFlagsNV;
struct VkExportMemoryAllocateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_NV;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagsNV handleTypes;
}
