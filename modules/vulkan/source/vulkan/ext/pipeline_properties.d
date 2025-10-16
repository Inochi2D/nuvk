/**
 * VK_EXT_pipeline_properties
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.pipeline_properties;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.pipeline_executable_properties;

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

struct VK_EXT_pipeline_properties {
    
    @VkProcName("vkGetPipelinePropertiesEXT")
    PFN_vkGetPipelinePropertiesEXT vkGetPipelinePropertiesEXT;
}

enum VK_EXT_PIPELINE_PROPERTIES_SPEC_VERSION = 1;
enum VK_EXT_PIPELINE_PROPERTIES_EXTENSION_NAME = "VK_EXT_pipeline_properties";

alias VkPipelineInfoEXT = VkPipelineInfoKHR;

struct VkPipelinePropertiesIdentifierEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_PROPERTIES_IDENTIFIER_EXT;
    void* pNext;
    ubyte[VK_UUID_SIZE] pipelineIdentifier;
}

struct VkPhysicalDevicePipelinePropertiesFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_PROPERTIES_FEATURES_EXT;
    void* pNext;
    VkBool32 pipelinePropertiesIdentifier;
}

alias PFN_vkGetPipelinePropertiesEXT = VkResult function(
    VkDevice device,
    const(VkPipelineInfoEXT)* pPipelineInfo,
    VkBaseOutStructure* pPipelineProperties,
);
