/**
    VK_KHR_external_semaphore_win32
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_external_semaphore_win32;
import vulkan.khr_external_memory;
import vulkan.win32;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32";

struct VkImportSemaphoreWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkSemaphoreImportFlags flags;
    VkExternalSemaphoreHandleTypeFlags handleType;
    void* handle;
    const(wchar)* name;
}

struct VkExportSemaphoreWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    uint dwAccess;
    const(wchar)* name;
}

struct VkD3D12FenceSubmitInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR;
    const(void)* pNext;
    uint waitSemaphoreValuesCount;
    const(ulong)* pWaitSemaphoreValues;
    uint signalSemaphoreValuesCount;
    const(ulong)* pSignalSemaphoreValues;
}

struct VkSemaphoreGetWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkExternalSemaphoreHandleTypeFlags handleType;
}

alias PFN_vkImportSemaphoreWin32HandleKHR = VkResult function(VkDevice device, const(
        VkImportSemaphoreWin32HandleInfoKHR)* pImportSemaphoreWin32HandleInfo);
alias PFN_vkGetSemaphoreWin32HandleKHR = VkResult function(VkDevice device, const(
        VkSemaphoreGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);

version (VK_KHR_external_semaphore_win32) {
    VkResult vkImportSemaphoreWin32HandleKHR(VkDevice device, const(
            VkImportSemaphoreWin32HandleInfoKHR)* pImportSemaphoreWin32HandleInfo);
    VkResult vkGetSemaphoreWin32HandleKHR(VkDevice device, const(VkSemaphoreGetWin32HandleInfoKHR)* pGetWin32HandleInfo, void** pHandle);
}
