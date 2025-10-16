/**
 * VK_EXT_vertex_attribute_divisor (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.vertex_attribute_divisor;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.vertex_attribute_divisor;

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

enum VK_EXT_VERTEX_ATTRIBUTE_DIVISOR_SPEC_VERSION = 3;
enum VK_EXT_VERTEX_ATTRIBUTE_DIVISOR_EXTENSION_NAME = "VK_EXT_vertex_attribute_divisor";

struct VkPhysicalDeviceVertexAttributeDivisorPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT;
    void* pNext;
    uint maxVertexAttribDivisor;
}

alias VkVertexInputBindingDivisorDescriptionEXT = VkVertexInputBindingDivisorDescription;

alias VkPipelineVertexInputDivisorStateCreateInfoEXT = VkPipelineVertexInputDivisorStateCreateInfo;

alias VkPhysicalDeviceVertexAttributeDivisorFeaturesEXT = VkPhysicalDeviceVertexAttributeDivisorFeatures;
