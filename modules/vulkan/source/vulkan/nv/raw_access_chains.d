/**
 * VK_NV_raw_access_chains
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.raw_access_chains;

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

enum VK_NV_RAW_ACCESS_CHAINS_SPEC_VERSION = 1;
enum VK_NV_RAW_ACCESS_CHAINS_EXTENSION_NAME = "VK_NV_raw_access_chains";

struct VkPhysicalDeviceRawAccessChainsFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAW_ACCESS_CHAINS_FEATURES_NV;
    void* pNext;
    VkBool32 shaderRawAccessChains;
}
