/**
 * VK_KHR_buffer_device_address (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.buffer_device_address;

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
    public import vulkan.khr.device_group;
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_KHR_buffer_device_address {
    @VkProcName("vkGetBufferDeviceAddress")
    PFN_vkGetBufferDeviceAddress vkGetBufferDeviceAddress;
    
    @VkProcName("vkGetBufferOpaqueCaptureAddress")
    PFN_vkGetBufferOpaqueCaptureAddress vkGetBufferOpaqueCaptureAddress;
    
    @VkProcName("vkGetDeviceMemoryOpaqueCaptureAddress")
    PFN_vkGetDeviceMemoryOpaqueCaptureAddress vkGetDeviceMemoryOpaqueCaptureAddress;
}

enum VK_KHR_BUFFER_DEVICE_ADDRESS_SPEC_VERSION = 1;
enum VK_KHR_BUFFER_DEVICE_ADDRESS_EXTENSION_NAME = "VK_KHR_buffer_device_address";

alias VkPhysicalDeviceBufferDeviceAddressFeaturesKHR = VkPhysicalDeviceBufferDeviceAddressFeatures;

alias VkBufferDeviceAddressInfoKHR = VkBufferDeviceAddressInfo;

alias VkBufferOpaqueCaptureAddressCreateInfoKHR = VkBufferOpaqueCaptureAddressCreateInfo;

alias VkMemoryOpaqueCaptureAddressAllocateInfoKHR = VkMemoryOpaqueCaptureAddressAllocateInfo;

alias VkDeviceMemoryOpaqueCaptureAddressInfoKHR = VkDeviceMemoryOpaqueCaptureAddressInfo;

alias PFN_vkGetBufferDeviceAddress = VkDeviceAddress function(
    VkDevice device,
    const(VkBufferDeviceAddressInfo)* pInfo,
);

alias PFN_vkGetBufferOpaqueCaptureAddress = ulong function(
    VkDevice device,
    const(VkBufferDeviceAddressInfo)* pInfo,
);

alias PFN_vkGetDeviceMemoryOpaqueCaptureAddress = ulong function(
    VkDevice device,
    const(VkDeviceMemoryOpaqueCaptureAddressInfo)* pInfo,
);
