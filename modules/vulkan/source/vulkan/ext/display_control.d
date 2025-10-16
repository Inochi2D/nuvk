/**
 * VK_EXT_display_control
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.display_control;

import numem.core.types : OpaqueHandle;
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
public import vulkan.ext.display_surface_counter;

struct VK_EXT_display_control {
    
    @VkProcName("vkDisplayPowerControlEXT")
    PFN_vkDisplayPowerControlEXT vkDisplayPowerControlEXT;
    
    @VkProcName("vkRegisterDeviceEventEXT")
    PFN_vkRegisterDeviceEventEXT vkRegisterDeviceEventEXT;
    
    @VkProcName("vkRegisterDisplayEventEXT")
    PFN_vkRegisterDisplayEventEXT vkRegisterDisplayEventEXT;
    
    @VkProcName("vkGetSwapchainCounterEXT")
    PFN_vkGetSwapchainCounterEXT vkGetSwapchainCounterEXT;
}

enum VK_EXT_DISPLAY_CONTROL_SPEC_VERSION = 1;
enum VK_EXT_DISPLAY_CONTROL_EXTENSION_NAME = "VK_EXT_display_control";

enum VkDisplayPowerStateEXT {
    VK_DISPLAY_POWER_STATE_OFF_EXT = 0,
    VK_DISPLAY_POWER_STATE_SUSPEND_EXT = 1,
    VK_DISPLAY_POWER_STATE_ON_EXT = 2,
}

enum VK_DISPLAY_POWER_STATE_OFF_EXT = VkDisplayPowerStateEXT.VK_DISPLAY_POWER_STATE_OFF_EXT;
enum VK_DISPLAY_POWER_STATE_SUSPEND_EXT = VkDisplayPowerStateEXT.VK_DISPLAY_POWER_STATE_SUSPEND_EXT;
enum VK_DISPLAY_POWER_STATE_ON_EXT = VkDisplayPowerStateEXT.VK_DISPLAY_POWER_STATE_ON_EXT;

enum VkDeviceEventTypeEXT {
    VK_DEVICE_EVENT_TYPE_DISPLAY_HOTPLUG_EXT = 0,
}

enum VK_DEVICE_EVENT_TYPE_DISPLAY_HOTPLUG_EXT = VkDeviceEventTypeEXT.VK_DEVICE_EVENT_TYPE_DISPLAY_HOTPLUG_EXT;

enum VkDisplayEventTypeEXT {
    VK_DISPLAY_EVENT_TYPE_FIRST_PIXEL_OUT_EXT = 0,
}

enum VK_DISPLAY_EVENT_TYPE_FIRST_PIXEL_OUT_EXT = VkDisplayEventTypeEXT.VK_DISPLAY_EVENT_TYPE_FIRST_PIXEL_OUT_EXT;

struct VkDisplayPowerInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_POWER_INFO_EXT;
    const(void)* pNext;
    VkDisplayPowerStateEXT powerState;
}

struct VkDeviceEventInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_EVENT_INFO_EXT;
    const(void)* pNext;
    VkDeviceEventTypeEXT deviceEvent;
}

struct VkDisplayEventInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_EVENT_INFO_EXT;
    const(void)* pNext;
    VkDisplayEventTypeEXT displayEvent;
}

struct VkSwapchainCounterCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_COUNTER_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags surfaceCounters;
}

alias PFN_vkDisplayPowerControlEXT = VkResult function(
    VkDevice device,
    VkDisplayKHR display,
    const(VkDisplayPowerInfoEXT)* pDisplayPowerInfo,
);

alias PFN_vkRegisterDeviceEventEXT = VkResult function(
    VkDevice device,
    const(VkDeviceEventInfoEXT)* pDeviceEventInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkFence* pFence,
);

alias PFN_vkRegisterDisplayEventEXT = VkResult function(
    VkDevice device,
    VkDisplayKHR display,
    const(VkDisplayEventInfoEXT)* pDisplayEventInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkFence* pFence,
);

alias PFN_vkGetSwapchainCounterEXT = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    VkSurfaceCounterFlagBitsEXT counter,
    ulong* pCounterValue,
);
