/**
 * VK_EXT_shader_atomic_float2 (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.shader_atomic_float2;

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

public import vulkan.ext.shader_atomic_float;

enum VK_EXT_SHADER_ATOMIC_FLOAT_2_SPEC_VERSION = 1;
enum VK_EXT_SHADER_ATOMIC_FLOAT_2_EXTENSION_NAME = "VK_EXT_shader_atomic_float2";

struct VkPhysicalDeviceShaderAtomicFloat2FeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_2_FEATURES_EXT;
    void* pNext;
    VkBool32 shaderBufferFloat16Atomics;
    VkBool32 shaderBufferFloat16AtomicAdd;
    VkBool32 shaderBufferFloat16AtomicMinMax;
    VkBool32 shaderBufferFloat32AtomicMinMax;
    VkBool32 shaderBufferFloat64AtomicMinMax;
    VkBool32 shaderSharedFloat16Atomics;
    VkBool32 shaderSharedFloat16AtomicAdd;
    VkBool32 shaderSharedFloat16AtomicMinMax;
    VkBool32 shaderSharedFloat32AtomicMinMax;
    VkBool32 shaderSharedFloat64AtomicMinMax;
    VkBool32 shaderImageFloat32AtomicMinMax;
    VkBool32 sparseImageFloat32AtomicMinMax;
}
