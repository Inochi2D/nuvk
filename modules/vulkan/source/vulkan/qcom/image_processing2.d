/**
 * VK_QCOM_image_processing2 (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.image_processing2;

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

public import vulkan.qcom.image_processing;

enum VK_QCOM_IMAGE_PROCESSING_2_SPEC_VERSION = 1;
enum VK_QCOM_IMAGE_PROCESSING_2_EXTENSION_NAME = "VK_QCOM_image_processing2";

struct VkPhysicalDeviceImageProcessing2FeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_2_FEATURES_QCOM;
    void* pNext;
    VkBool32 textureBlockMatch2;
}

struct VkPhysicalDeviceImageProcessing2PropertiesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_2_PROPERTIES_QCOM;
    void* pNext;
    VkExtent2D maxBlockMatchWindow;
}

struct VkSamplerBlockMatchWindowCreateInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLER_BLOCK_MATCH_WINDOW_CREATE_INFO_QCOM;
    const(void)* pNext;
    VkExtent2D windowExtent;
    VkBlockMatchWindowCompareModeQCOM windowCompareMode;
}

alias VkBlockMatchWindowCompareModeQCOM = uint;
enum VkBlockMatchWindowCompareModeQCOM
    VK_BLOCK_MATCH_WINDOW_COMPARE_MODE_MIN_QCOM = 0,
    VK_BLOCK_MATCH_WINDOW_COMPARE_MODE_MAX_QCOM = 1;
