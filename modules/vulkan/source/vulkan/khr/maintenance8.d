/**
 * VK_KHR_maintenance8
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
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_1):

enum VK_KHR_MAINTENANCE_8_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_8_EXTENSION_NAME = "VK_KHR_maintenance8";

struct VkMemoryBarrierAccessFlags3KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER_ACCESS_FLAGS_3_KHR;
    const(void)* pNext;
    VkFlags64 srcAccessMask3;
    VkFlags64 dstAccessMask3;
}

enum VkAccessFlagBits3KHR : ulong {
    VK_ACCESS_3_NONE_KHR = 0,
}

enum VK_ACCESS_3_NONE_KHR = VkAccessFlagBits3KHR.VK_ACCESS_3_NONE_KHR;

alias VkAccessFlags3KHR = VkFlags64;

enum VkPipelineCacheCreateFlagBits : uint {
    EXTERNALLY_SYNCHRONIZED_BIT = 1,
    READ_ONLY_BIT = 2,
    USE_APPLICATION_STORAGE_BIT = 4,
    EXTERNALLY_SYNCHRONIZED_BIT_EXT = EXTERNALLY_SYNCHRONIZED_BIT,
    INTERNALLY_SYNCHRONIZED_MERGE_BIT_KHR = 8,
}

enum VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT = VkPipelineCacheCreateFlagBits.EXTERNALLY_SYNCHRONIZED_BIT;
enum VK_PIPELINE_CACHE_CREATE_READ_ONLY_BIT = VkPipelineCacheCreateFlagBits.READ_ONLY_BIT;
enum VK_PIPELINE_CACHE_CREATE_USE_APPLICATION_STORAGE_BIT = VkPipelineCacheCreateFlagBits.USE_APPLICATION_STORAGE_BIT;
enum VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT_EXT = VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT;
enum VK_PIPELINE_CACHE_CREATE_INTERNALLY_SYNCHRONIZED_MERGE_BIT_KHR = VkPipelineCacheCreateFlagBits.INTERNALLY_SYNCHRONIZED_MERGE_BIT_KHR;

struct VkPhysicalDeviceMaintenance8FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_8_FEATURES_KHR;
    void* pNext;
    VkBool32 maintenance8;
}
