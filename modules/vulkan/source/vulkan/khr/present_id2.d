/**
 * VK_KHR_present_id2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.present_id2;

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

public import vulkan.khr.swapchain;
public import vulkan.khr.surface;
public import vulkan.khr.get_surface_capabilities2;

enum VK_KHR_PRESENT_ID_2_SPEC_VERSION = 1;
enum VK_KHR_PRESENT_ID_2_EXTENSION_NAME = "VK_KHR_present_id2";

struct VkSurfaceCapabilitiesPresentId2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_PRESENT_ID_2_KHR;
    void* pNext;
    VkBool32 presentId2Supported;
}

struct VkPresentId2KHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_ID_2_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(ulong)* pPresentIds;
}

struct VkPhysicalDevicePresentId2FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_ID_2_FEATURES_KHR;
    void* pNext;
    VkBool32 presentId2;
}
