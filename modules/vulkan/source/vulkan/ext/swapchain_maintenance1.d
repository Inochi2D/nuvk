/**
 * VK_EXT_swapchain_maintenance1 (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.swapchain_maintenance1;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.swapchain_maintenance1;

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
public import vulkan.ext.surface_maintenance1;
public import vulkan.khr.swapchain;

struct VK_EXT_swapchain_maintenance1 {
    @VkProcName("vkReleaseSwapchainImagesKHR")
    PFN_vkReleaseSwapchainImagesKHR vkReleaseSwapchainImagesKHR;
}

enum VK_EXT_SWAPCHAIN_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_EXT_SWAPCHAIN_MAINTENANCE_1_EXTENSION_NAME = "VK_EXT_swapchain_maintenance1";

import vulkan.khr.swapchain_maintenance1 : VkPhysicalDeviceSwapchainMaintenance1FeaturesKHR;
alias VkPhysicalDeviceSwapchainMaintenance1FeaturesEXT = VkPhysicalDeviceSwapchainMaintenance1FeaturesKHR;

import vulkan.khr.swapchain_maintenance1 : VkSwapchainPresentFenceInfoKHR;
alias VkSwapchainPresentFenceInfoEXT = VkSwapchainPresentFenceInfoKHR;

import vulkan.khr.swapchain_maintenance1 : VkSwapchainPresentModesCreateInfoKHR;
alias VkSwapchainPresentModesCreateInfoEXT = VkSwapchainPresentModesCreateInfoKHR;

import vulkan.khr.swapchain_maintenance1 : VkSwapchainPresentModeInfoKHR;
alias VkSwapchainPresentModeInfoEXT = VkSwapchainPresentModeInfoKHR;

import vulkan.khr.swapchain_maintenance1 : VkSwapchainPresentScalingCreateInfoKHR;
alias VkSwapchainPresentScalingCreateInfoEXT = VkSwapchainPresentScalingCreateInfoKHR;

import vulkan.khr.swapchain_maintenance1 : VkReleaseSwapchainImagesInfoKHR;
alias VkReleaseSwapchainImagesInfoEXT = VkReleaseSwapchainImagesInfoKHR;

import vulkan.khr.swapchain_maintenance1 : VkReleaseSwapchainImagesInfoKHR;
alias PFN_vkReleaseSwapchainImagesKHR = VkResult function(
    VkDevice device,
    const(VkReleaseSwapchainImagesInfoKHR)* pReleaseInfo,
);
