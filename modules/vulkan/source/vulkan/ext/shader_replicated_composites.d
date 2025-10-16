/**
 * VK_EXT_shader_replicated_composites (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.shader_replicated_composites;

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

enum VK_EXT_SHADER_REPLICATED_COMPOSITES_SPEC_VERSION = 1;
enum VK_EXT_SHADER_REPLICATED_COMPOSITES_EXTENSION_NAME = "VK_EXT_shader_replicated_composites";

struct VkPhysicalDeviceShaderReplicatedCompositesFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_REPLICATED_COMPOSITES_FEATURES_EXT;
    void* pNext;
    VkBool32 shaderReplicatedComposites;
}
