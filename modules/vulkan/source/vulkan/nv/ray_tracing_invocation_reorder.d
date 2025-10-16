/**
 * VK_NV_ray_tracing_invocation_reorder (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.ray_tracing_invocation_reorder;

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

public import vulkan.khr.ray_tracing_pipeline;

enum VK_NV_RAY_TRACING_INVOCATION_REORDER_SPEC_VERSION = 1;
enum VK_NV_RAY_TRACING_INVOCATION_REORDER_EXTENSION_NAME = "VK_NV_ray_tracing_invocation_reorder";

enum VkRayTracingInvocationReorderModeNV {
    VK_RAY_TRACING_INVOCATION_REORDER_MODE_NONE_NV = 0,
    VK_RAY_TRACING_INVOCATION_REORDER_MODE_REORDER_NV = 1,
}

enum VK_RAY_TRACING_INVOCATION_REORDER_MODE_NONE_NV = VkRayTracingInvocationReorderModeNV.VK_RAY_TRACING_INVOCATION_REORDER_MODE_NONE_NV;
enum VK_RAY_TRACING_INVOCATION_REORDER_MODE_REORDER_NV = VkRayTracingInvocationReorderModeNV.VK_RAY_TRACING_INVOCATION_REORDER_MODE_REORDER_NV;

struct VkPhysicalDeviceRayTracingInvocationReorderPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_INVOCATION_REORDER_PROPERTIES_NV;
    void* pNext;
    VkRayTracingInvocationReorderModeNV rayTracingInvocationReorderReorderingHint;
}

struct VkPhysicalDeviceRayTracingInvocationReorderFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_INVOCATION_REORDER_FEATURES_NV;
    void* pNext;
    VkBool32 rayTracingInvocationReorder;
}
