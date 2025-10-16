/**
 * VK_EXT_primitive_topology_list_restart
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.primitive_topology_list_restart;

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

enum VK_EXT_PRIMITIVE_TOPOLOGY_LIST_RESTART_SPEC_VERSION = 1;
enum VK_EXT_PRIMITIVE_TOPOLOGY_LIST_RESTART_EXTENSION_NAME = "VK_EXT_primitive_topology_list_restart";

struct VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIMITIVE_TOPOLOGY_LIST_RESTART_FEATURES_EXT;
    void* pNext;
    VkBool32 primitiveTopologyListRestart;
    VkBool32 primitiveTopologyPatchListRestart;
}
