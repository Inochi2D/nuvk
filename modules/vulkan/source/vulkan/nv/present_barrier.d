/**
 * VK_NV_present_barrier
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.present_barrier;

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
public import vulkan.khr.get_surface_capabilities2;
public import vulkan.khr.surface;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_NV_PRESENT_BARRIER_SPEC_VERSION = 1;
enum VK_NV_PRESENT_BARRIER_EXTENSION_NAME = "VK_NV_present_barrier";

struct VkPhysicalDevicePresentBarrierFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_BARRIER_FEATURES_NV;
    void* pNext;
    VkBool32 presentBarrier;
}

struct VkSurfaceCapabilitiesPresentBarrierNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_PRESENT_BARRIER_NV;
    void* pNext;
    VkBool32 presentBarrierSupported;
}

struct VkSwapchainPresentBarrierCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_BARRIER_CREATE_INFO_NV;
    void* pNext;
    VkBool32 presentBarrierEnable;
}
