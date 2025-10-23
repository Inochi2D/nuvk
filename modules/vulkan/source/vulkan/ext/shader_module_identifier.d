/**
 * VK_EXT_shader_module_identifier (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.shader_module_identifier;

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
    public import vulkan.ext.pipeline_creation_cache_control;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_EXT_shader_module_identifier {
    @VkProcName("vkGetShaderModuleIdentifierEXT")
    PFN_vkGetShaderModuleIdentifierEXT vkGetShaderModuleIdentifierEXT;
    
    @VkProcName("vkGetShaderModuleCreateInfoIdentifierEXT")
    PFN_vkGetShaderModuleCreateInfoIdentifierEXT vkGetShaderModuleCreateInfoIdentifierEXT;
}

enum VK_EXT_SHADER_MODULE_IDENTIFIER_SPEC_VERSION = 1;
enum VK_EXT_SHADER_MODULE_IDENTIFIER_EXTENSION_NAME = "VK_EXT_shader_module_identifier";
enum uint VK_MAX_SHADER_MODULE_IDENTIFIER_SIZE_EXT = 32;

struct VkPhysicalDeviceShaderModuleIdentifierFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MODULE_IDENTIFIER_FEATURES_EXT;
    void* pNext;
    VkBool32 shaderModuleIdentifier;
}

struct VkPhysicalDeviceShaderModuleIdentifierPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MODULE_IDENTIFIER_PROPERTIES_EXT;
    void* pNext;
    ubyte[VK_UUID_SIZE] shaderModuleIdentifierAlgorithmUUID;
}

struct VkPipelineShaderStageModuleIdentifierCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_MODULE_IDENTIFIER_CREATE_INFO_EXT;
    const(void)* pNext;
    uint identifierSize;
    const(ubyte)* pIdentifier;
}

struct VkShaderModuleIdentifierEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SHADER_MODULE_IDENTIFIER_EXT;
    void* pNext;
    uint identifierSize;
    ubyte[VK_MAX_SHADER_MODULE_IDENTIFIER_SIZE_EXT] identifier;
}

alias PFN_vkGetShaderModuleIdentifierEXT = void function(
    VkDevice device,
    VkShaderModule shaderModule,
    VkShaderModuleIdentifierEXT* pIdentifier,
);

alias PFN_vkGetShaderModuleCreateInfoIdentifierEXT = void function(
    VkDevice device,
    const(VkShaderModuleCreateInfo)* pCreateInfo,
    VkShaderModuleIdentifierEXT* pIdentifier,
);
