/**
 * VK_KHR_format_feature_flags2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.format_feature_flags2;

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

enum VK_KHR_FORMAT_FEATURE_FLAGS_2_SPEC_VERSION = 2;
enum VK_KHR_FORMAT_FEATURE_FLAGS_2_EXTENSION_NAME = "VK_KHR_format_feature_flags2";

alias VkFormatFeatureFlags2KHR = VkFormatFeatureFlags2;

alias VkFormatFeatureFlagBits2KHR = VkFormatFeatureFlagBits2;

alias VkFormatProperties3KHR = VkFormatProperties3;
