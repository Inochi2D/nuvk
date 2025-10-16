/**
 * VK_EXT_host_query_reset (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.host_query_reset;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_EXT_host_query_reset {
    
    @VkProcName("vkResetQueryPool")
    PFN_vkResetQueryPool vkResetQueryPool;
}

enum VK_EXT_HOST_QUERY_RESET_SPEC_VERSION = 1;
enum VK_EXT_HOST_QUERY_RESET_EXTENSION_NAME = "VK_EXT_host_query_reset";

alias VkPhysicalDeviceHostQueryResetFeaturesEXT = VkPhysicalDeviceHostQueryResetFeatures;

alias PFN_vkResetQueryPool = void function(
    VkDevice device,
    VkQueryPool queryPool,
    uint firstQuery,
    uint queryCount,
);
