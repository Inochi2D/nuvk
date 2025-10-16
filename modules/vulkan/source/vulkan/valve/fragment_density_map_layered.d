/**
 * VK_VALVE_fragment_density_map_layered
 * 
 * Author:
 *     Valve Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.valve.fragment_density_map_layered;

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
version (VK_VERSION_1_4) {} else {
    public import vulkan.khr.maintenance5;
}

enum VK_VALVE_FRAGMENT_DENSITY_MAP_LAYERED_SPEC_VERSION = 1;
enum VK_VALVE_FRAGMENT_DENSITY_MAP_LAYERED_EXTENSION_NAME = "VK_VALVE_fragment_density_map_layered";

struct VkPhysicalDeviceFragmentDensityMapLayeredFeaturesVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_LAYERED_FEATURES_VALVE;
    void* pNext;
    VkBool32 fragmentDensityMapLayered;
}

struct VkPhysicalDeviceFragmentDensityMapLayeredPropertiesVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_LAYERED_PROPERTIES_VALVE;
    void* pNext;
    uint maxFragmentDensityMapLayers;
}

struct VkPipelineFragmentDensityMapLayeredCreateInfoVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_FRAGMENT_DENSITY_MAP_LAYERED_CREATE_INFO_VALVE;
    const(void)* pNext;
    uint maxFragmentDensityMapLayers;
}
