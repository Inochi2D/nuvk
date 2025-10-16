/**
 * VK_ARM_shader_core_properties
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.shader_core_properties;

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

version (VK_VERSION_1_1):

enum VK_ARM_SHADER_CORE_PROPERTIES_SPEC_VERSION = 1;
enum VK_ARM_SHADER_CORE_PROPERTIES_EXTENSION_NAME = "VK_ARM_shader_core_properties";

struct VkPhysicalDeviceShaderCorePropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_ARM;
    void* pNext;
    uint pixelRate;
    uint texelRate;
    uint fmaRate;
}
