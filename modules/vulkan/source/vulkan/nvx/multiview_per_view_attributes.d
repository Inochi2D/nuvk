/**
 * VK_NVX_multiview_per_view_attributes
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nvx.multiview_per_view_attributes;

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
    public import vulkan.khr.multiview;
}

enum VK_NVX_MULTIVIEW_PER_VIEW_ATTRIBUTES_SPEC_VERSION = 1;
enum VK_NVX_MULTIVIEW_PER_VIEW_ATTRIBUTES_EXTENSION_NAME = "VK_NVX_multiview_per_view_attributes";

struct VkPhysicalDeviceMultiviewPerViewAttributesPropertiesNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_ATTRIBUTES_PROPERTIES_NVX;
    void* pNext;
    VkBool32 perViewPositionAllComponents;
}

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

struct VkMultiviewPerViewAttributesInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_MULTIVIEW_PER_VIEW_ATTRIBUTES_INFO_NVX;
    const(void)* pNext;
    VkBool32 perViewAttributes;
    VkBool32 perViewAttributesPositionXOnly;
}
