/**
 * VK_KHR_spirv_1_4
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.spirv_1_4;

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

version (VK_VERSION_1_1):
public import vulkan.khr.shader_float_controls;

enum VK_KHR_SPIRV_1_4_SPEC_VERSION = 1;
enum VK_KHR_SPIRV_1_4_EXTENSION_NAME = "VK_KHR_spirv_1_4";
