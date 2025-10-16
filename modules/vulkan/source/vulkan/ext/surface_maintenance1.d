/**
 * VK_EXT_surface_maintenance1 (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.surface_maintenance1;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.surface_maintenance1;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.get_surface_capabilities2;
public import vulkan.khr.surface;

enum VK_EXT_SURFACE_MAINTENANCE_1_SPEC_VERSION = 1;
enum VK_EXT_SURFACE_MAINTENANCE_1_EXTENSION_NAME = "VK_EXT_surface_maintenance1";

alias VkSurfacePresentModeEXT = VkSurfacePresentModeKHR;

alias VkPresentScalingFlagBitsEXT = VkPresentScalingFlagBitsKHR;

alias VkPresentScalingFlagsEXT = VkPresentScalingFlagsKHR;

alias VkPresentGravityFlagBitsEXT = VkPresentGravityFlagBitsKHR;

alias VkPresentGravityFlagsEXT = VkPresentGravityFlagsKHR;

alias VkSurfacePresentScalingCapabilitiesEXT = VkSurfacePresentScalingCapabilitiesKHR;

alias VkSurfacePresentModeCompatibilityEXT = VkSurfacePresentModeCompatibilityKHR;
