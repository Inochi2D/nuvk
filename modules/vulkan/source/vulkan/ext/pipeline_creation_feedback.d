/**
 * VK_EXT_pipeline_creation_feedback (Device)
 * 
 * Author:
 *     Google LLC
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.pipeline_creation_feedback;

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

enum VK_EXT_PIPELINE_CREATION_FEEDBACK_SPEC_VERSION = 1;
enum VK_EXT_PIPELINE_CREATION_FEEDBACK_EXTENSION_NAME = "VK_EXT_pipeline_creation_feedback";

alias VkPipelineCreationFeedbackFlagBitsEXT = VkPipelineCreationFeedbackFlags;

alias VkPipelineCreationFeedbackFlagsEXT = VkPipelineCreationFeedbackFlags;

alias VkPipelineCreationFeedbackCreateInfoEXT = VkPipelineCreationFeedbackCreateInfo;

alias VkPipelineCreationFeedbackEXT = VkPipelineCreationFeedback;
