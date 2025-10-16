/**
 * VK_KHR_external_fence_capabilities (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_fence_capabilities;

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
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_KHR_external_fence_capabilities {
    
    @VkProcName("vkGetPhysicalDeviceExternalFenceProperties")
    PFN_vkGetPhysicalDeviceExternalFenceProperties vkGetPhysicalDeviceExternalFenceProperties;
}

enum VK_KHR_EXTERNAL_FENCE_CAPABILITIES_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_FENCE_CAPABILITIES_EXTENSION_NAME = "VK_KHR_external_fence_capabilities";

alias VkExternalFenceHandleTypeFlagsKHR = VkExternalFenceHandleTypeFlags;

alias VkExternalFenceHandleTypeFlagBitsKHR = VkExternalFenceHandleTypeFlagBits;

alias VkExternalFenceFeatureFlagsKHR = VkExternalFenceFeatureFlags;

alias VkExternalFenceFeatureFlagBitsKHR = VkExternalFenceFeatureFlagBits;

alias VkPhysicalDeviceExternalFenceInfoKHR = VkPhysicalDeviceExternalFenceInfo;

alias VkExternalFencePropertiesKHR = VkExternalFenceProperties;

alias VkPhysicalDeviceIDPropertiesKHR = VkPhysicalDeviceIDProperties;

alias PFN_vkGetPhysicalDeviceExternalFenceProperties = void function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceExternalFenceInfo)* pExternalFenceInfo,
    VkExternalFenceProperties* pExternalFenceProperties,
);
