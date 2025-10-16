/**
 * VK_QCOM_filter_cubic_weights
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.filter_cubic_weights;

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

public import vulkan.ext.filter_cubic;

enum VK_QCOM_FILTER_CUBIC_WEIGHTS_SPEC_VERSION = 1;
enum VK_QCOM_FILTER_CUBIC_WEIGHTS_EXTENSION_NAME = "VK_QCOM_filter_cubic_weights";

struct VkPhysicalDeviceCubicWeightsFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUBIC_WEIGHTS_FEATURES_QCOM;
    void* pNext;
    VkBool32 selectableCubicWeights;
}

struct VkSamplerCubicWeightsCreateInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLER_CUBIC_WEIGHTS_CREATE_INFO_QCOM;
    const(void)* pNext;
    VkCubicFilterWeightsQCOM cubicWeights;
}

struct VkBlitImageCubicWeightsInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_BLIT_IMAGE_CUBIC_WEIGHTS_INFO_QCOM;
    const(void)* pNext;
    VkCubicFilterWeightsQCOM cubicWeights;
}

enum VkCubicFilterWeightsQCOM {
    VK_CUBIC_FILTER_WEIGHTS_CATMULL_ROM_QCOM = 0,
    VK_CUBIC_FILTER_WEIGHTS_ZERO_TANGENT_CARDINAL_QCOM = 1,
    VK_CUBIC_FILTER_WEIGHTS_B_SPLINE_QCOM = 2,
    VK_CUBIC_FILTER_WEIGHTS_MITCHELL_NETRAVALI_QCOM = 3,
}

enum VK_CUBIC_FILTER_WEIGHTS_CATMULL_ROM_QCOM = VkCubicFilterWeightsQCOM.VK_CUBIC_FILTER_WEIGHTS_CATMULL_ROM_QCOM;
enum VK_CUBIC_FILTER_WEIGHTS_ZERO_TANGENT_CARDINAL_QCOM = VkCubicFilterWeightsQCOM.VK_CUBIC_FILTER_WEIGHTS_ZERO_TANGENT_CARDINAL_QCOM;
enum VK_CUBIC_FILTER_WEIGHTS_B_SPLINE_QCOM = VkCubicFilterWeightsQCOM.VK_CUBIC_FILTER_WEIGHTS_B_SPLINE_QCOM;
enum VK_CUBIC_FILTER_WEIGHTS_MITCHELL_NETRAVALI_QCOM = VkCubicFilterWeightsQCOM.VK_CUBIC_FILTER_WEIGHTS_MITCHELL_NETRAVALI_QCOM;
