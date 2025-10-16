/**
 * VK_AMD_shader_core_properties (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.shader_core_properties;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_AMD_SHADER_CORE_PROPERTIES_SPEC_VERSION = 2;
enum VK_AMD_SHADER_CORE_PROPERTIES_EXTENSION_NAME = "VK_AMD_shader_core_properties";

struct VkPhysicalDeviceShaderCorePropertiesAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_AMD;
    void* pNext;
    uint shaderEngineCount;
    uint shaderArraysPerEngineCount;
    uint computeUnitsPerShaderArray;
    uint simdPerComputeUnit;
    uint wavefrontsPerSimd;
    uint wavefrontSize;
    uint sgprsPerSimd;
    uint minSgprAllocation;
    uint maxSgprAllocation;
    uint sgprAllocationGranularity;
    uint vgprsPerSimd;
    uint minVgprAllocation;
    uint maxVgprAllocation;
    uint vgprAllocationGranularity;
}
