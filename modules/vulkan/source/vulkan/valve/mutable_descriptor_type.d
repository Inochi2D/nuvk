/**
 * VK_VALVE_mutable_descriptor_type (Device)
 * 
 * Author:
 *     Valve Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.valve.mutable_descriptor_type;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.ext.mutable_descriptor_type;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.maintenance3;

enum VK_VALVE_MUTABLE_DESCRIPTOR_TYPE_SPEC_VERSION = 1;
enum VK_VALVE_MUTABLE_DESCRIPTOR_TYPE_EXTENSION_NAME = "VK_VALVE_mutable_descriptor_type";

import vulkan.ext.mutable_descriptor_type : VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT;
alias VkPhysicalDeviceMutableDescriptorTypeFeaturesVALVE = VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT;

import vulkan.ext.mutable_descriptor_type : VkMutableDescriptorTypeListEXT;
alias VkMutableDescriptorTypeListVALVE = VkMutableDescriptorTypeListEXT;

import vulkan.ext.mutable_descriptor_type : VkMutableDescriptorTypeCreateInfoEXT;
alias VkMutableDescriptorTypeCreateInfoVALVE = VkMutableDescriptorTypeCreateInfoEXT;
