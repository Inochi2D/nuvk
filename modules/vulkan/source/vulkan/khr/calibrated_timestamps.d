/**
 * VK_KHR_calibrated_timestamps (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.calibrated_timestamps;

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

struct VK_KHR_calibrated_timestamps {
    @VkProcName("vkGetPhysicalDeviceCalibrateableTimeDomainsKHR")
    PFN_vkGetPhysicalDeviceCalibrateableTimeDomainsKHR vkGetPhysicalDeviceCalibrateableTimeDomainsKHR;
    
    @VkProcName("vkGetCalibratedTimestampsKHR")
    PFN_vkGetCalibratedTimestampsKHR vkGetCalibratedTimestampsKHR;
}

enum VK_KHR_CALIBRATED_TIMESTAMPS_SPEC_VERSION = 1;
enum VK_KHR_CALIBRATED_TIMESTAMPS_EXTENSION_NAME = "VK_KHR_calibrated_timestamps";

alias VkTimeDomainKHR = uint;
enum VkTimeDomainKHR
    VK_TIME_DOMAIN_DEVICE_KHR = 0,
    VK_TIME_DOMAIN_CLOCK_MONOTONIC_KHR = 1,
    VK_TIME_DOMAIN_CLOCK_MONOTONIC_RAW_KHR = 2,
    VK_TIME_DOMAIN_QUERY_PERFORMANCE_COUNTER_KHR = 3,
    VK_TIME_DOMAIN_DEVICE_EXT = VK_TIME_DOMAIN_DEVICE_KHR,
    VK_TIME_DOMAIN_CLOCK_MONOTONIC_EXT = VK_TIME_DOMAIN_CLOCK_MONOTONIC_KHR,
    VK_TIME_DOMAIN_CLOCK_MONOTONIC_RAW_EXT = VK_TIME_DOMAIN_CLOCK_MONOTONIC_RAW_KHR,
    VK_TIME_DOMAIN_QUERY_PERFORMANCE_COUNTER_EXT = VK_TIME_DOMAIN_QUERY_PERFORMANCE_COUNTER_KHR;

struct VkCalibratedTimestampInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_KHR;
    const(void)* pNext;
    VkTimeDomainKHR timeDomain;
}

alias PFN_vkGetPhysicalDeviceCalibrateableTimeDomainsKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pTimeDomainCount,
    VkTimeDomainKHR* pTimeDomains,
);

alias PFN_vkGetCalibratedTimestampsKHR = VkResult function(
    VkDevice device,
    uint timestampCount,
    const(VkCalibratedTimestampInfoKHR)* pTimestampInfos,
    ulong* pTimestamps,
    ulong* pMaxDeviation,
);
