/**
 * VK_KHR_present_id (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.present_id;

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
    public import vulkan.khr.swapchain;
}

enum VK_KHR_PRESENT_ID_SPEC_VERSION = 1;
enum VK_KHR_PRESENT_ID_EXTENSION_NAME = "VK_KHR_present_id";

struct VkPresentIdKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_ID_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(ulong)* pPresentIds;
}

struct VkPhysicalDevicePresentIdFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_ID_FEATURES_KHR;
    void* pNext;
    VkBool32 presentId;
}
