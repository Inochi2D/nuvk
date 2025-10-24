/**
 * VK_AMD_anti_lag (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.anti_lag;

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

struct VK_AMD_anti_lag {
    @VkProcName("vkAntiLagUpdateAMD")
    PFN_vkAntiLagUpdateAMD vkAntiLagUpdateAMD;
}

enum VK_AMD_ANTI_LAG_SPEC_VERSION = 1;
enum VK_AMD_ANTI_LAG_EXTENSION_NAME = "VK_AMD_anti_lag";

struct VkPhysicalDeviceAntiLagFeaturesAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ANTI_LAG_FEATURES_AMD;
    void* pNext;
    VkBool32 antiLag;
}

struct VkAntiLagDataAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANTI_LAG_DATA_AMD;
    const(void)* pNext;
    VkAntiLagModeAMD mode;
    uint maxFPS;
    const(VkAntiLagPresentationInfoAMD)* pPresentationInfo;
}

struct VkAntiLagPresentationInfoAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANTI_LAG_PRESENTATION_INFO_AMD;
    void* pNext;
    VkAntiLagStageAMD stage;
    ulong frameIndex;
}

alias VkAntiLagModeAMD = uint;
enum VkAntiLagModeAMD
    VK_ANTI_LAG_MODE_DRIVER_CONTROL_AMD = 0,
    VK_ANTI_LAG_MODE_ON_AMD = 1,
    VK_ANTI_LAG_MODE_OFF_AMD = 2;

alias VkAntiLagStageAMD = uint;
enum VkAntiLagStageAMD
    VK_ANTI_LAG_STAGE_INPUT_AMD = 0,
    VK_ANTI_LAG_STAGE_PRESENT_AMD = 1;

alias PFN_vkAntiLagUpdateAMD = void function(
    VkDevice device,
    const(VkAntiLagDataAMD)* pData,
);
