/**
 * VK_KHR_external_memory_win32 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     Microsoft Win32 API (also refers to Win64 apps)
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_memory_win32;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.windows;

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
version (Windows):

struct VK_KHR_external_memory_win32 {
    
    @VkProcName("vkGetMemoryWin32HandleKHR")
    PFN_vkGetMemoryWin32HandleKHR vkGetMemoryWin32HandleKHR;
    
    @VkProcName("vkGetMemoryWin32HandlePropertiesKHR")
    PFN_vkGetMemoryWin32HandlePropertiesKHR vkGetMemoryWin32HandlePropertiesKHR;
}

enum VK_KHR_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_KHR_external_memory_win32";

struct VkImportMemoryWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagBits handleType;
    HANDLE handle;
    LPCWSTR name;
}

struct VkExportMemoryWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    DWORD dwAccess;
    LPCWSTR name;
}

struct VkMemoryWin32HandlePropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
    void* pNext;
    uint memoryTypeBits;
}

struct VkMemoryGetWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlagBits handleType;
}

alias PFN_vkGetMemoryWin32HandleKHR = VkResult function(
    VkDevice device,
    const(VkMemoryGetWin32HandleInfoKHR)* pGetWin32HandleInfo,
    HANDLE* pHandle,
);

alias PFN_vkGetMemoryWin32HandlePropertiesKHR = VkResult function(
    VkDevice device,
    VkExternalMemoryHandleTypeFlagBits handleType,
    HANDLE handle,
    VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties,
);
