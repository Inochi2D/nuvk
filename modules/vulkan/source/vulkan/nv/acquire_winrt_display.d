/**
 * VK_NV_acquire_winrt_display (Device)
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
module vulkan.nv.acquire_winrt_display;

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

public import vulkan.ext.direct_mode_display;
version (Windows):

struct VK_NV_acquire_winrt_display {
    
    @VkProcName("vkAcquireWinrtDisplayNV")
    PFN_vkAcquireWinrtDisplayNV vkAcquireWinrtDisplayNV;
    
    @VkProcName("vkGetWinrtDisplayNV")
    PFN_vkGetWinrtDisplayNV vkGetWinrtDisplayNV;
}

enum VK_NV_ACQUIRE_WINRT_DISPLAY_SPEC_VERSION = 1;
enum VK_NV_ACQUIRE_WINRT_DISPLAY_EXTENSION_NAME = "VK_NV_acquire_winrt_display";

alias PFN_vkAcquireWinrtDisplayNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayKHR display,
);

alias PFN_vkGetWinrtDisplayNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint deviceRelativeId,
    VkDisplayKHR* pDisplay,
);
