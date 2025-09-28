/**
    VK_KHR_external_fence_fd
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.external_fence_fd;
import vulkan.khr.external_memory;
import vulkan.khr.external_fence;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_FENCE_FD_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_FENCE_FD_EXTENSION_NAME = "VK_KHR_external_fence_fd";

struct VkImportFenceFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkFenceImportFlags flags;
    VkExternalFenceHandleTypeFlags handleType;
    int fd;
}

struct VkFenceGetFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkExternalFenceHandleTypeFlags handleType;
}

alias PFN_vkImportFenceFdKHR = VkResult function(VkDevice device, const(VkImportFenceFdInfoKHR)* pImportFenceFdInfo);
alias PFN_vkGetFenceFdKHR = VkResult function(VkDevice device, const(VkFenceGetFdInfoKHR)* pGetFdInfo, int* pFd);

version (VK_KHR_external_fence_fd) {
    VkResult vkImportFenceFdKHR(VkDevice device, const(VkImportFenceFdInfoKHR)* pImportFenceFdInfo);
    VkResult vkGetFenceFdKHR(VkDevice device, const(VkFenceGetFdInfoKHR)* pGetFdInfo, int* pFd);
}
