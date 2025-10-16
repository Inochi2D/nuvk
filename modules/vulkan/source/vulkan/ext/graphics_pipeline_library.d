/**
 * VK_EXT_graphics_pipeline_library
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.graphics_pipeline_library;

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

public import vulkan.khr.pipeline_library;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_EXT_GRAPHICS_PIPELINE_LIBRARY_SPEC_VERSION = 1;
enum VK_EXT_GRAPHICS_PIPELINE_LIBRARY_EXTENSION_NAME = "VK_EXT_graphics_pipeline_library";

struct VkPhysicalDeviceGraphicsPipelineLibraryFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GRAPHICS_PIPELINE_LIBRARY_FEATURES_EXT;
    void* pNext;
    VkBool32 graphicsPipelineLibrary;
}

struct VkPhysicalDeviceGraphicsPipelineLibraryPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GRAPHICS_PIPELINE_LIBRARY_PROPERTIES_EXT;
    void* pNext;
    VkBool32 graphicsPipelineLibraryFastLinking;
    VkBool32 graphicsPipelineLibraryIndependentInterpolationDecoration;
}

struct VkGraphicsPipelineLibraryCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_LIBRARY_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
}

enum VkGraphicsPipelineLibraryFlagBitsEXT : uint {
    VK_GRAPHICS_PIPELINE_LIBRARY_VERTEX_INPUT_INTERFACE_BIT_EXT = 1,
    VK_GRAPHICS_PIPELINE_LIBRARY_PRE_RASTERIZATION_SHADERS_BIT_EXT = 2,
    VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_SHADER_BIT_EXT = 4,
    VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_OUTPUT_INTERFACE_BIT_EXT = 8,
}

enum VK_GRAPHICS_PIPELINE_LIBRARY_VERTEX_INPUT_INTERFACE_BIT_EXT = VkGraphicsPipelineLibraryFlagBitsEXT.VK_GRAPHICS_PIPELINE_LIBRARY_VERTEX_INPUT_INTERFACE_BIT_EXT;
enum VK_GRAPHICS_PIPELINE_LIBRARY_PRE_RASTERIZATION_SHADERS_BIT_EXT = VkGraphicsPipelineLibraryFlagBitsEXT.VK_GRAPHICS_PIPELINE_LIBRARY_PRE_RASTERIZATION_SHADERS_BIT_EXT;
enum VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_SHADER_BIT_EXT = VkGraphicsPipelineLibraryFlagBitsEXT.VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_SHADER_BIT_EXT;
enum VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_OUTPUT_INTERFACE_BIT_EXT = VkGraphicsPipelineLibraryFlagBitsEXT.VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_OUTPUT_INTERFACE_BIT_EXT;

alias VkGraphicsPipelineLibraryFlagsEXT = VkFlags;

enum VkPipelineLayoutCreateFlagBits : uint {
    RESERVED_0_BIT_AMD = 1,
    INDEPENDENT_SETS_BIT_EXT = 2,
}

enum VK_PIPELINE_LAYOUT_CREATE_RESERVED_0_BIT_AMD = VkPipelineLayoutCreateFlagBits.RESERVED_0_BIT_AMD;
enum VK_PIPELINE_LAYOUT_CREATE_INDEPENDENT_SETS_BIT_EXT = VkPipelineLayoutCreateFlagBits.INDEPENDENT_SETS_BIT_EXT;
