/**
 * VK_KHR_unified_image_layouts (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.unified_image_layouts;

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

enum VK_KHR_UNIFIED_IMAGE_LAYOUTS_SPEC_VERSION = 1;
enum VK_KHR_UNIFIED_IMAGE_LAYOUTS_EXTENSION_NAME = "VK_KHR_unified_image_layouts";

struct VkPhysicalDeviceUnifiedImageLayoutsFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_UNIFIED_IMAGE_LAYOUTS_FEATURES_KHR;
    void* pNext;
    VkBool32 unifiedImageLayouts;
    VkBool32 unifiedImageLayoutsVideo;
}

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}
public import vulkan.ext.attachment_feedback_loop_layout;

struct VkAttachmentFeedbackLoopInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_ATTACHMENT_FEEDBACK_LOOP_INFO_EXT;
    const(void)* pNext;
    VkBool32 feedbackLoopEnable;
}
