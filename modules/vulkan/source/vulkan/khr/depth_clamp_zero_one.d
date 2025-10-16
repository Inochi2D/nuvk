/**
 * VK_KHR_depth_clamp_zero_one
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.depth_clamp_zero_one;

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

enum VK_KHR_DEPTH_CLAMP_ZERO_ONE_SPEC_VERSION = 1;
enum VK_KHR_DEPTH_CLAMP_ZERO_ONE_EXTENSION_NAME = "VK_KHR_depth_clamp_zero_one";

struct VkPhysicalDeviceDepthClampZeroOneFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLAMP_ZERO_ONE_FEATURES_KHR;
    void* pNext;
    VkBool32 depthClampZeroOne;
}
