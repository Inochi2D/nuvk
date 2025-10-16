/**
 * VK_KHR_surface_protected_capabilities
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.surface_protected_capabilities;

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
public import vulkan.khr.get_surface_capabilities2;

enum VK_KHR_SURFACE_PROTECTED_CAPABILITIES_SPEC_VERSION = 1;
enum VK_KHR_SURFACE_PROTECTED_CAPABILITIES_EXTENSION_NAME = "VK_KHR_surface_protected_capabilities";

struct VkSurfaceProtectedCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_PROTECTED_CAPABILITIES_KHR;
    const(void)* pNext;
    VkBool32 supportsProtected;
}
