/**
 * VK_ARM_format_pack
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.format_pack;

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

enum VK_ARM_FORMAT_PACK_SPEC_VERSION = 1;
enum VK_ARM_FORMAT_PACK_EXTENSION_NAME = "VK_ARM_format_pack";

struct VkPhysicalDeviceFormatPackFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FORMAT_PACK_FEATURES_ARM;
    void* pNext;
    VkBool32 formatPack;
}
