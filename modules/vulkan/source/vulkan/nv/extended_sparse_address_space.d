/**
 * VK_NV_extended_sparse_address_space (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.extended_sparse_address_space;

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

enum VK_NV_EXTENDED_SPARSE_ADDRESS_SPACE_SPEC_VERSION = 1;
enum VK_NV_EXTENDED_SPARSE_ADDRESS_SPACE_EXTENSION_NAME = "VK_NV_extended_sparse_address_space";

struct VkPhysicalDeviceExtendedSparseAddressSpaceFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_SPARSE_ADDRESS_SPACE_FEATURES_NV;
    void* pNext;
    VkBool32 extendedSparseAddressSpace;
}

struct VkPhysicalDeviceExtendedSparseAddressSpacePropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_SPARSE_ADDRESS_SPACE_PROPERTIES_NV;
    void* pNext;
    VkDeviceSize extendedSparseAddressSpaceSize;
    VkFlags extendedSparseImageUsageFlags;
    VkFlags extendedSparseBufferUsageFlags;
}
