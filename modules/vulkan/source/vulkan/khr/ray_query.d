/**
 * VK_KHR_ray_query
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.ray_query;

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

public import vulkan.khr.acceleration_structure;
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.spirv_1_4;
}

enum VK_KHR_RAY_QUERY_SPEC_VERSION = 1;
enum VK_KHR_RAY_QUERY_EXTENSION_NAME = "VK_KHR_ray_query";

struct VkPhysicalDeviceRayQueryFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_QUERY_FEATURES_KHR;
    void* pNext;
    VkBool32 rayQuery;
}
