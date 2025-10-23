/**
 * VK_EXT_device_address_binding_report (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.device_address_binding_report;

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

public import vulkan.ext.debug_utils;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_EXT_DEVICE_ADDRESS_BINDING_REPORT_SPEC_VERSION = 1;
enum VK_EXT_DEVICE_ADDRESS_BINDING_REPORT_EXTENSION_NAME = "VK_EXT_device_address_binding_report";

struct VkPhysicalDeviceAddressBindingReportFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ADDRESS_BINDING_REPORT_FEATURES_EXT;
    void* pNext;
    VkBool32 reportAddressBinding;
}

struct VkDeviceAddressBindingCallbackDataEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_ADDRESS_BINDING_CALLBACK_DATA_EXT;
    void* pNext;
    VkDeviceAddressBindingFlagsEXT flags;
    VkDeviceAddress baseAddress;
    VkDeviceSize size;
    VkDeviceAddressBindingTypeEXT bindingType;
}


alias VkDeviceAddressBindingFlagsEXT = uint;
enum VkDeviceAddressBindingFlagsEXT
    VK_DEVICE_ADDRESS_BINDING_INTERNAL_OBJECT_BIT_EXT = 1;

alias VkDeviceAddressBindingTypeEXT = uint;
enum VkDeviceAddressBindingTypeEXT
    VK_DEVICE_ADDRESS_BINDING_TYPE_BIND_EXT = 0,
    VK_DEVICE_ADDRESS_BINDING_TYPE_UNBIND_EXT = 1;
