/**
 * VK_KHR_shader_expect_assume
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.shader_expect_assume;

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

enum VK_KHR_SHADER_EXPECT_ASSUME_SPEC_VERSION = 1;
enum VK_KHR_SHADER_EXPECT_ASSUME_EXTENSION_NAME = "VK_KHR_shader_expect_assume";

alias VkPhysicalDeviceShaderExpectAssumeFeaturesKHR = VkPhysicalDeviceShaderExpectAssumeFeatures;
