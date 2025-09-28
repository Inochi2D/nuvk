/**
    VK_KHR_external_fence_fd
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.external_fence_win32;
import vulkan.khr.external_memory;
import vulkan.khr.external_fence;
import vulkan.win32;
import vulkan.core;

extern (System) @nogc nothrow:
enum uint VK_KHR_EXTERNAL_FENCE_WIN32_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_FENCE_WIN32_EXTENSION_NAME = "VK_KHR_external_fence_win32";

struct VkImportFenceWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkFenceImportFlags flags;
    VkExternalFenceHandleTypeFlags handleType;
    void* handle;
    const(wchar)* name;
}

struct VkExportFenceWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    uint dwAccess;
    const(wchar)* name;
}

struct VkFenceGetWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkExternalFenceHandleTypeFlags handleType;
}

alias PFN_vkImportFenceWin32HandleKHR = VkResult function(VkDevice device, const(
        VkImportFenceWin32HandleInfoKHR)* pImportFenceWin32HandleInfo);
alias PFN_vkGetFenceWin32HandleKHR = VkResult function(VkDevice device, const(
        VkFenceGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);

version (VK_KHR_external_fence_win32) {
    VkResult vkImportFenceWin32HandleKHR(VkDevice device, const(VkImportFenceWin32HandleInfoKHR)* pImportFenceWin32HandleInfo);
    VkResult vkGetFenceWin32HandleKHR(VkDevice device, const(VkFenceGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);
}
