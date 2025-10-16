/**
 * VK_QCOM_image_processing (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.image_processing;

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
    public import vulkan.khr.format_feature_flags2;
}

enum VK_QCOM_IMAGE_PROCESSING_SPEC_VERSION = 1;
enum VK_QCOM_IMAGE_PROCESSING_EXTENSION_NAME = "VK_QCOM_image_processing";

struct VkImageViewSampleWeightCreateInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_SAMPLE_WEIGHT_CREATE_INFO_QCOM;
    const(void)* pNext;
    VkOffset2D filterCenter;
    VkExtent2D filterSize;
    uint numPhases;
}

struct VkPhysicalDeviceImageProcessingFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_FEATURES_QCOM;
    void* pNext;
    VkBool32 textureSampleWeighted;
    VkBool32 textureBoxFilter;
    VkBool32 textureBlockMatch;
}

struct VkPhysicalDeviceImageProcessingPropertiesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_PROPERTIES_QCOM;
    void* pNext;
    uint maxWeightFilterPhases;
    VkExtent2D maxWeightFilterDimension;
    VkExtent2D maxBlockMatchRegion;
    VkExtent2D maxBoxFilterBlockSize;
}
