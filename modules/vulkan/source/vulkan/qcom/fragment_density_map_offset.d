/**
 * VK_QCOM_fragment_density_map_offset
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.fragment_density_map_offset;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.ext.fragment_density_map_offset;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.ext.fragment_density_map;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_QCOM_FRAGMENT_DENSITY_MAP_OFFSET_SPEC_VERSION = 3;
enum VK_QCOM_FRAGMENT_DENSITY_MAP_OFFSET_EXTENSION_NAME = "VK_QCOM_fragment_density_map_offset";

alias VkPhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM = VkPhysicalDeviceFragmentDensityMapOffsetFeaturesEXT;

alias VkPhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM = VkPhysicalDeviceFragmentDensityMapOffsetPropertiesEXT;

alias VkSubpassFragmentDensityMapOffsetEndInfoQCOM = VkRenderPassFragmentDensityMapOffsetEndInfoEXT;
