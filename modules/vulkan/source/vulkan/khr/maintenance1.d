/**
 * VK_KHR_maintenance1 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance1;

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

struct VK_KHR_maintenance1 {
    @VkProcName("vkTrimCommandPool")
    PFN_vkTrimCommandPool vkTrimCommandPool;
}

enum VK_KHR_MAINTENANCE_1_SPEC_VERSION = 2;
enum VK_KHR_MAINTENANCE_1_EXTENSION_NAME = "VK_KHR_maintenance1";
deprecated("aliased")
enum VK_KHR_MAINTENANCE1_SPEC_VERSION = VK_KHR_MAINTENANCE_1_SPEC_VERSION;
deprecated("aliased")
enum VK_KHR_MAINTENANCE1_EXTENSION_NAME = VK_KHR_MAINTENANCE_1_EXTENSION_NAME;

alias VkCommandPoolTrimFlagsKHR = VkCommandPoolTrimFlags;

alias PFN_vkTrimCommandPool = void function(
    VkDevice device,
    VkCommandPool commandPool,
    VkCommandPoolTrimFlags flags,
);
