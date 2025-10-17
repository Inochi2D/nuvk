/**
 * VK_NV_descriptor_pool_overallocation (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.descriptor_pool_overallocation;

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


enum VK_NV_DESCRIPTOR_POOL_OVERALLOCATION_SPEC_VERSION = 1;
enum VK_NV_DESCRIPTOR_POOL_OVERALLOCATION_EXTENSION_NAME = "VK_NV_descriptor_pool_overallocation";

struct VkPhysicalDeviceDescriptorPoolOverallocationFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_POOL_OVERALLOCATION_FEATURES_NV;
    void* pNext;
    VkBool32 descriptorPoolOverallocation;
}
