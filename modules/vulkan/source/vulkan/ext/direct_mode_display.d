/**
 * VK_EXT_direct_mode_display (Instance)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.direct_mode_display;

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

public import vulkan.khr.display;

struct VK_EXT_direct_mode_display {
    
    @VkProcName("vkReleaseDisplayEXT")
    PFN_vkReleaseDisplayEXT vkReleaseDisplayEXT;
}

enum VK_EXT_DIRECT_MODE_DISPLAY_SPEC_VERSION = 1;
enum VK_EXT_DIRECT_MODE_DISPLAY_EXTENSION_NAME = "VK_EXT_direct_mode_display";

alias PFN_vkReleaseDisplayEXT = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayKHR display,
);
