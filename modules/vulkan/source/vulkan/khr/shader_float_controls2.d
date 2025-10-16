/**
 * VK_KHR_shader_float_controls2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shader_float_controls2;

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

version (VK_VERSION_1_1):
public import vulkan.khr.shader_float_controls;

enum VK_KHR_SHADER_FLOAT_CONTROLS_2_SPEC_VERSION = 1;
enum VK_KHR_SHADER_FLOAT_CONTROLS_2_EXTENSION_NAME = "VK_KHR_shader_float_controls2";

alias VkPhysicalDeviceShaderFloatControls2FeaturesKHR = VkPhysicalDeviceShaderFloatControls2Features;
