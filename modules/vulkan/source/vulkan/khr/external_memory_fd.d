/**
 * VK_KHR_external_memory_fd (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_memory_fd;

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
    public import vulkan.khr.external_memory;
}

struct VK_KHR_external_memory_fd {
    
    @VkProcName("vkGetMemoryFdKHR")
    PFN_vkGetMemoryFdKHR vkGetMemoryFdKHR;
    
    @VkProcName("vkGetMemoryFdPropertiesKHR")
    PFN_vkGetMemoryFdPropertiesKHR vkGetMemoryFdPropertiesKHR;
}

enum VK_KHR_EXTERNAL_MEMORY_FD_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_MEMORY_FD_EXTENSION_NAME = "VK_KHR_external_memory_fd";

struct VkImportMemoryFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagBits handleType;
    int fd;
}

struct VkMemoryFdPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR;
    void* pNext;
    uint memoryTypeBits;
}

struct VkMemoryGetFdInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlagBits handleType;
}

alias PFN_vkGetMemoryFdKHR = VkResult function(
    VkDevice device,
    const(VkMemoryGetFdInfoKHR)* pGetFdInfo,
    int* pFd,
);

alias PFN_vkGetMemoryFdPropertiesKHR = VkResult function(
    VkDevice device,
    VkExternalMemoryHandleTypeFlagBits handleType,
    int fd,
    VkMemoryFdPropertiesKHR* pMemoryFdProperties,
);
