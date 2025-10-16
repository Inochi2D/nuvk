/**
 * VK_EXT_filter_cubic (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.filter_cubic;

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

enum VK_EXT_FILTER_CUBIC_SPEC_VERSION = 3;
enum VK_EXT_FILTER_CUBIC_EXTENSION_NAME = "VK_EXT_filter_cubic";

struct VkPhysicalDeviceImageViewImageFormatInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_VIEW_IMAGE_FORMAT_INFO_EXT;
    void* pNext;
    VkImageViewType imageViewType;
}

struct VkFilterCubicImageViewImageFormatPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_FILTER_CUBIC_IMAGE_VIEW_IMAGE_FORMAT_PROPERTIES_EXT;
    void* pNext;
    VkBool32 filterCubic;
    VkBool32 filterCubicMinmax;
}
