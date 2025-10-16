/**
 * VK_KHR_maintenance2
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance2;

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

enum VK_KHR_MAINTENANCE_2_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_2_EXTENSION_NAME = "VK_KHR_maintenance2";
deprecated("aliased")
enum VK_KHR_MAINTENANCE2_SPEC_VERSION = VK_KHR_MAINTENANCE_2_SPEC_VERSION;
deprecated("aliased")
enum VK_KHR_MAINTENANCE2_EXTENSION_NAME = VK_KHR_MAINTENANCE_2_EXTENSION_NAME;

alias VkPhysicalDevicePointClippingPropertiesKHR = VkPhysicalDevicePointClippingProperties;

alias VkPointClippingBehaviorKHR = VkPointClippingBehavior;

alias VkRenderPassInputAttachmentAspectCreateInfoKHR = VkRenderPassInputAttachmentAspectCreateInfo;

alias VkInputAttachmentAspectReferenceKHR = VkInputAttachmentAspectReference;

alias VkImageViewUsageCreateInfoKHR = VkImageViewUsageCreateInfo;

alias VkTessellationDomainOriginKHR = VkTessellationDomainOrigin;

alias VkPipelineTessellationDomainOriginStateCreateInfoKHR = VkPipelineTessellationDomainOriginStateCreateInfo;
