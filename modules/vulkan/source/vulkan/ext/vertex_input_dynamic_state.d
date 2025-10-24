/**
 * VK_EXT_vertex_input_dynamic_state (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.vertex_input_dynamic_state;

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

struct VK_EXT_vertex_input_dynamic_state {
    @VkProcName("vkCmdSetVertexInputEXT")
    PFN_vkCmdSetVertexInputEXT vkCmdSetVertexInputEXT;
}

enum VK_EXT_VERTEX_INPUT_DYNAMIC_STATE_SPEC_VERSION = 2;
enum VK_EXT_VERTEX_INPUT_DYNAMIC_STATE_EXTENSION_NAME = "VK_EXT_vertex_input_dynamic_state";

struct VkPhysicalDeviceVertexInputDynamicStateFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_INPUT_DYNAMIC_STATE_FEATURES_EXT;
    void* pNext;
    VkBool32 vertexInputDynamicState;
}

struct VkVertexInputBindingDescription2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VERTEX_INPUT_BINDING_DESCRIPTION_2_EXT;
    void* pNext;
    uint binding;
    uint stride;
    VkVertexInputRate inputRate;
    uint divisor;
}

struct VkVertexInputAttributeDescription2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VERTEX_INPUT_ATTRIBUTE_DESCRIPTION_2_EXT;
    void* pNext;
    uint location;
    uint binding;
    VkFormat format;
    uint offset;
}

alias PFN_vkCmdSetVertexInputEXT = void function(
    VkCommandBuffer commandBuffer,
    uint vertexBindingDescriptionCount,
    const(VkVertexInputBindingDescription2EXT)* pVertexBindingDescriptions,
    uint vertexAttributeDescriptionCount,
    const(VkVertexInputAttributeDescription2EXT)* pVertexAttributeDescriptions,
);
