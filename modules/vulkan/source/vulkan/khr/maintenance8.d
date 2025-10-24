/**
 * VK_KHR_maintenance8 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance8;

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


enum VK_KHR_MAINTENANCE_8_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_8_EXTENSION_NAME = "VK_KHR_maintenance8";

struct VkMemoryBarrierAccessFlags3KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER_ACCESS_FLAGS_3_KHR;
    const(void)* pNext;
    VkAccessFlags3KHR srcAccessMask3;
    VkAccessFlags3KHR dstAccessMask3;
}

alias VkAccessFlags3KHR = ulong;
enum VkAccessFlags3KHR
    VK_ACCESS_3_NONE_KHR = 0;


alias VkPipelineCacheCreateFlags = uint;
enum VkPipelineCacheCreateFlags
    VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT = 1,
    VK_PIPELINE_CACHE_CREATE_READ_ONLY_BIT = 2,
    VK_PIPELINE_CACHE_CREATE_USE_APPLICATION_STORAGE_BIT = 4,
    VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT_EXT = VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT,
    VK_PIPELINE_CACHE_CREATE_INTERNALLY_SYNCHRONIZED_MERGE_BIT_KHR = 8;

struct VkPhysicalDeviceMaintenance8FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_8_FEATURES_KHR;
    void* pNext;
    VkBool32 maintenance8;
}
