/**
 * VK_EXT_buffer_device_address (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.buffer_device_address;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.buffer_device_address;

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

struct VK_EXT_buffer_device_address {
    @VkProcName("vkGetBufferDeviceAddress")
    PFN_vkGetBufferDeviceAddress vkGetBufferDeviceAddress;
}

enum VK_EXT_BUFFER_DEVICE_ADDRESS_SPEC_VERSION = 2;
enum VK_EXT_BUFFER_DEVICE_ADDRESS_EXTENSION_NAME = "VK_EXT_buffer_device_address";

alias VkPhysicalDeviceBufferAddressFeaturesEXT = VkPhysicalDeviceBufferDeviceAddressFeaturesEXT;

struct VkPhysicalDeviceBufferDeviceAddressFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_DEVICE_ADDRESS_FEATURES_EXT;
    void* pNext;
    VkBool32 bufferDeviceAddress;
    VkBool32 bufferDeviceAddressCaptureReplay;
    VkBool32 bufferDeviceAddressMultiDevice;
}

alias VkBufferDeviceAddressInfoEXT = VkBufferDeviceAddressInfo;

struct VkBufferDeviceAddressCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_CREATE_INFO_EXT;
    const(void)* pNext;
    VkDeviceAddress deviceAddress;
}

alias PFN_vkGetBufferDeviceAddress = VkDeviceAddress function(
    VkDevice device,
    const(VkBufferDeviceAddressInfo)* pInfo,
);
