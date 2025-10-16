/**
 * VK_KHR_external_memory_capabilities
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_memory_capabilities;

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

struct VK_KHR_external_memory_capabilities {
    
    @VkProcName("vkGetPhysicalDeviceExternalBufferProperties")
    PFN_vkGetPhysicalDeviceExternalBufferProperties vkGetPhysicalDeviceExternalBufferProperties;
}

enum VK_KHR_EXTERNAL_MEMORY_CAPABILITIES_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_MEMORY_CAPABILITIES_EXTENSION_NAME = "VK_KHR_external_memory_capabilities";
enum VK_LUID_SIZE_KHR = VK_LUID_SIZE;

alias VkExternalMemoryHandleTypeFlagsKHR = VkExternalMemoryHandleTypeFlags;

alias VkExternalMemoryHandleTypeFlagBitsKHR = VkExternalMemoryHandleTypeFlagBits;

alias VkExternalMemoryFeatureFlagsKHR = VkExternalMemoryFeatureFlags;

alias VkExternalMemoryFeatureFlagBitsKHR = VkExternalMemoryFeatureFlagBits;

alias VkExternalMemoryPropertiesKHR = VkExternalMemoryProperties;

alias VkPhysicalDeviceExternalImageFormatInfoKHR = VkPhysicalDeviceExternalImageFormatInfo;

alias VkExternalImageFormatPropertiesKHR = VkExternalImageFormatProperties;

alias VkPhysicalDeviceExternalBufferInfoKHR = VkPhysicalDeviceExternalBufferInfo;

alias VkExternalBufferPropertiesKHR = VkExternalBufferProperties;

alias VkPhysicalDeviceIDPropertiesKHR = VkPhysicalDeviceIDProperties;

alias PFN_vkGetPhysicalDeviceExternalBufferProperties = void function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceExternalBufferInfo)* pExternalBufferInfo,
    VkExternalBufferProperties* pExternalBufferProperties,
);
