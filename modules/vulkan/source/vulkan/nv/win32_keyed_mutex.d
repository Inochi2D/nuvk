/**
 * VK_NV_win32_keyed_mutex
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
module vulkan.nv.win32_keyed_mutex;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.win32_keyed_mutex;
import vulkan.platforms.windows;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.nv.external_memory_win32;
version (Windows):

enum VK_NV_WIN32_KEYED_MUTEX_SPEC_VERSION = 2;
enum VK_NV_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_NV_win32_keyed_mutex";

struct VkWin32KeyedMutexAcquireReleaseInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
    const(void)* pNext;
    uint acquireCount;
    const(VkDeviceMemory)* pAcquireSyncs;
    const(ulong)* pAcquireKeys;
    const(uint)* pAcquireTimeoutMilliseconds;
    uint releaseCount;
    const(VkDeviceMemory)* pReleaseSyncs;
    const(ulong)* pReleaseKeys;
}
