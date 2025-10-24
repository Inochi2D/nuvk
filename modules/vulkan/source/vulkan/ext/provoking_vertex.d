/**
 * VK_EXT_provoking_vertex (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.provoking_vertex;

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

enum VK_EXT_PROVOKING_VERTEX_SPEC_VERSION = 1;
enum VK_EXT_PROVOKING_VERTEX_EXTENSION_NAME = "VK_EXT_provoking_vertex";

struct VkPhysicalDeviceProvokingVertexFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROVOKING_VERTEX_FEATURES_EXT;
    void* pNext;
    VkBool32 provokingVertexLast;
    VkBool32 transformFeedbackPreservesProvokingVertex;
}

struct VkPhysicalDeviceProvokingVertexPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROVOKING_VERTEX_PROPERTIES_EXT;
    void* pNext;
    VkBool32 provokingVertexModePerPipeline;
    VkBool32 transformFeedbackPreservesTriangleFanProvokingVertex;
}

struct VkPipelineRasterizationProvokingVertexStateCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_PROVOKING_VERTEX_STATE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkProvokingVertexModeEXT provokingVertexMode;
}

alias VkProvokingVertexModeEXT = uint;
enum VkProvokingVertexModeEXT
    VK_PROVOKING_VERTEX_MODE_FIRST_VERTEX_EXT = 0,
    VK_PROVOKING_VERTEX_MODE_LAST_VERTEX_EXT = 1;
