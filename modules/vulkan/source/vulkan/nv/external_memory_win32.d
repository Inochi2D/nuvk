/**
 * VK_NV_external_memory_win32 (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Platform:
 *     Microsoft Win32 API (also refers to Win64 apps)
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.external_memory_win32;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.external_memory_win32;
import vulkan.platforms.windows;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.nv.external_memory;
version (Windows):

struct VK_NV_external_memory_win32 {
    
    @VkProcName("vkGetMemoryWin32HandleNV")
    PFN_vkGetMemoryWin32HandleNV vkGetMemoryWin32HandleNV;
}

enum VK_NV_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
enum VK_NV_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_NV_external_memory_win32";

import vulkan.nv.external_memory_capabilities : VkExternalMemoryHandleTypeFlagsNV;
struct VkImportMemoryWin32HandleInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
    const(void)* pNext;
    VkFlags handleType;
    HANDLE handle;
}

struct VkExportMemoryWin32HandleInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
    const(void)* pNext;
    const(SECURITY_ATTRIBUTES)* pAttributes;
    DWORD dwAccess;
}

import vulkan.nv.external_memory_capabilities : VkExternalMemoryHandleTypeFlagsNV;
alias PFN_vkGetMemoryWin32HandleNV = VkResult function(
    VkDevice device,
    VkDeviceMemory memory,
    VkExternalMemoryHandleTypeFlagsNV handleType,
    HANDLE* pHandle,
);
