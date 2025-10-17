/**
 * VK_KHR_surface_maintenance1 (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.surface_maintenance1;

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

public import vulkan.khr.surface;
public import vulkan.khr.get_surface_capabilities2;

enum VK_KHR_SURFACE_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_KHR_SURFACE_MAINTENANCE_1_EXTENSION_NAME = "VK_KHR_surface_maintenance1";

import vulkan.khr.surface : VkPresentModeKHR;
struct VkSurfacePresentModeKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_PRESENT_MODE_KHR;
    void* pNext;
    VkPresentModeKHR presentMode;
}

enum VkPresentScalingFlagBitsKHR : uint {
    VK_PRESENT_SCALING_ONE_TO_ONE_BIT_KHR = 1,
    VK_PRESENT_SCALING_ONE_TO_ONE_BIT_EXT = VK_PRESENT_SCALING_ONE_TO_ONE_BIT_KHR,
    VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_KHR = 2,
    VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_EXT = VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_KHR,
    VK_PRESENT_SCALING_STRETCH_BIT_KHR = 4,
    VK_PRESENT_SCALING_STRETCH_BIT_EXT = VK_PRESENT_SCALING_STRETCH_BIT_KHR,
}

enum VK_PRESENT_SCALING_ONE_TO_ONE_BIT_KHR = VkPresentScalingFlagBitsKHR.VK_PRESENT_SCALING_ONE_TO_ONE_BIT_KHR;
enum VK_PRESENT_SCALING_ONE_TO_ONE_BIT_EXT = VK_PRESENT_SCALING_ONE_TO_ONE_BIT_KHR;
enum VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_KHR = VkPresentScalingFlagBitsKHR.VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_KHR;
enum VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_EXT = VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_KHR;
enum VK_PRESENT_SCALING_STRETCH_BIT_KHR = VkPresentScalingFlagBitsKHR.VK_PRESENT_SCALING_STRETCH_BIT_KHR;
enum VK_PRESENT_SCALING_STRETCH_BIT_EXT = VK_PRESENT_SCALING_STRETCH_BIT_KHR;

alias VkPresentScalingFlagsKHR = VkBitFlagsBase!(VkFlags, VkPresentScalingFlagBitsKHR);

enum VkPresentGravityFlagBitsKHR : uint {
    VK_PRESENT_GRAVITY_MIN_BIT_KHR = 1,
    VK_PRESENT_GRAVITY_MIN_BIT_EXT = VK_PRESENT_GRAVITY_MIN_BIT_KHR,
    VK_PRESENT_GRAVITY_MAX_BIT_KHR = 2,
    VK_PRESENT_GRAVITY_MAX_BIT_EXT = VK_PRESENT_GRAVITY_MAX_BIT_KHR,
    VK_PRESENT_GRAVITY_CENTERED_BIT_KHR = 4,
    VK_PRESENT_GRAVITY_CENTERED_BIT_EXT = VK_PRESENT_GRAVITY_CENTERED_BIT_KHR,
}

enum VK_PRESENT_GRAVITY_MIN_BIT_KHR = VkPresentGravityFlagBitsKHR.VK_PRESENT_GRAVITY_MIN_BIT_KHR;
enum VK_PRESENT_GRAVITY_MIN_BIT_EXT = VK_PRESENT_GRAVITY_MIN_BIT_KHR;
enum VK_PRESENT_GRAVITY_MAX_BIT_KHR = VkPresentGravityFlagBitsKHR.VK_PRESENT_GRAVITY_MAX_BIT_KHR;
enum VK_PRESENT_GRAVITY_MAX_BIT_EXT = VK_PRESENT_GRAVITY_MAX_BIT_KHR;
enum VK_PRESENT_GRAVITY_CENTERED_BIT_KHR = VkPresentGravityFlagBitsKHR.VK_PRESENT_GRAVITY_CENTERED_BIT_KHR;
enum VK_PRESENT_GRAVITY_CENTERED_BIT_EXT = VK_PRESENT_GRAVITY_CENTERED_BIT_KHR;

alias VkPresentGravityFlagsKHR = VkBitFlagsBase!(VkFlags, VkPresentGravityFlagBitsKHR);

struct VkSurfacePresentScalingCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_PRESENT_SCALING_CAPABILITIES_KHR;
    void* pNext;
    VkFlags supportedPresentScaling;
    VkFlags supportedPresentGravityX;
    VkFlags supportedPresentGravityY;
    VkExtent2D minScaledImageExtent;
    VkExtent2D maxScaledImageExtent;
}

import vulkan.khr.surface : VkPresentModeKHR;
struct VkSurfacePresentModeCompatibilityKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_PRESENT_MODE_COMPATIBILITY_KHR;
    void* pNext;
    uint presentModeCount;
    VkPresentModeKHR* pPresentModes;
}
