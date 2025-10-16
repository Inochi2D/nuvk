/**
 * VK_KHR_pipeline_binary (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.pipeline_binary;

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

version (VK_VERSION_1_4) {} else {
    public import vulkan.khr.maintenance5;
}

struct VK_KHR_pipeline_binary {
    
    @VkProcName("vkCreatePipelineBinariesKHR")
    PFN_vkCreatePipelineBinariesKHR vkCreatePipelineBinariesKHR;
    
    @VkProcName("vkDestroyPipelineBinaryKHR")
    PFN_vkDestroyPipelineBinaryKHR vkDestroyPipelineBinaryKHR;
    
    @VkProcName("vkGetPipelineKeyKHR")
    PFN_vkGetPipelineKeyKHR vkGetPipelineKeyKHR;
    
    @VkProcName("vkGetPipelineBinaryDataKHR")
    PFN_vkGetPipelineBinaryDataKHR vkGetPipelineBinaryDataKHR;
    
    @VkProcName("vkReleaseCapturedPipelineDataKHR")
    PFN_vkReleaseCapturedPipelineDataKHR vkReleaseCapturedPipelineDataKHR;
}

enum VK_KHR_PIPELINE_BINARY_SPEC_VERSION = 1;
enum VK_KHR_PIPELINE_BINARY_EXTENSION_NAME = "VK_KHR_pipeline_binary";
enum uint VK_MAX_PIPELINE_BINARY_KEY_SIZE_KHR = 32;

struct VkPhysicalDevicePipelineBinaryFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_BINARY_FEATURES_KHR;
    void* pNext;
    VkBool32 pipelineBinaries;
}

struct VkPhysicalDevicePipelineBinaryPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_BINARY_PROPERTIES_KHR;
    void* pNext;
    VkBool32 pipelineBinaryInternalCache;
    VkBool32 pipelineBinaryInternalCacheControl;
    VkBool32 pipelineBinaryPrefersInternalCache;
    VkBool32 pipelineBinaryPrecompiledInternalCache;
    VkBool32 pipelineBinaryCompressedData;
}

struct VkDevicePipelineBinaryInternalCacheControlKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_PIPELINE_BINARY_INTERNAL_CACHE_CONTROL_KHR;
    const(void)* pNext;
    VkBool32 disableInternalCache;
}

alias VkPipelineBinaryKHR = OpaqueHandle!("VkPipelineBinaryKHR");

struct VkPipelineBinaryKeyKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_BINARY_KEY_KHR;
    void* pNext;
    uint keySize;
    ubyte[VK_MAX_PIPELINE_BINARY_KEY_SIZE_KHR] key;
}

struct VkPipelineBinaryDataKHR {
    size_t dataSize;
    void* pData;
}

struct VkPipelineBinaryKeysAndDataKHR {
    uint binaryCount;
    const(VkPipelineBinaryKeyKHR)* pPipelineBinaryKeys;
    const(VkPipelineBinaryDataKHR)* pPipelineBinaryData;
}

struct VkPipelineBinaryCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_BINARY_CREATE_INFO_KHR;
    const(void)* pNext;
    const(VkPipelineBinaryKeysAndDataKHR)* pKeysAndDataInfo;
    VkPipeline pipeline;
    const(VkPipelineCreateInfoKHR)* pPipelineCreateInfo;
}

struct VkPipelineBinaryInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_BINARY_INFO_KHR;
    const(void)* pNext;
    uint binaryCount;
    const(VkPipelineBinaryKHR)* pPipelineBinaries;
}

struct VkReleaseCapturedPipelineDataInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RELEASE_CAPTURED_PIPELINE_DATA_INFO_KHR;
    void* pNext;
    VkPipeline pipeline;
}

struct VkPipelineBinaryDataInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_BINARY_DATA_INFO_KHR;
    void* pNext;
    VkPipelineBinaryKHR pipelineBinary;
}

struct VkPipelineCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_CREATE_INFO_KHR;
    void* pNext;
}

struct VkPipelineBinaryHandlesInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_BINARY_HANDLES_INFO_KHR;
    const(void)* pNext;
    uint pipelineBinaryCount;
    VkPipelineBinaryKHR* pPipelineBinaries;
}

alias PFN_vkCreatePipelineBinariesKHR = VkResult function(
    VkDevice device,
    const(VkPipelineBinaryCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkPipelineBinaryHandlesInfoKHR* pBinaries,
);

alias PFN_vkDestroyPipelineBinaryKHR = void function(
    VkDevice device,
    VkPipelineBinaryKHR pipelineBinary,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetPipelineKeyKHR = VkResult function(
    VkDevice device,
    const(VkPipelineCreateInfoKHR)* pPipelineCreateInfo,
    VkPipelineBinaryKeyKHR* pPipelineKey,
);

alias PFN_vkGetPipelineBinaryDataKHR = VkResult function(
    VkDevice device,
    const(VkPipelineBinaryDataInfoKHR)* pInfo,
    VkPipelineBinaryKeyKHR* pPipelineBinaryKey,
    size_t* pPipelineBinaryDataSize,
    void* pPipelineBinaryData,
);

alias PFN_vkReleaseCapturedPipelineDataKHR = VkResult function(
    VkDevice device,
    const(VkReleaseCapturedPipelineDataInfoKHR)* pInfo,
    const(VkAllocationCallbacks)* pAllocator,
);
