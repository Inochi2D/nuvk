/**
 * VK_QCOM_ycbcr_degamma (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.ycbcr_degamma;

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

enum VK_QCOM_YCBCR_DEGAMMA_SPEC_VERSION = 1;
enum VK_QCOM_YCBCR_DEGAMMA_EXTENSION_NAME = "VK_QCOM_ycbcr_degamma";

struct VkPhysicalDeviceYcbcrDegammaFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_YCBCR_DEGAMMA_FEATURES_QCOM;
    void* pNext;
    VkBool32 ycbcrDegamma;
}

struct VkSamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_YCBCR_DEGAMMA_CREATE_INFO_QCOM;
    void* pNext;
    VkBool32 enableYDegamma;
    VkBool32 enableCbCrDegamma;
}
