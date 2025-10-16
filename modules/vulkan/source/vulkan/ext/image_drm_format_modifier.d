/**
 * VK_EXT_image_drm_format_modifier
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.image_drm_format_modifier;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.image_format_list;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.sampler_ycbcr_conversion;
        public import vulkan.khr.get_physical_device_properties2;
        public import vulkan.khr.bind_memory2;
    }
}

struct VK_EXT_image_drm_format_modifier {
    
    @VkProcName("vkGetImageDrmFormatModifierPropertiesEXT")
    PFN_vkGetImageDrmFormatModifierPropertiesEXT vkGetImageDrmFormatModifierPropertiesEXT;
}

enum VK_EXT_IMAGE_DRM_FORMAT_MODIFIER_SPEC_VERSION = 2;
enum VK_EXT_IMAGE_DRM_FORMAT_MODIFIER_EXTENSION_NAME = "VK_EXT_image_drm_format_modifier";

struct VkDrmFormatModifierPropertiesListEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_EXT;
    void* pNext;
    uint drmFormatModifierCount;
    VkDrmFormatModifierPropertiesEXT* pDrmFormatModifierProperties;
}

struct VkDrmFormatModifierPropertiesEXT {
    ulong drmFormatModifier;
    uint drmFormatModifierPlaneCount;
    VkFlags drmFormatModifierTilingFeatures;
}

struct VkPhysicalDeviceImageDrmFormatModifierInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT;
    const(void)* pNext;
    ulong drmFormatModifier;
    VkSharingMode sharingMode;
    uint queueFamilyIndexCount;
    const(uint)* pQueueFamilyIndices;
}

struct VkImageDrmFormatModifierListCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_LIST_CREATE_INFO_EXT;
    const(void)* pNext;
    uint drmFormatModifierCount;
    const(ulong)* pDrmFormatModifiers;
}

struct VkImageDrmFormatModifierExplicitCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT;
    const(void)* pNext;
    ulong drmFormatModifier;
    uint drmFormatModifierPlaneCount;
    const(VkSubresourceLayout)* pPlaneLayouts;
}

struct VkImageDrmFormatModifierPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT;
    void* pNext;
    ulong drmFormatModifier;
}

alias PFN_vkGetImageDrmFormatModifierPropertiesEXT = VkResult function(
    VkDevice device,
    VkImage image,
    VkImageDrmFormatModifierPropertiesEXT* pProperties,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.format_feature_flags2;
}

struct VkDrmFormatModifierPropertiesList2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_2_EXT;
    void* pNext;
    uint drmFormatModifierCount;
    VkDrmFormatModifierProperties2EXT* pDrmFormatModifierProperties;
}

struct VkDrmFormatModifierProperties2EXT {
    ulong drmFormatModifier;
    uint drmFormatModifierPlaneCount;
    VkFlags64 drmFormatModifierTilingFeatures;
}
