/**
 * VK_NV_present_metering (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.present_metering;

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

enum VK_NV_PRESENT_METERING_SPEC_VERSION = 1;
enum VK_NV_PRESENT_METERING_EXTENSION_NAME = "VK_NV_present_metering";

struct VkSetPresentConfigNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_SET_PRESENT_CONFIG_NV;
    const(void)* pNext;
    uint numFramesPerBatch;
    uint presentConfigFeedback;
}

struct VkPhysicalDevicePresentMeteringFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_METERING_FEATURES_NV;
    void* pNext;
    VkBool32 presentMetering;
}
