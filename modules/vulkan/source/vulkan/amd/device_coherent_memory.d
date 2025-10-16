/**
 * VK_AMD_device_coherent_memory (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.device_coherent_memory;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_AMD_DEVICE_COHERENT_MEMORY_SPEC_VERSION = 1;
enum VK_AMD_DEVICE_COHERENT_MEMORY_EXTENSION_NAME = "VK_AMD_device_coherent_memory";

struct VkPhysicalDeviceCoherentMemoryFeaturesAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COHERENT_MEMORY_FEATURES_AMD;
    void* pNext;
    VkBool32 deviceCoherentMemory;
}
