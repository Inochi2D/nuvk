/**
 * VK_KHR_external_semaphore_fd (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_semaphore_fd;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.external_semaphore;
}

struct VK_KHR_external_semaphore_fd {
    @VkProcName("vkImportSemaphoreFdKHR")
    PFN_vkImportSemaphoreFdKHR vkImportSemaphoreFdKHR;
    
    @VkProcName("vkGetSemaphoreFdKHR")
    PFN_vkGetSemaphoreFdKHR vkGetSemaphoreFdKHR;
}

enum VK_KHR_EXTERNAL_SEMAPHORE_FD_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_SEMAPHORE_FD_EXTENSION_NAME = "VK_KHR_external_semaphore_fd";

struct VkImportSemaphoreFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_FD_INFO_KHR;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkSemaphoreImportFlags flags;
    VkExternalSemaphoreHandleTypeFlags handleType;
    int fd;
}

struct VkSemaphoreGetFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkExternalSemaphoreHandleTypeFlags handleType;
}

alias PFN_vkImportSemaphoreFdKHR = VkResult function(
    VkDevice device,
    const(VkImportSemaphoreFdInfoKHR)* pImportSemaphoreFdInfo,
);

alias PFN_vkGetSemaphoreFdKHR = VkResult function(
    VkDevice device,
    const(VkSemaphoreGetFdInfoKHR)* pGetFdInfo,
    int* pFd,
);
