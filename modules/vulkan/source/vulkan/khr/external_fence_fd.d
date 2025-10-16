/**
 * VK_KHR_external_fence_fd (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_fence_fd;

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
    public import vulkan.khr.external_fence;
}

struct VK_KHR_external_fence_fd {
    
    @VkProcName("vkImportFenceFdKHR")
    PFN_vkImportFenceFdKHR vkImportFenceFdKHR;
    
    @VkProcName("vkGetFenceFdKHR")
    PFN_vkGetFenceFdKHR vkGetFenceFdKHR;
}

enum VK_KHR_EXTERNAL_FENCE_FD_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_FENCE_FD_EXTENSION_NAME = "VK_KHR_external_fence_fd";

struct VkImportFenceFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkFlags flags;
    VkExternalFenceHandleTypeFlagBits handleType;
    int fd;
}

struct VkFenceGetFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkExternalFenceHandleTypeFlagBits handleType;
}

alias PFN_vkImportFenceFdKHR = VkResult function(
    VkDevice device,
    const(VkImportFenceFdInfoKHR)* pImportFenceFdInfo,
);

alias PFN_vkGetFenceFdKHR = VkResult function(
    VkDevice device,
    const(VkFenceGetFdInfoKHR)* pGetFdInfo,
    int* pFd,
);
