/**
 * VK_EXT_acquire_xlib_display
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Platform:
 *     X Window System, Xlib client library, XRandR extension
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.acquire_xlib_display;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.xrandr;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.ext.direct_mode_display;

struct VK_EXT_acquire_xlib_display {
    
    @VkProcName("vkAcquireXlibDisplayEXT")
    PFN_vkAcquireXlibDisplayEXT vkAcquireXlibDisplayEXT;
    
    @VkProcName("vkGetRandROutputDisplayEXT")
    PFN_vkGetRandROutputDisplayEXT vkGetRandROutputDisplayEXT;
}

enum VK_EXT_ACQUIRE_XLIB_DISPLAY_SPEC_VERSION = 1;
enum VK_EXT_ACQUIRE_XLIB_DISPLAY_EXTENSION_NAME = "VK_EXT_acquire_xlib_display";

alias PFN_vkAcquireXlibDisplayEXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    Display* dpy,
    VkDisplayKHR display,
);

alias PFN_vkGetRandROutputDisplayEXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    Display* dpy,
    RROutput rrOutput,
    VkDisplayKHR* pDisplay,
);
