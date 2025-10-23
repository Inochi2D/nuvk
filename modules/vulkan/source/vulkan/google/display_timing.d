/**
 * VK_GOOGLE_display_timing (Device)
 * 
 * Author:
 *     Google LLC
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.google.display_timing;

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

public import vulkan.khr.swapchain;

struct VK_GOOGLE_display_timing {
    @VkProcName("vkGetRefreshCycleDurationGOOGLE")
    PFN_vkGetRefreshCycleDurationGOOGLE vkGetRefreshCycleDurationGOOGLE;
    
    @VkProcName("vkGetPastPresentationTimingGOOGLE")
    PFN_vkGetPastPresentationTimingGOOGLE vkGetPastPresentationTimingGOOGLE;
}

enum VK_GOOGLE_DISPLAY_TIMING_SPEC_VERSION = 1;
enum VK_GOOGLE_DISPLAY_TIMING_EXTENSION_NAME = "VK_GOOGLE_display_timing";

struct VkRefreshCycleDurationGOOGLE {
    ulong refreshDuration;
}

struct VkPastPresentationTimingGOOGLE {
    uint presentID;
    ulong desiredPresentTime;
    ulong actualPresentTime;
    ulong earliestPresentTime;
    ulong presentMargin;
}

struct VkPresentTimesInfoGOOGLE {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_TIMES_INFO_GOOGLE;
    const(void)* pNext;
    uint swapchainCount;
    const(VkPresentTimeGOOGLE)* pTimes;
}

struct VkPresentTimeGOOGLE {
    uint presentID;
    ulong desiredPresentTime;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkGetRefreshCycleDurationGOOGLE = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    VkRefreshCycleDurationGOOGLE* pDisplayTimingProperties,
);

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkGetPastPresentationTimingGOOGLE = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    uint* pPresentationTimingCount,
    VkPastPresentationTimingGOOGLE* pPresentationTimings,
);
