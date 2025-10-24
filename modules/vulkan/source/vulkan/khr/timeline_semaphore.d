/**
 * VK_KHR_timeline_semaphore (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.timeline_semaphore;

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

struct VK_KHR_timeline_semaphore {
    @VkProcName("vkGetSemaphoreCounterValue")
    PFN_vkGetSemaphoreCounterValue vkGetSemaphoreCounterValue;
    
    @VkProcName("vkWaitSemaphores")
    PFN_vkWaitSemaphores vkWaitSemaphores;
    
    @VkProcName("vkSignalSemaphore")
    PFN_vkSignalSemaphore vkSignalSemaphore;
}

enum VK_KHR_TIMELINE_SEMAPHORE_SPEC_VERSION = 2;
enum VK_KHR_TIMELINE_SEMAPHORE_EXTENSION_NAME = "VK_KHR_timeline_semaphore";

alias VkSemaphoreTypeKHR = VkSemaphoreType;

alias VkPhysicalDeviceTimelineSemaphoreFeaturesKHR = VkPhysicalDeviceTimelineSemaphoreFeatures;

alias VkPhysicalDeviceTimelineSemaphorePropertiesKHR = VkPhysicalDeviceTimelineSemaphoreProperties;

alias VkSemaphoreTypeCreateInfoKHR = VkSemaphoreTypeCreateInfo;

alias VkTimelineSemaphoreSubmitInfoKHR = VkTimelineSemaphoreSubmitInfo;

alias VkSemaphoreWaitFlagBitsKHR = VkSemaphoreWaitFlags;

alias VkSemaphoreWaitFlagsKHR = VkSemaphoreWaitFlags;

alias VkSemaphoreWaitInfoKHR = VkSemaphoreWaitInfo;

alias VkSemaphoreSignalInfoKHR = VkSemaphoreSignalInfo;

alias PFN_vkGetSemaphoreCounterValue = VkResult function(
    VkDevice device,
    VkSemaphore semaphore,
    ulong* pValue,
);

alias PFN_vkWaitSemaphores = VkResult function(
    VkDevice device,
    const(VkSemaphoreWaitInfo)* pWaitInfo,
    ulong timeout,
);

alias PFN_vkSignalSemaphore = VkResult function(
    VkDevice device,
    const(VkSemaphoreSignalInfo)* pSignalInfo,
);
