/**
 * VK_EXT_pipeline_robustness
 * 
 * Author:
 *     Imagination Technologies
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.pipeline_robustness;

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

enum VK_EXT_PIPELINE_ROBUSTNESS_SPEC_VERSION = 1;
enum VK_EXT_PIPELINE_ROBUSTNESS_EXTENSION_NAME = "VK_EXT_pipeline_robustness";

alias VkPhysicalDevicePipelineRobustnessFeaturesEXT = VkPhysicalDevicePipelineRobustnessFeatures;

alias VkPhysicalDevicePipelineRobustnessPropertiesEXT = VkPhysicalDevicePipelineRobustnessProperties;

alias VkPipelineRobustnessCreateInfoEXT = VkPipelineRobustnessCreateInfo;

alias VkPipelineRobustnessBufferBehaviorEXT = VkPipelineRobustnessBufferBehavior;

alias VkPipelineRobustnessImageBehaviorEXT = VkPipelineRobustnessImageBehavior;
