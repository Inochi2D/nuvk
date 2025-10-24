/**
 * VK_KHR_swapchain_maintenance1 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.swapchain_maintenance1;

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
public import vulkan.khr.surface_maintenance1;
public import vulkan.khr.get_physical_device_properties2;

struct VK_KHR_swapchain_maintenance1 {
    @VkProcName("vkReleaseSwapchainImagesKHR")
    PFN_vkReleaseSwapchainImagesKHR vkReleaseSwapchainImagesKHR;
}

enum VK_KHR_SWAPCHAIN_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_KHR_SWAPCHAIN_MAINTENANCE_1_EXTENSION_NAME = "VK_KHR_swapchain_maintenance1";

struct VkPhysicalDeviceSwapchainMaintenance1FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SWAPCHAIN_MAINTENANCE_1_FEATURES_KHR;
    void* pNext;
    VkBool32 swapchainMaintenance1;
}

struct VkSwapchainPresentFenceInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_FENCE_INFO_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(VkFence)* pFences;
}

import vulkan.khr.surface : VkPresentModeKHR;
struct VkSwapchainPresentModesCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_MODES_CREATE_INFO_KHR;
    const(void)* pNext;
    uint presentModeCount;
    const(VkPresentModeKHR)* pPresentModes;
}

import vulkan.khr.surface : VkPresentModeKHR;
struct VkSwapchainPresentModeInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_MODE_INFO_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(VkPresentModeKHR)* pPresentModes;
}

import vulkan.khr.surface_maintenance1 : VkPresentScalingFlagsKHR, VkPresentGravityFlagsKHR, VkPresentGravityFlagsKHR;
struct VkSwapchainPresentScalingCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_SCALING_CREATE_INFO_KHR;
    const(void)* pNext;
    VkPresentScalingFlagsKHR scalingBehavior;
    VkPresentGravityFlagsKHR presentGravityX;
    VkPresentGravityFlagsKHR presentGravityY;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
struct VkReleaseSwapchainImagesInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RELEASE_SWAPCHAIN_IMAGES_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    uint imageIndexCount;
    const(uint)* pImageIndices;
}

alias PFN_vkReleaseSwapchainImagesKHR = VkResult function(
    VkDevice device,
    const(VkReleaseSwapchainImagesInfoKHR)* pReleaseInfo,
);
