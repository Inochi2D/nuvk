/**
 * VK_AMD_shader_core_properties2 (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.shader_core_properties2;

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

public import vulkan.amd.shader_core_properties;

enum VK_AMD_SHADER_CORE_PROPERTIES_2_SPEC_VERSION = 1;
enum VK_AMD_SHADER_CORE_PROPERTIES_2_EXTENSION_NAME = "VK_AMD_shader_core_properties2";

struct VkPhysicalDeviceShaderCoreProperties2AMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_2_AMD;
    void* pNext;
    VkFlags shaderCoreFeatures;
    uint activeComputeUnitCount;
}

enum VkShaderCorePropertiesFlagBitsAMD : uint;

alias VkShaderCorePropertiesFlagsAMD = VkFlags;
