/**
 * VK_AMD_display_native_hdr (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.display_native_hdr;

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
public import vulkan.khr.get_surface_capabilities2;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_AMD_display_native_hdr {
    @VkProcName("vkSetLocalDimmingAMD")
    PFN_vkSetLocalDimmingAMD vkSetLocalDimmingAMD;
}

enum VK_AMD_DISPLAY_NATIVE_HDR_SPEC_VERSION = 1;
enum VK_AMD_DISPLAY_NATIVE_HDR_EXTENSION_NAME = "VK_AMD_display_native_hdr";

struct VkDisplayNativeHdrSurfaceCapabilitiesAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_NATIVE_HDR_SURFACE_CAPABILITIES_AMD;
    void* pNext;
    VkBool32 localDimmingSupport;
}

struct VkSwapchainDisplayNativeHdrCreateInfoAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_DISPLAY_NATIVE_HDR_CREATE_INFO_AMD;
    const(void)* pNext;
    VkBool32 localDimmingEnable;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
alias PFN_vkSetLocalDimmingAMD = void function(
    VkDevice device,
    VkSwapchainKHR swapChain,
    VkBool32 localDimmingEnable,
);
