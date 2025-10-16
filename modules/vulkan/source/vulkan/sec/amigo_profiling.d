/**
 * VK_SEC_amigo_profiling (Device)
 * 
 * Author:
 *     Samsung Electronics Co., Ltd.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.sec.amigo_profiling;

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

enum VK_SEC_AMIGO_PROFILING_SPEC_VERSION = 1;
enum VK_SEC_AMIGO_PROFILING_EXTENSION_NAME = "VK_SEC_amigo_profiling";

struct VkPhysicalDeviceAmigoProfilingFeaturesSEC {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_AMIGO_PROFILING_FEATURES_SEC;
    void* pNext;
    VkBool32 amigoProfiling;
}

struct VkAmigoProfilingSubmitInfoSEC {
    VkStructureType sType = VK_STRUCTURE_TYPE_AMIGO_PROFILING_SUBMIT_INFO_SEC;
    const(void)* pNext;
    ulong firstDrawTimestamp;
    ulong swapBufferTimestamp;
}
