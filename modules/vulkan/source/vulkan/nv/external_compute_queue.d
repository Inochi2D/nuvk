/**
 * VK_NV_external_compute_queue (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.external_compute_queue;

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

struct VK_NV_external_compute_queue {
    
    @VkProcName("vkCreateExternalComputeQueueNV")
    PFN_vkCreateExternalComputeQueueNV vkCreateExternalComputeQueueNV;
    
    @VkProcName("vkDestroyExternalComputeQueueNV")
    PFN_vkDestroyExternalComputeQueueNV vkDestroyExternalComputeQueueNV;
    
    @VkProcName("vkGetExternalComputeQueueDataNV")
    PFN_vkGetExternalComputeQueueDataNV vkGetExternalComputeQueueDataNV;
}

enum VK_NV_EXTERNAL_COMPUTE_QUEUE_SPEC_VERSION = 1;
enum VK_NV_EXTERNAL_COMPUTE_QUEUE_EXTENSION_NAME = "VK_NV_external_compute_queue";

alias VkExternalComputeQueueNV = OpaqueHandle!("VkExternalComputeQueueNV");

struct VkExternalComputeQueueDeviceCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_COMPUTE_QUEUE_DEVICE_CREATE_INFO_NV;
    const(void)* pNext;
    uint reservedExternalQueues;
}

struct VkExternalComputeQueueCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_COMPUTE_QUEUE_CREATE_INFO_NV;
    const(void)* pNext;
    VkQueue preferredQueue;
}

struct VkExternalComputeQueueDataParamsNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_COMPUTE_QUEUE_DATA_PARAMS_NV;
    const(void)* pNext;
    uint deviceIndex;
}

struct VkPhysicalDeviceExternalComputeQueuePropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_COMPUTE_QUEUE_PROPERTIES_NV;
    void* pNext;
    uint externalDataSize;
    uint maxExternalQueues;
}

alias PFN_vkCreateExternalComputeQueueNV = VkResult function(
    VkDevice device,
    const(VkExternalComputeQueueCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkExternalComputeQueueNV* pExternalQueue,
);

alias PFN_vkDestroyExternalComputeQueueNV = void function(
    VkDevice device,
    VkExternalComputeQueueNV externalQueue,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetExternalComputeQueueDataNV = void function(
    VkExternalComputeQueueNV externalQueue,
    VkExternalComputeQueueDataParamsNV* params,
    void* pData,
);
