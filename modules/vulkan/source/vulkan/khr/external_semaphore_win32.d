/**
 * VK_KHR_external_semaphore_win32 (Device)
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
module vulkan.khr.external_semaphore_win32;

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

public import vulkan.khr.external_semaphore;
version (Windows):

struct VK_KHR_external_semaphore_win32 {
    
    @VkProcName("vkImportSemaphoreWin32HandleKHR")
    PFN_vkImportSemaphoreWin32HandleKHR vkImportSemaphoreWin32HandleKHR;
    
    @VkProcName("vkGetSemaphoreWin32HandleKHR")
    PFN_vkGetSemaphoreWin32HandleKHR vkGetSemaphoreWin32HandleKHR;
}

enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32";

struct VkImportSemaphoreWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkFlags flags;
    VkExternalSemaphoreHandleTypeFlagBits handleType;
    HANDLE handle;
    LPCWSTR name;
}

struct VkExportSemaphoreWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    DWORD dwAccess;
    LPCWSTR name;
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
    VkExternalSemaphoreHandleTypeFlagBits handleType;
}

alias PFN_vkImportSemaphoreWin32HandleKHR = VkResult function(
    VkDevice device,
    const(VkImportSemaphoreWin32HandleInfoKHR)* pImportSemaphoreWin32HandleInfo,
);

alias PFN_vkGetSemaphoreWin32HandleKHR = VkResult function(
    VkDevice device,
    const(VkSemaphoreGetWin32HandleInfoKHR)* pGetWin32HandleInfo,
    HANDLE* pHandle,
);
