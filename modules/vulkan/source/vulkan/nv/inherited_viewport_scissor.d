/**
 * VK_NV_inherited_viewport_scissor
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.inherited_viewport_scissor;

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

enum VK_NV_INHERITED_VIEWPORT_SCISSOR_SPEC_VERSION = 1;
enum VK_NV_INHERITED_VIEWPORT_SCISSOR_EXTENSION_NAME = "VK_NV_inherited_viewport_scissor";

struct VkPhysicalDeviceInheritedViewportScissorFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INHERITED_VIEWPORT_SCISSOR_FEATURES_NV;
    void* pNext;
    VkBool32 inheritedViewportScissor2D;
}

struct VkCommandBufferInheritanceViewportScissorInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_VIEWPORT_SCISSOR_INFO_NV;
    const(void)* pNext;
    VkBool32 viewportScissor2D;
    uint viewportDepthCount;
    const(VkViewport)* pViewportDepths;
}
