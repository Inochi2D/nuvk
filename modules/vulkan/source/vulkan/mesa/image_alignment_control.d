/**
 * VK_MESA_image_alignment_control
 * 
 * Author:
 *     Mesa open source project
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.mesa.image_alignment_control;

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

enum VK_MESA_IMAGE_ALIGNMENT_CONTROL_SPEC_VERSION = 1;
enum VK_MESA_IMAGE_ALIGNMENT_CONTROL_EXTENSION_NAME = "VK_MESA_image_alignment_control";

struct VkPhysicalDeviceImageAlignmentControlFeaturesMESA {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ALIGNMENT_CONTROL_FEATURES_MESA;
    void* pNext;
    VkBool32 imageAlignmentControl;
}

struct VkPhysicalDeviceImageAlignmentControlPropertiesMESA {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ALIGNMENT_CONTROL_PROPERTIES_MESA;
    void* pNext;
    uint supportedImageAlignmentMask;
}

struct VkImageAlignmentControlCreateInfoMESA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_ALIGNMENT_CONTROL_CREATE_INFO_MESA;
    const(void)* pNext;
    uint maximumRequestedAlignment;
}
