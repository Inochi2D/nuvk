/**
 * VK_EXT_validation_cache (Device)
 * 
 * Author:
 *     Google LLC
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.validation_cache;

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

struct VK_EXT_validation_cache {
    @VkProcName("vkCreateValidationCacheEXT")
    PFN_vkCreateValidationCacheEXT vkCreateValidationCacheEXT;
    
    @VkProcName("vkDestroyValidationCacheEXT")
    PFN_vkDestroyValidationCacheEXT vkDestroyValidationCacheEXT;
    
    @VkProcName("vkMergeValidationCachesEXT")
    PFN_vkMergeValidationCachesEXT vkMergeValidationCachesEXT;
    
    @VkProcName("vkGetValidationCacheDataEXT")
    PFN_vkGetValidationCacheDataEXT vkGetValidationCacheDataEXT;
}

enum VK_EXT_VALIDATION_CACHE_SPEC_VERSION = 1;
enum VK_EXT_VALIDATION_CACHE_EXTENSION_NAME = "VK_EXT_validation_cache";

alias VkValidationCacheEXT = OpaqueHandle!("VkValidationCacheEXT");

struct VkValidationCacheCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VALIDATION_CACHE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkValidationCacheCreateFlagsEXT flags;
    size_t initialDataSize;
    const(void)* pInitialData;
}

struct VkShaderModuleValidationCacheCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SHADER_MODULE_VALIDATION_CACHE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkValidationCacheEXT validationCache;
}

alias VkValidationCacheHeaderVersionEXT = uint;
enum VkValidationCacheHeaderVersionEXT
    VK_VALIDATION_CACHE_HEADER_VERSION_ONE_EXT = 1;

alias VkValidationCacheCreateFlagsEXT = VkFlags;

alias PFN_vkCreateValidationCacheEXT = VkResult function(
    VkDevice device,
    const(VkValidationCacheCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkValidationCacheEXT pValidationCache,
);

alias PFN_vkDestroyValidationCacheEXT = void function(
    VkDevice device,
    VkValidationCacheEXT validationCache,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkMergeValidationCachesEXT = VkResult function(
    VkDevice device,
    VkValidationCacheEXT dstCache,
    uint srcCacheCount,
    const(VkValidationCacheEXT)* pSrcCaches,
);

alias PFN_vkGetValidationCacheDataEXT = VkResult function(
    VkDevice device,
    VkValidationCacheEXT validationCache,
    size_t* pDataSize,
    void* pData,
);
