/**
 * VK_NV_corner_sampled_image (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.corner_sampled_image;

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

enum VK_NV_CORNER_SAMPLED_IMAGE_SPEC_VERSION = 2;
enum VK_NV_CORNER_SAMPLED_IMAGE_EXTENSION_NAME = "VK_NV_corner_sampled_image";

struct VkPhysicalDeviceCornerSampledImageFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CORNER_SAMPLED_IMAGE_FEATURES_NV;
    void* pNext;
    VkBool32 cornerSampledImage;
}
