/**
 * VK_KHR_shader_quad_control (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shader_quad_control;

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

public import vulkan.khr.shader_maximal_reconvergence;
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.vulkan_memory_model;
}

enum VK_KHR_SHADER_QUAD_CONTROL_SPEC_VERSION = 1;
enum VK_KHR_SHADER_QUAD_CONTROL_EXTENSION_NAME = "VK_KHR_shader_quad_control";

struct VkPhysicalDeviceShaderQuadControlFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_QUAD_CONTROL_FEATURES_KHR;
    void* pNext;
    VkBool32 shaderQuadControl;
}
