/**
 * VK_NV_external_memory_rdma
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.external_memory_rdma;

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
    public import vulkan.khr.external_memory;
}

struct VK_NV_external_memory_rdma {
    
    @VkProcName("vkGetMemoryRemoteAddressNV")
    PFN_vkGetMemoryRemoteAddressNV vkGetMemoryRemoteAddressNV;
}

enum VK_NV_EXTERNAL_MEMORY_RDMA_SPEC_VERSION = 1;
enum VK_NV_EXTERNAL_MEMORY_RDMA_EXTENSION_NAME = "VK_NV_external_memory_rdma";

alias VkRemoteAddressNV = void*;

struct VkMemoryGetRemoteAddressInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_REMOTE_ADDRESS_INFO_NV;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlagBits handleType;
}

struct VkPhysicalDeviceExternalMemoryRDMAFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_RDMA_FEATURES_NV;
    void* pNext;
    VkBool32 externalMemoryRDMA;
}

alias PFN_vkGetMemoryRemoteAddressNV = VkResult function(
    VkDevice device,
    const(VkMemoryGetRemoteAddressInfoNV)* pMemoryGetRemoteAddressInfo,
    VkRemoteAddressNV* pAddress,
);
