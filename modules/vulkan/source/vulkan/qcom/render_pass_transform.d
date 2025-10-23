/**
 * VK_QCOM_render_pass_transform (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.render_pass_transform;

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

enum VK_QCOM_RENDER_PASS_TRANSFORM_SPEC_VERSION = 5;
enum VK_QCOM_RENDER_PASS_TRANSFORM_EXTENSION_NAME = "VK_QCOM_render_pass_transform";

import vulkan.khr.surface : VkSurfaceTransformFlagsKHR;
struct VkRenderPassTransformBeginInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_TRANSFORM_BEGIN_INFO_QCOM;
    const(void)* pNext;
    VkSurfaceTransformFlagsKHR transform;
}

import vulkan.khr.surface : VkSurfaceTransformFlagsKHR;
struct VkCommandBufferInheritanceRenderPassTransformInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_RENDER_PASS_TRANSFORM_INFO_QCOM;
    const(void)* pNext;
    VkSurfaceTransformFlagsKHR transform;
    VkRect2D renderArea;
}
