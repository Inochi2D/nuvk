/**
 * VK_AMD_texture_gather_bias_lod (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.texture_gather_bias_lod;

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

enum VK_AMD_TEXTURE_GATHER_BIAS_LOD_SPEC_VERSION = 1;
enum VK_AMD_TEXTURE_GATHER_BIAS_LOD_EXTENSION_NAME = "VK_AMD_texture_gather_bias_lod";

struct VkTextureLODGatherFormatPropertiesAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_TEXTURE_LOD_GATHER_FORMAT_PROPERTIES_AMD;
    void* pNext;
    VkBool32 supportsTextureGatherLODBiasAMD;
}
