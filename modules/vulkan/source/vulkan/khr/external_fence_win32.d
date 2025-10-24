/**
 * VK_KHR_external_fence_win32 (Device)
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
module vulkan.khr.external_fence_win32;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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

public import vulkan.khr.external_fence;
version (Windows):

struct VK_KHR_external_fence_win32 {
    @VkProcName("vkImportFenceWin32HandleKHR")
    PFN_vkImportFenceWin32HandleKHR vkImportFenceWin32HandleKHR;
    
    @VkProcName("vkGetFenceWin32HandleKHR")
    PFN_vkGetFenceWin32HandleKHR vkGetFenceWin32HandleKHR;
}

enum VK_KHR_EXTERNAL_FENCE_WIN32_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_FENCE_WIN32_EXTENSION_NAME = "VK_KHR_external_fence_win32";

struct VkImportFenceWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkFenceImportFlags flags;
    VkExternalFenceHandleTypeFlags handleType;
    HANDLE handle;
    LPCWSTR name;
}

struct VkExportFenceWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    DWORD dwAccess;
    LPCWSTR name;
}

struct VkFenceGetWin32HandleInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
    const(void)* pNext;
    VkFence fence;
    VkExternalFenceHandleTypeFlags handleType;
}

alias PFN_vkImportFenceWin32HandleKHR = VkResult function(
    VkDevice device,
    const(VkImportFenceWin32HandleInfoKHR)* pImportFenceWin32HandleInfo,
);

alias PFN_vkGetFenceWin32HandleKHR = VkResult function(
    VkDevice device,
    const(VkFenceGetWin32HandleInfoKHR)* pGetWin32HandleInfo,
    HANDLE* pHandle,
);
