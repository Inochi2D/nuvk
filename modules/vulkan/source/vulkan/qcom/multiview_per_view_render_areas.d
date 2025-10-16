/**
 * VK_QCOM_multiview_per_view_render_areas (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.multiview_per_view_render_areas;

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

enum VK_QCOM_MULTIVIEW_PER_VIEW_RENDER_AREAS_SPEC_VERSION = 1;
enum VK_QCOM_MULTIVIEW_PER_VIEW_RENDER_AREAS_EXTENSION_NAME = "VK_QCOM_multiview_per_view_render_areas";

struct VkPhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_RENDER_AREAS_FEATURES_QCOM;
    void* pNext;
    VkBool32 multiviewPerViewRenderAreas;
}

struct VkMultiviewPerViewRenderAreasRenderPassBeginInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_MULTIVIEW_PER_VIEW_RENDER_AREAS_RENDER_PASS_BEGIN_INFO_QCOM;
    const(void)* pNext;
    uint perViewRenderAreaCount;
    const(VkRect2D)* pPerViewRenderAreas;
}
