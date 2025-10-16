/**
 * VK_EXT_multi_draw (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.multi_draw;

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

struct VK_EXT_multi_draw {
    
    @VkProcName("vkCmdDrawMultiEXT")
    PFN_vkCmdDrawMultiEXT vkCmdDrawMultiEXT;
    
    @VkProcName("vkCmdDrawMultiIndexedEXT")
    PFN_vkCmdDrawMultiIndexedEXT vkCmdDrawMultiIndexedEXT;
}

enum VK_EXT_MULTI_DRAW_SPEC_VERSION = 1;
enum VK_EXT_MULTI_DRAW_EXTENSION_NAME = "VK_EXT_multi_draw";

struct VkPhysicalDeviceMultiDrawFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTI_DRAW_FEATURES_EXT;
    void* pNext;
    VkBool32 multiDraw;
}

struct VkPhysicalDeviceMultiDrawPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTI_DRAW_PROPERTIES_EXT;
    void* pNext;
    uint maxMultiDrawCount;
}

struct VkMultiDrawInfoEXT {
    uint firstVertex;
    uint vertexCount;
}

struct VkMultiDrawIndexedInfoEXT {
    uint firstIndex;
    uint indexCount;
    int vertexOffset;
}

alias PFN_vkCmdDrawMultiEXT = void function(
    VkCommandBuffer commandBuffer,
    uint drawCount,
    const(VkMultiDrawInfoEXT)* pVertexInfo,
    uint instanceCount,
    uint firstInstance,
    uint stride,
);

alias PFN_vkCmdDrawMultiIndexedEXT = void function(
    VkCommandBuffer commandBuffer,
    uint drawCount,
    const(VkMultiDrawIndexedInfoEXT)* pIndexInfo,
    uint instanceCount,
    uint firstInstance,
    uint stride,
    const(int)* pVertexOffset,
);
