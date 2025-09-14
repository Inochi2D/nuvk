/**
    VK_KHR_external_memory_fd
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_external_memory_fd;
import vulkan.khr_external_memory;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_MEMORY_FD_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_MEMORY_FD_EXTENSION_NAME = "VK_KHR_external_memory_fd";

struct VkImportMemoryFdInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlags handleType;
    int fd;
}

struct VkMemoryFdPropertiesKHR {
    VkStructureType sType;
    void* pNext;
    uint memoryTypeBits;
}

struct VkMemoryGetFdInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlags handleType;
}

alias PFN_vkGetMemoryFdKHR = VkResult function(VkDevice device, const(VkMemoryGetFdInfoKHR)* pGetFdInfo, int* pFd);
alias PFN_vkGetMemoryFdPropertiesKHR = VkResult function(VkDevice device, VkExternalMemoryHandleTypeFlags handleType, int fd, VkMemoryFdPropertiesKHR* pMemoryFdProperties);

version(VK_KHR_external_memory_fd) {
    VkResult vkGetMemoryFdKHR(VkDevice device, const(VkMemoryGetFdInfoKHR)* pGetFdInfo, int* pFd);
    VkResult vkGetMemoryFdPropertiesKHR(VkDevice device, VkExternalMemoryHandleTypeFlags handleType, int fd, VkMemoryFdPropertiesKHR* pMemoryFdProperties);
}