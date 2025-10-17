/**
 * VK_KHR_shader_maximal_reconvergence (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shader_maximal_reconvergence;

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


enum VK_KHR_SHADER_MAXIMAL_RECONVERGENCE_SPEC_VERSION = 1;
enum VK_KHR_SHADER_MAXIMAL_RECONVERGENCE_EXTENSION_NAME = "VK_KHR_shader_maximal_reconvergence";

struct VkPhysicalDeviceShaderMaximalReconvergenceFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MAXIMAL_RECONVERGENCE_FEATURES_KHR;
    void* pNext;
    VkBool32 shaderMaximalReconvergence;
}
