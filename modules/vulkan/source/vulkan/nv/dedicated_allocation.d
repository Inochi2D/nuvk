/**
 * VK_NV_dedicated_allocation (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.dedicated_allocation;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.dedicated_allocation;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

enum VK_NV_DEDICATED_ALLOCATION_SPEC_VERSION = 1;
enum VK_NV_DEDICATED_ALLOCATION_EXTENSION_NAME = "VK_NV_dedicated_allocation";

struct VkDedicatedAllocationImageCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_IMAGE_CREATE_INFO_NV;
    const(void)* pNext;
    VkBool32 dedicatedAllocation;
}

struct VkDedicatedAllocationBufferCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_BUFFER_CREATE_INFO_NV;
    const(void)* pNext;
    VkBool32 dedicatedAllocation;
}

struct VkDedicatedAllocationMemoryAllocateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_MEMORY_ALLOCATE_INFO_NV;
    const(void)* pNext;
    VkImage image;
    VkBuffer buffer;
}
