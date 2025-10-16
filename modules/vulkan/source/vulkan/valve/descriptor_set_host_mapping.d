/**
 * VK_VALVE_descriptor_set_host_mapping
 * 
 * Author:
 *     Valve Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.valve.descriptor_set_host_mapping;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_VALVE_descriptor_set_host_mapping {
    
    @VkProcName("vkGetDescriptorSetLayoutHostMappingInfoVALVE")
    PFN_vkGetDescriptorSetLayoutHostMappingInfoVALVE vkGetDescriptorSetLayoutHostMappingInfoVALVE;
    
    @VkProcName("vkGetDescriptorSetHostMappingVALVE")
    PFN_vkGetDescriptorSetHostMappingVALVE vkGetDescriptorSetHostMappingVALVE;
}

enum VK_VALVE_DESCRIPTOR_SET_HOST_MAPPING_SPEC_VERSION = 1;
enum VK_VALVE_DESCRIPTOR_SET_HOST_MAPPING_EXTENSION_NAME = "VK_VALVE_descriptor_set_host_mapping";

struct VkPhysicalDeviceDescriptorSetHostMappingFeaturesVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_SET_HOST_MAPPING_FEATURES_VALVE;
    void* pNext;
    VkBool32 descriptorSetHostMapping;
}

struct VkDescriptorSetBindingReferenceVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_BINDING_REFERENCE_VALVE;
    const(void)* pNext;
    VkDescriptorSetLayout descriptorSetLayout;
    uint binding;
}

struct VkDescriptorSetLayoutHostMappingInfoVALVE {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_HOST_MAPPING_INFO_VALVE;
    void* pNext;
    size_t descriptorOffset;
    uint descriptorSize;
}

alias PFN_vkGetDescriptorSetLayoutHostMappingInfoVALVE = void function(
    VkDevice device,
    const(VkDescriptorSetBindingReferenceVALVE)* pBindingReference,
    VkDescriptorSetLayoutHostMappingInfoVALVE* pHostMapping,
);

alias PFN_vkGetDescriptorSetHostMappingVALVE = void function(
    VkDevice device,
    VkDescriptorSet descriptorSet,
    void** ppData,
);
