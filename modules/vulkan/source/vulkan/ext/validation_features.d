/**
 * VK_EXT_validation_features (Instance)
 * 
 * Author:
 *     LunarG, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.validation_features;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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

enum VK_EXT_VALIDATION_FEATURES_SPEC_VERSION = 6;
enum VK_EXT_VALIDATION_FEATURES_EXTENSION_NAME = "VK_EXT_validation_features";

struct VkValidationFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VALIDATION_FEATURES_EXT;
    const(void)* pNext;
    uint enabledValidationFeatureCount;
    const(VkValidationFeatureEnableEXT)* pEnabledValidationFeatures;
    uint disabledValidationFeatureCount;
    const(VkValidationFeatureDisableEXT)* pDisabledValidationFeatures;
}

alias VkValidationFeatureEnableEXT = uint;
enum VkValidationFeatureEnableEXT
    VK_VALIDATION_FEATURE_ENABLE_GPU_ASSISTED_EXT = 0,
    VK_VALIDATION_FEATURE_ENABLE_GPU_ASSISTED_RESERVE_BINDING_SLOT_EXT = 1,
    VK_VALIDATION_FEATURE_ENABLE_BEST_PRACTICES_EXT = 2,
    VK_VALIDATION_FEATURE_ENABLE_DEBUG_PRINTF_EXT = 3,
    VK_VALIDATION_FEATURE_ENABLE_SYNCHRONIZATION_VALIDATION_EXT = 4;

alias VkValidationFeatureDisableEXT = uint;
enum VkValidationFeatureDisableEXT
    VK_VALIDATION_FEATURE_DISABLE_ALL_EXT = 0,
    VK_VALIDATION_FEATURE_DISABLE_SHADERS_EXT = 1,
    VK_VALIDATION_FEATURE_DISABLE_THREAD_SAFETY_EXT = 2,
    VK_VALIDATION_FEATURE_DISABLE_API_PARAMETERS_EXT = 3,
    VK_VALIDATION_FEATURE_DISABLE_OBJECT_LIFETIMES_EXT = 4,
    VK_VALIDATION_FEATURE_DISABLE_CORE_CHECKS_EXT = 5,
    VK_VALIDATION_FEATURE_DISABLE_UNIQUE_HANDLES_EXT = 6,
    VK_VALIDATION_FEATURE_DISABLE_SHADER_VALIDATION_CACHE_EXT = 7;
