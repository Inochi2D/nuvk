/**
    VK_KHR_display
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_display;
import vulkan.khr_surface;
import vulkan.core;

import numem.core.types : OpaqueHandle;

extern (System) @nogc nothrow:

enum uint VK_KHR_DISPLAY_SPEC_VERSION = 23;
enum string VK_KHR_DISPLAY_EXTENSION_NAME = "VK_KHR_display";

alias VkDisplayKHR = OpaqueHandle!("VkDisplayKHR");
alias VkDisplayModeKHR = OpaqueHandle!("VkDisplayModeKHR");

alias VkDisplayModeCreateFlagsKHR = VkFlags;
alias VkDisplaySurfaceCreateFlagsKHR = VkFlags;
alias VkDisplayPlaneAlphaFlagsKHR = VkFlags;
enum VkDisplayPlaneAlphaFlagsKHR VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR = 0x00000001,
    VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR = 0x00000002,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR = 0x00000004,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = 0x00000008;

struct VkDisplayModeParametersKHR {
    VkExtent2D visibleRegion;
    uint refreshRate;
}

struct VkDisplayModeCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkDisplayModeCreateFlagsKHR flags;
    VkDisplayModeParametersKHR parameters;
}

struct VkDisplayModePropertiesKHR {
    VkDisplayModeKHR displayMode;
    VkDisplayModeParametersKHR parameters;
}

struct VkDisplayPlaneCapabilitiesKHR {
    VkDisplayPlaneAlphaFlagsKHR supportedAlpha;
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
    VkSurfaceTransformFlagsKHR supportedTransforms;
    VkBool32 planeReorderPossible;
    VkBool32 persistentContent;
}

struct VkDisplaySurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkDisplaySurfaceCreateFlagsKHR flags;
    VkDisplayModeKHR displayMode;
    uint planeIndex;
    uint planeStackIndex;
    VkSurfaceTransformFlagsKHR transform;
    float globalAlpha;
    VkDisplayPlaneAlphaFlagsKHR alphaMode;
    VkExtent2D imageExtent;
}

alias PFN_vkGetPhysicalDeviceDisplayPropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice, uint* pPropertyCount, VkDisplayPropertiesKHR* pProperties);
alias PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice, uint* pPropertyCount, VkDisplayPlanePropertiesKHR* pProperties);
alias PFN_vkGetDisplayPlaneSupportedDisplaysKHR = VkResult function(VkPhysicalDevice physicalDevice, uint planeIndex, uint* pDisplayCount, VkDisplayKHR* pDisplays);
alias PFN_vkGetDisplayModePropertiesKHR = VkResult function(VkPhysicalDevice physicalDevice, VkDisplayKHR display, uint* pPropertyCount, VkDisplayModePropertiesKHR* pProperties);
alias PFN_vkCreateDisplayModeKHR = VkResult function(VkPhysicalDevice physicalDevice, VkDisplayKHR display, const(
        VkDisplayModeCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDisplayModeKHR* pMode);
alias PFN_vkGetDisplayPlaneCapabilitiesKHR = VkResult function(VkPhysicalDevice physicalDevice, VkDisplayModeKHR mode, uint planeIndex, VkDisplayPlaneCapabilitiesKHR* pCapabilities);
alias PFN_vkCreateDisplayPlaneSurfaceKHR = VkResult function(VkInstance instance, const(
        VkDisplaySurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface);
