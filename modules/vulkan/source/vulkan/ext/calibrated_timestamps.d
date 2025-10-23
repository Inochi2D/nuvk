/**
 * VK_EXT_calibrated_timestamps (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.calibrated_timestamps;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.calibrated_timestamps;

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

struct VK_EXT_calibrated_timestamps {
    @VkProcName("vkGetPhysicalDeviceCalibrateableTimeDomainsKHR")
    PFN_vkGetPhysicalDeviceCalibrateableTimeDomainsKHR vkGetPhysicalDeviceCalibrateableTimeDomainsKHR;
    
    @VkProcName("vkGetCalibratedTimestampsKHR")
    PFN_vkGetCalibratedTimestampsKHR vkGetCalibratedTimestampsKHR;
}

enum VK_EXT_CALIBRATED_TIMESTAMPS_SPEC_VERSION = 2;
enum VK_EXT_CALIBRATED_TIMESTAMPS_EXTENSION_NAME = "VK_EXT_calibrated_timestamps";

import vulkan.khr.calibrated_timestamps : VkTimeDomainKHR;
alias VkTimeDomainEXT = VkTimeDomainKHR;

import vulkan.khr.calibrated_timestamps : VkCalibratedTimestampInfoKHR;
alias VkCalibratedTimestampInfoEXT = VkCalibratedTimestampInfoKHR;

import vulkan.khr.calibrated_timestamps : VkTimeDomainKHR;
alias PFN_vkGetPhysicalDeviceCalibrateableTimeDomainsKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pTimeDomainCount,
    VkTimeDomainKHR* pTimeDomains,
);

import vulkan.khr.calibrated_timestamps : VkCalibratedTimestampInfoKHR;
alias PFN_vkGetCalibratedTimestampsKHR = VkResult function(
    VkDevice device,
    uint timestampCount,
    const(VkCalibratedTimestampInfoKHR)* pTimestampInfos,
    ulong* pTimestamps,
    ulong* pMaxDeviation,
);
