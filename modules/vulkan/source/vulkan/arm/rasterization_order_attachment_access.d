/**
 * VK_ARM_rasterization_order_attachment_access
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.rasterization_order_attachment_access;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.ext.rasterization_order_attachment_access;

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

enum VK_ARM_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_SPEC_VERSION = 1;
enum VK_ARM_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_EXTENSION_NAME = "VK_ARM_rasterization_order_attachment_access";

alias VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesARM = VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT;
