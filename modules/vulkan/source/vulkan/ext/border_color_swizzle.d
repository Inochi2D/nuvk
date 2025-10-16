/**
 * VK_EXT_border_color_swizzle
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.border_color_swizzle;

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

public import vulkan.ext.custom_border_color;

enum VK_EXT_BORDER_COLOR_SWIZZLE_SPEC_VERSION = 1;
enum VK_EXT_BORDER_COLOR_SWIZZLE_EXTENSION_NAME = "VK_EXT_border_color_swizzle";

struct VkPhysicalDeviceBorderColorSwizzleFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BORDER_COLOR_SWIZZLE_FEATURES_EXT;
    void* pNext;
    VkBool32 borderColorSwizzle;
    VkBool32 borderColorSwizzleFromImage;
}

struct VkSamplerBorderColorComponentMappingCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLER_BORDER_COLOR_COMPONENT_MAPPING_CREATE_INFO_EXT;
    const(void)* pNext;
    VkComponentMapping components;
    VkBool32 srgb;
}
