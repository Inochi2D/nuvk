/**
    VK_KHR_external_memory_win32
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_external_memory_win32;
import vulkan.khr_external_memory;
import vulkan.win32;
import vulkan.core;

extern (System) @nogc nothrow:

enum VK_KHR_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_KHR_external_memory_win32";

struct VkImportMemoryWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlags handleType;
    void* handle;
    const(wchar)* name;
}

struct VkExportMemoryWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    uint dwAccess;
    const(wchar)* name;
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
    VkExternalMemoryHandleTypeFlags handleType;
}

alias PFN_vkGetMemoryWin32HandleKHR = VkResult function(VkDevice device, const(VkMemoryGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);
alias PFN_vkGetMemoryWin32HandlePropertiesKHR = VkResult function(VkDevice device, VkExternalMemoryHandleTypeFlags handleType, void* handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties);

version(VK_KHR_external_memory_win32) {
    VkResult vkGetMemoryWin32HandleKHR(VkDevice device, const(VkMemoryGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);
    VkResult vkGetMemoryWin32HandlePropertiesKHR(VkDevice device, VkExternalMemoryHandleTypeFlags handleType, void* handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties);
}