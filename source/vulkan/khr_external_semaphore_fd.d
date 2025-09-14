/**
    VK_KHR_external_semaphore_fd
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_external_semaphore_fd;
import vulkan.khr_external_memory;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_SEMAPHORE_FD_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_SEMAPHORE_FD_EXTENSION_NAME = "VK_KHR_external_semaphore_fd";

struct VkImportSemaphoreFdInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkSemaphoreImportFlags flags;
    VkExternalSemaphoreHandleTypeFlags handleType;
    int fd;
}

struct VkSemaphoreGetFdInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkExternalSemaphoreHandleTypeFlags handleType;
}

alias PFN_vkImportSemaphoreFdKHR = VkResult function(VkDevice device, const(
        VkImportSemaphoreFdInfoKHR)* pImportSemaphoreFdInfo);
alias PFN_vkGetSemaphoreFdKHR = VkResult function(VkDevice device, const(VkSemaphoreGetFdInfoKHR)* pGetFdInfo, int* pFd);

version(VK_KHR_external_semaphore_fd) {
    VkResult vkImportSemaphoreFdKHR(VkDevice device, const(VkImportSemaphoreFdInfoKHR)* pImportSemaphoreFdInfo);
    VkResult vkGetSemaphoreFdKHR(VkDevice device, const(VkSemaphoreGetFdInfoKHR)* pGetFdInfo, int* pFd);
}