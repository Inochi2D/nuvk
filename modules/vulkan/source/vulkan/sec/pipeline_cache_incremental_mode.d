/**
 * VK_SEC_pipeline_cache_incremental_mode (Device)
 * 
 * Author:
 *     Samsung Electronics Co., Ltd.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.sec.pipeline_cache_incremental_mode;

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

enum VK_SEC_PIPELINE_CACHE_INCREMENTAL_MODE_SPEC_VERSION = 1;
enum VK_SEC_PIPELINE_CACHE_INCREMENTAL_MODE_EXTENSION_NAME = "VK_SEC_pipeline_cache_incremental_mode";

struct VkPhysicalDevicePipelineCacheIncrementalModeFeaturesSEC {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_CACHE_INCREMENTAL_MODE_FEATURES_SEC;
    void* pNext;
    VkBool32 pipelineCacheIncrementalMode;
}
