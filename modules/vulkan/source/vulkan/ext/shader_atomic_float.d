/**
 * VK_EXT_shader_atomic_float
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.shader_atomic_float;

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

enum VK_EXT_SHADER_ATOMIC_FLOAT_SPEC_VERSION = 1;
enum VK_EXT_SHADER_ATOMIC_FLOAT_EXTENSION_NAME = "VK_EXT_shader_atomic_float";

struct VkPhysicalDeviceShaderAtomicFloatFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_FEATURES_EXT;
    void* pNext;
    VkBool32 shaderBufferFloat32Atomics;
    VkBool32 shaderBufferFloat32AtomicAdd;
    VkBool32 shaderBufferFloat64Atomics;
    VkBool32 shaderBufferFloat64AtomicAdd;
    VkBool32 shaderSharedFloat32Atomics;
    VkBool32 shaderSharedFloat32AtomicAdd;
    VkBool32 shaderSharedFloat64Atomics;
    VkBool32 shaderSharedFloat64AtomicAdd;
    VkBool32 shaderImageFloat32Atomics;
    VkBool32 shaderImageFloat32AtomicAdd;
    VkBool32 sparseImageFloat32Atomics;
    VkBool32 sparseImageFloat32AtomicAdd;
}
