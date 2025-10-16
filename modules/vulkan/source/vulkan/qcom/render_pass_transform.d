/**
 * VK_QCOM_render_pass_transform
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
import vulkan.loader;
import vulkan.core;
import vulkan.khr.surface;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

enum VK_QCOM_RENDER_PASS_TRANSFORM_SPEC_VERSION = 5;
enum VK_QCOM_RENDER_PASS_TRANSFORM_EXTENSION_NAME = "VK_QCOM_render_pass_transform";

struct VkRenderPassTransformBeginInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_TRANSFORM_BEGIN_INFO_QCOM;
    const(void)* pNext;
    VkSurfaceTransformFlagBitsKHR transform;
}

struct VkCommandBufferInheritanceRenderPassTransformInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_RENDER_PASS_TRANSFORM_INFO_QCOM;
    const(void)* pNext;
    VkSurfaceTransformFlagBitsKHR transform;
    VkRect2D renderArea;
}
