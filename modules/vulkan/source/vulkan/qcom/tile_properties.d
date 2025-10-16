/**
 * VK_QCOM_tile_properties (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.tile_properties;

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

struct VK_QCOM_tile_properties {
    
    @VkProcName("vkGetFramebufferTilePropertiesQCOM")
    PFN_vkGetFramebufferTilePropertiesQCOM vkGetFramebufferTilePropertiesQCOM;
    
    @VkProcName("vkGetDynamicRenderingTilePropertiesQCOM")
    PFN_vkGetDynamicRenderingTilePropertiesQCOM vkGetDynamicRenderingTilePropertiesQCOM;
}

enum VK_QCOM_TILE_PROPERTIES_SPEC_VERSION = 1;
enum VK_QCOM_TILE_PROPERTIES_EXTENSION_NAME = "VK_QCOM_tile_properties";

struct VkPhysicalDeviceTilePropertiesFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_PROPERTIES_FEATURES_QCOM;
    void* pNext;
    VkBool32 tileProperties;
}

struct VkTilePropertiesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TILE_PROPERTIES_QCOM;
    void* pNext;
    VkExtent3D tileSize;
    VkExtent2D apronSize;
    VkOffset2D origin;
}

alias PFN_vkGetFramebufferTilePropertiesQCOM = VkResult function(
    VkDevice device,
    VkFramebuffer framebuffer,
    uint* pPropertiesCount,
    VkTilePropertiesQCOM* pProperties,
);

alias PFN_vkGetDynamicRenderingTilePropertiesQCOM = VkResult function(
    VkDevice device,
    const(VkRenderingInfo)* pRenderingInfo,
    VkTilePropertiesQCOM* pProperties,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

alias VkRenderingInfoKHR = VkRenderingInfo;
