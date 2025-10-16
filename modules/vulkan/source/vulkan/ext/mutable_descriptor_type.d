/**
 * VK_EXT_mutable_descriptor_type
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.mutable_descriptor_type;

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
    public import vulkan.khr.maintenance3;
}

enum VK_EXT_MUTABLE_DESCRIPTOR_TYPE_SPEC_VERSION = 1;
enum VK_EXT_MUTABLE_DESCRIPTOR_TYPE_EXTENSION_NAME = "VK_EXT_mutable_descriptor_type";

struct VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MUTABLE_DESCRIPTOR_TYPE_FEATURES_EXT;
    void* pNext;
    VkBool32 mutableDescriptorType;
}

struct VkMutableDescriptorTypeListEXT {
    uint descriptorTypeCount;
    const(VkDescriptorType)* pDescriptorTypes;
}

struct VkMutableDescriptorTypeCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MUTABLE_DESCRIPTOR_TYPE_CREATE_INFO_EXT;
    const(void)* pNext;
    uint mutableDescriptorTypeListCount;
    const(VkMutableDescriptorTypeListEXT)* pMutableDescriptorTypeLists;
}
