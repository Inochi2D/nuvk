/**
 * VK_EXT_validation_flags (Instance)
 * 
 * Author:
 *     Google LLC
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.validation_flags;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.ext.layer_settings;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

enum VK_EXT_VALIDATION_FLAGS_SPEC_VERSION = 3;
enum VK_EXT_VALIDATION_FLAGS_EXTENSION_NAME = "VK_EXT_validation_flags";

struct VkValidationFlagsEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VALIDATION_FLAGS_EXT;
    const(void)* pNext;
    uint disabledValidationCheckCount;
    const(VkValidationCheckEXT)* pDisabledValidationChecks;
}

enum VkValidationCheckEXT {
    VK_VALIDATION_CHECK_ALL_EXT = 0,
    VK_VALIDATION_CHECK_SHADERS_EXT = 1,
}

enum VK_VALIDATION_CHECK_ALL_EXT = VkValidationCheckEXT.VK_VALIDATION_CHECK_ALL_EXT;
enum VK_VALIDATION_CHECK_SHADERS_EXT = VkValidationCheckEXT.VK_VALIDATION_CHECK_SHADERS_EXT;
