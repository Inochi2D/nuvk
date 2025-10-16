/**
 * VK_EXT_fragment_density_map_offset (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.fragment_density_map_offset;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.create_renderpass2;
}
public import vulkan.ext.fragment_density_map;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_EXT_fragment_density_map_offset {
    
    @VkProcName("vkCmdEndRendering2EXT")
    PFN_vkCmdEndRendering2EXT vkCmdEndRendering2EXT;
}

enum VK_EXT_FRAGMENT_DENSITY_MAP_OFFSET_SPEC_VERSION = 1;
enum VK_EXT_FRAGMENT_DENSITY_MAP_OFFSET_EXTENSION_NAME = "VK_EXT_fragment_density_map_offset";

struct VkRenderingEndInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDERING_END_INFO_EXT;
    const(void)* pNext;
}

struct VkPhysicalDeviceFragmentDensityMapOffsetFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_OFFSET_FEATURES_EXT;
    void* pNext;
    VkBool32 fragmentDensityMapOffset;
}

struct VkPhysicalDeviceFragmentDensityMapOffsetPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_OFFSET_PROPERTIES_EXT;
    void* pNext;
    VkExtent2D fragmentDensityOffsetGranularity;
}

struct VkRenderPassFragmentDensityMapOffsetEndInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_OFFSET_END_INFO_EXT;
    const(void)* pNext;
    uint fragmentDensityOffsetCount;
    const(VkOffset2D)* pFragmentDensityOffsets;
}

alias PFN_vkCmdEndRendering2EXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkRenderingEndInfoEXT)* pRenderingEndInfo,
);
