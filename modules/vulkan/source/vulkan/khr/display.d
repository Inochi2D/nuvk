/**
 * VK_KHR_display (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.display;

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

struct VK_KHR_display {
    
    @VkProcName("vkGetPhysicalDeviceDisplayPropertiesKHR")
    PFN_vkGetPhysicalDeviceDisplayPropertiesKHR vkGetPhysicalDeviceDisplayPropertiesKHR;
    
    @VkProcName("vkGetPhysicalDeviceDisplayPlanePropertiesKHR")
    PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR vkGetPhysicalDeviceDisplayPlanePropertiesKHR;
    
    @VkProcName("vkGetDisplayPlaneSupportedDisplaysKHR")
    PFN_vkGetDisplayPlaneSupportedDisplaysKHR vkGetDisplayPlaneSupportedDisplaysKHR;
    
    @VkProcName("vkGetDisplayModePropertiesKHR")
    PFN_vkGetDisplayModePropertiesKHR vkGetDisplayModePropertiesKHR;
    
    @VkProcName("vkCreateDisplayModeKHR")
    PFN_vkCreateDisplayModeKHR vkCreateDisplayModeKHR;
    
    @VkProcName("vkGetDisplayPlaneCapabilitiesKHR")
    PFN_vkGetDisplayPlaneCapabilitiesKHR vkGetDisplayPlaneCapabilitiesKHR;
    
    @VkProcName("vkCreateDisplayPlaneSurfaceKHR")
    PFN_vkCreateDisplayPlaneSurfaceKHR vkCreateDisplayPlaneSurfaceKHR;
}

enum VK_KHR_DISPLAY_SPEC_VERSION = 23;
enum VK_KHR_DISPLAY_EXTENSION_NAME = "VK_KHR_display";

alias VkDisplayKHR = OpaqueHandle!("VkDisplayKHR");

alias VkDisplayModeCreateFlagsKHR = VkFlags;

struct VkDisplayModeCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    VkDisplayModeParametersKHR parameters;
}

alias VkDisplayModeKHR = OpaqueHandle!("VkDisplayModeKHR");

struct VkDisplayModeParametersKHR {
    VkExtent2D visibleRegion;
    uint refreshRate;
}

struct VkDisplayModePropertiesKHR {
    VkDisplayModeKHR displayMode;
    VkDisplayModeParametersKHR parameters;
}

enum VkDisplayPlaneAlphaFlagBitsKHR : uint {
    VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR = 1,
    VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR = 2,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR = 4,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = 8,
}

enum VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR;

alias VkDisplayPlaneAlphaFlagsKHR = VkBitFlagsBase!(VkFlags, VkDisplayPlaneAlphaFlagBitsKHR);

struct VkDisplayPlaneCapabilitiesKHR {
    VkFlags supportedAlpha;
    VkOffset2D minSrcPosition;
    VkOffset2D maxSrcPosition;
    VkExtent2D minSrcExtent;
    VkExtent2D maxSrcExtent;
    VkOffset2D minDstPosition;
    VkOffset2D maxDstPosition;
    VkExtent2D minDstExtent;
    VkExtent2D maxDstExtent;
}

struct VkDisplayPlanePropertiesKHR {
    VkDisplayKHR currentDisplay;
    uint currentStackIndex;
}

struct VkDisplayPropertiesKHR {
    VkDisplayKHR display;
    const(char)* displayName;
    VkExtent2D physicalDimensions;
    VkExtent2D physicalResolution;
    VkFlags supportedTransforms;
    VkBool32 planeReorderPossible;
    VkBool32 persistentContent;
}

alias VkDisplaySurfaceCreateFlagsKHR = VkFlags;

import vulkan.khr.surface : VkSurfaceTransformFlagBitsKHR;
struct VkDisplaySurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    VkDisplayModeKHR displayMode;
    uint planeIndex;
    uint planeStackIndex;
    VkSurfaceTransformFlagBitsKHR transform;
    float globalAlpha;
    VkDisplayPlaneAlphaFlagBitsKHR alphaMode;
    VkExtent2D imageExtent;
}

import vulkan.khr.surface : VkSurfaceTransformFlagBitsKHR;
alias VkSurfaceTransformFlagsKHR = VkBitFlagsBase!(VkFlags, VkSurfaceTransformFlagBitsKHR);

alias PFN_vkGetPhysicalDeviceDisplayPropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkDisplayPropertiesKHR* pProperties,
);

alias PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkDisplayPlanePropertiesKHR* pProperties,
);

alias PFN_vkGetDisplayPlaneSupportedDisplaysKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint planeIndex,
    uint* pDisplayCount,
    VkDisplayKHR* pDisplays,
);

alias PFN_vkGetDisplayModePropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayKHR display,
    uint* pPropertyCount,
    VkDisplayModePropertiesKHR* pProperties,
);

alias PFN_vkCreateDisplayModeKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayKHR display,
    const(VkDisplayModeCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkDisplayModeKHR pMode,
);

alias PFN_vkGetDisplayPlaneCapabilitiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkDisplayModeKHR mode,
    uint planeIndex,
    VkDisplayPlaneCapabilitiesKHR* pCapabilities,
);

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkCreateDisplayPlaneSurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkDisplaySurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkSurfaceKHR pSurface,
);
