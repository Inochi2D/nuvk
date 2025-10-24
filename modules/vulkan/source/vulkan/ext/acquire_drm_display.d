/**
 * VK_EXT_acquire_drm_display (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.acquire_drm_display;

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

public import vulkan.ext.direct_mode_display;

struct VK_EXT_acquire_drm_display {
    @VkProcName("vkAcquireDrmDisplayEXT")
    PFN_vkAcquireDrmDisplayEXT vkAcquireDrmDisplayEXT;
    
    @VkProcName("vkGetDrmDisplayEXT")
    PFN_vkGetDrmDisplayEXT vkGetDrmDisplayEXT;
}

enum VK_EXT_ACQUIRE_DRM_DISPLAY_SPEC_VERSION = 1;
enum VK_EXT_ACQUIRE_DRM_DISPLAY_EXTENSION_NAME = "VK_EXT_acquire_drm_display";

import vulkan.khr.display : VkDisplayKHR;
alias PFN_vkAcquireDrmDisplayEXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    int drmFd,
    VkDisplayKHR display,
);

import vulkan.khr.display : VkDisplayKHR;
alias PFN_vkGetDrmDisplayEXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    int drmFd,
    uint connectorId,
    ref VkDisplayKHR display,
);
