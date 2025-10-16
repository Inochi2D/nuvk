/**
 * VK_EXT_pipeline_creation_cache_control
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.pipeline_creation_cache_control;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_EXT_PIPELINE_CREATION_CACHE_CONTROL_SPEC_VERSION = 3;
enum VK_EXT_PIPELINE_CREATION_CACHE_CONTROL_EXTENSION_NAME = "VK_EXT_pipeline_creation_cache_control";

alias VkPhysicalDevicePipelineCreationCacheControlFeaturesEXT = VkPhysicalDevicePipelineCreationCacheControlFeatures;

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
