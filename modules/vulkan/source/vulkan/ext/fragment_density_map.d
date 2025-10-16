/**
 * VK_EXT_fragment_density_map (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.fragment_density_map;

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

enum VK_EXT_FRAGMENT_DENSITY_MAP_SPEC_VERSION = 2;
enum VK_EXT_FRAGMENT_DENSITY_MAP_EXTENSION_NAME = "VK_EXT_fragment_density_map";

struct VkPhysicalDeviceFragmentDensityMapFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_FEATURES_EXT;
    void* pNext;
    VkBool32 fragmentDensityMap;
    VkBool32 fragmentDensityMapDynamic;
    VkBool32 fragmentDensityMapNonSubsampledImages;
}

struct VkPhysicalDeviceFragmentDensityMapPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_PROPERTIES_EXT;
    void* pNext;
    VkExtent2D minFragmentDensityTexelSize;
    VkExtent2D maxFragmentDensityTexelSize;
    VkBool32 fragmentDensityInvocations;
}

struct VkRenderPassFragmentDensityMapCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_CREATE_INFO_EXT;
    const(void)* pNext;
    VkAttachmentReference fragmentDensityMapAttachment;
}

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

struct VkRenderingFragmentDensityMapAttachmentInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDERING_FRAGMENT_DENSITY_MAP_ATTACHMENT_INFO_EXT;
    const(void)* pNext;
    VkImageView imageView;
    VkImageLayout imageLayout;
}
