/**
 * VK_KHR_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.surface;

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

struct VK_KHR_surface {
    @VkProcName("vkDestroySurfaceKHR")
    PFN_vkDestroySurfaceKHR vkDestroySurfaceKHR;
    
    @VkProcName("vkGetPhysicalDeviceSurfaceSupportKHR")
    PFN_vkGetPhysicalDeviceSurfaceSupportKHR vkGetPhysicalDeviceSurfaceSupportKHR;
    
    @VkProcName("vkGetPhysicalDeviceSurfaceCapabilitiesKHR")
    PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR vkGetPhysicalDeviceSurfaceCapabilitiesKHR;
    
    @VkProcName("vkGetPhysicalDeviceSurfaceFormatsKHR")
    PFN_vkGetPhysicalDeviceSurfaceFormatsKHR vkGetPhysicalDeviceSurfaceFormatsKHR;
    
    @VkProcName("vkGetPhysicalDeviceSurfacePresentModesKHR")
    PFN_vkGetPhysicalDeviceSurfacePresentModesKHR vkGetPhysicalDeviceSurfacePresentModesKHR;
}

enum VK_KHR_SURFACE_SPEC_VERSION = 25;
enum VK_KHR_SURFACE_EXTENSION_NAME = "VK_KHR_surface";

alias VkSurfaceKHR = OpaqueHandle!("VkSurfaceKHR");

alias VkSurfaceTransformFlagsKHR = uint;
enum VkSurfaceTransformFlagsKHR
    VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR = 1,
    VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR = 2,
    VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR = 4,
    VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR = 8,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR = 16,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR = 32,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR = 64,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR = 128,
    VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR = 256;

alias VkPresentModeKHR = uint;
enum VkPresentModeKHR
    VK_PRESENT_MODE_IMMEDIATE_KHR = 0,
    VK_PRESENT_MODE_MAILBOX_KHR = 1,
    VK_PRESENT_MODE_FIFO_KHR = 2,
    VK_PRESENT_MODE_FIFO_RELAXED_KHR = 3,
    VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR = 1000111000,
    VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR = 1000111001,
    VK_PRESENT_MODE_FIFO_LATEST_READY_EXT = VK_PRESENT_MODE_FIFO_LATEST_READY_KHR,
    VK_PRESENT_MODE_FIFO_LATEST_READY_KHR = 1000361000;

alias VkColorSpaceKHR = uint;
enum VkColorSpaceKHR
    VK_COLOR_SPACE_SRGB_NONLINEAR_KHR = 0,
    VK_COLORSPACE_SRGB_NONLINEAR_KHR = VK_COLOR_SPACE_SRGB_NONLINEAR_KHR,
    VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT = 1000104001,
    VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT = 1000104002,
    VK_COLOR_SPACE_DISPLAY_P3_LINEAR_EXT = 1000104003,
    VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT = 1000104004,
    VK_COLOR_SPACE_BT709_LINEAR_EXT = 1000104005,
    VK_COLOR_SPACE_BT709_NONLINEAR_EXT = 1000104006,
    VK_COLOR_SPACE_BT2020_LINEAR_EXT = 1000104007,
    VK_COLOR_SPACE_HDR10_ST2084_EXT = 1000104008,
    VK_COLOR_SPACE_DOLBYVISION_EXT = 1000104009,
    VK_COLOR_SPACE_HDR10_HLG_EXT = 1000104010,
    VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT = 1000104011,
    VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT = 1000104012,
    VK_COLOR_SPACE_PASS_THROUGH_EXT = 1000104013,
    VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT = 1000104014,
    VK_COLOR_SPACE_DCI_P3_LINEAR_EXT = VK_COLOR_SPACE_DISPLAY_P3_LINEAR_EXT,
    VK_COLOR_SPACE_DISPLAY_NATIVE_AMD = 1000213000;

alias VkCompositeAlphaFlagsKHR = uint;
enum VkCompositeAlphaFlagsKHR
    VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR = 1,
    VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR = 2,
    VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR = 4,
    VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR = 8;


struct VkSurfaceCapabilitiesKHR {
    uint minImageCount;
    uint maxImageCount;
    VkExtent2D currentExtent;
    VkExtent2D minImageExtent;
    VkExtent2D maxImageExtent;
    uint maxImageArrayLayers;
    VkSurfaceTransformFlagsKHR supportedTransforms;
    VkSurfaceTransformFlagsKHR currentTransform;
    VkCompositeAlphaFlagsKHR supportedCompositeAlpha;
    VkImageUsageFlags supportedUsageFlags;
}

struct VkSurfaceFormatKHR {
    VkFormat format;
    VkColorSpaceKHR colorSpace;
}

alias PFN_vkDestroySurfaceKHR = void function(
    VkInstance instance,
    VkSurfaceKHR surface,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetPhysicalDeviceSurfaceSupportKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    VkSurfaceKHR surface,
    VkBool32* pSupported,
);

alias PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    VkSurfaceCapabilitiesKHR* pSurfaceCapabilities,
);

alias PFN_vkGetPhysicalDeviceSurfaceFormatsKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    uint* pSurfaceFormatCount,
    VkSurfaceFormatKHR* pSurfaceFormats,
);

alias PFN_vkGetPhysicalDeviceSurfacePresentModesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    uint* pPresentModeCount,
    VkPresentModeKHR* pPresentModes,
);
