/**
 * VK_ARM_render_pass_striped (Device)
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.render_pass_striped;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

enum VK_ARM_RENDER_PASS_STRIPED_SPEC_VERSION = 1;
enum VK_ARM_RENDER_PASS_STRIPED_EXTENSION_NAME = "VK_ARM_render_pass_striped";

struct VkPhysicalDeviceRenderPassStripedFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RENDER_PASS_STRIPED_FEATURES_ARM;
    void* pNext;
    VkBool32 renderPassStriped;
}

struct VkPhysicalDeviceRenderPassStripedPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RENDER_PASS_STRIPED_PROPERTIES_ARM;
    void* pNext;
    VkExtent2D renderPassStripeGranularity;
    uint maxRenderPassStripes;
}

struct VkRenderPassStripeBeginInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_BEGIN_INFO_ARM;
    const(void)* pNext;
    uint stripeInfoCount;
    const(VkRenderPassStripeInfoARM)* pStripeInfos;
}

struct VkRenderPassStripeInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_INFO_ARM;
    const(void)* pNext;
    VkRect2D stripeArea;
}

struct VkRenderPassStripeSubmitInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_SUBMIT_INFO_ARM;
    const(void)* pNext;
    uint stripeSemaphoreInfoCount;
    const(VkSemaphoreSubmitInfo)* pStripeSemaphoreInfos;
}
