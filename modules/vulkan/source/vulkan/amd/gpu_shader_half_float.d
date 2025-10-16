/**
 * VK_AMD_gpu_shader_half_float (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.gpu_shader_half_float;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.shader_float16_int8;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

enum VK_AMD_GPU_SHADER_HALF_FLOAT_SPEC_VERSION = 2;
enum VK_AMD_GPU_SHADER_HALF_FLOAT_EXTENSION_NAME = "VK_AMD_gpu_shader_half_float";
