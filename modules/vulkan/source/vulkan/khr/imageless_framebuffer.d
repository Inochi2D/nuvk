/**
 * VK_KHR_imageless_framebuffer
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.imageless_framebuffer;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.image_format_list;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.maintenance2;
        public import vulkan.khr.get_physical_device_properties2;
    }
}

enum VK_KHR_IMAGELESS_FRAMEBUFFER_SPEC_VERSION = 1;
enum VK_KHR_IMAGELESS_FRAMEBUFFER_EXTENSION_NAME = "VK_KHR_imageless_framebuffer";

alias VkPhysicalDeviceImagelessFramebufferFeaturesKHR = VkPhysicalDeviceImagelessFramebufferFeatures;

alias VkFramebufferAttachmentsCreateInfoKHR = VkFramebufferAttachmentsCreateInfo;

alias VkFramebufferAttachmentImageInfoKHR = VkFramebufferAttachmentImageInfo;

alias VkRenderPassAttachmentBeginInfoKHR = VkRenderPassAttachmentBeginInfo;
