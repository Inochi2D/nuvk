/**
 * VK_KHR_external_fence (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.external_fence;

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

public import vulkan.khr.external_fence_capabilities;

enum VK_KHR_EXTERNAL_FENCE_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_FENCE_EXTENSION_NAME = "VK_KHR_external_fence";

alias VkFenceImportFlagsKHR = VkFenceImportFlags;

alias VkFenceImportFlagBitsKHR = VkFenceImportFlagBits;

alias VkExportFenceCreateInfoKHR = VkExportFenceCreateInfo;
