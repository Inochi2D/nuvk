/**
 * VK_KHR_shader_bfloat16 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shader_bfloat16;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_KHR_SHADER_BFLOAT16_SPEC_VERSION = 1;
enum VK_KHR_SHADER_BFLOAT16_EXTENSION_NAME = "VK_KHR_shader_bfloat16";

struct VkPhysicalDeviceShaderBfloat16FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_BFLOAT16_FEATURES_KHR;
    void* pNext;
    VkBool32 shaderBFloat16Type;
    VkBool32 shaderBFloat16DotProduct;
    VkBool32 shaderBFloat16CooperativeMatrix;
}
