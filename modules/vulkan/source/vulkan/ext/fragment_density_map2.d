/**
 * VK_EXT_fragment_density_map2 (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.fragment_density_map2;

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

public import vulkan.ext.fragment_density_map;

enum VK_EXT_FRAGMENT_DENSITY_MAP_2_SPEC_VERSION = 1;
enum VK_EXT_FRAGMENT_DENSITY_MAP_2_EXTENSION_NAME = "VK_EXT_fragment_density_map2";

struct VkPhysicalDeviceFragmentDensityMap2FeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_2_FEATURES_EXT;
    void* pNext;
    VkBool32 fragmentDensityMapDeferred;
}

struct VkPhysicalDeviceFragmentDensityMap2PropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_2_PROPERTIES_EXT;
    void* pNext;
    VkBool32 subsampledLoads;
    VkBool32 subsampledCoarseReconstructionEarlyAccess;
    uint maxSubsampledArrayLayers;
    uint maxDescriptorSetSubsampledSamplers;
}
