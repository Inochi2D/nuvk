/**
 * VK_KHR_index_type_uint8
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.index_type_uint8;

import numem.core.types : OpaqueHandle;
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

enum VK_KHR_INDEX_TYPE_UINT8_SPEC_VERSION = 1;
enum VK_KHR_INDEX_TYPE_UINT8_EXTENSION_NAME = "VK_KHR_index_type_uint8";

alias VkPhysicalDeviceIndexTypeUint8FeaturesKHR = VkPhysicalDeviceIndexTypeUint8Features;
