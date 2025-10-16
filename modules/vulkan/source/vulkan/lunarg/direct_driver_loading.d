/**
 * VK_LUNARG_direct_driver_loading (Instance)
 * 
 * Author:
 *     LunarG, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.lunarg.direct_driver_loading;

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

enum VK_LUNARG_DIRECT_DRIVER_LOADING_SPEC_VERSION = 1;
enum VK_LUNARG_DIRECT_DRIVER_LOADING_EXTENSION_NAME = "VK_LUNARG_direct_driver_loading";

alias VkDirectDriverLoadingFlagsLUNARG = VkFlags;

enum VkDirectDriverLoadingModeLUNARG {
    VK_DIRECT_DRIVER_LOADING_MODE_EXCLUSIVE_LUNARG = 0,
    VK_DIRECT_DRIVER_LOADING_MODE_INCLUSIVE_LUNARG = 1,
}

enum VK_DIRECT_DRIVER_LOADING_MODE_EXCLUSIVE_LUNARG = VkDirectDriverLoadingModeLUNARG.VK_DIRECT_DRIVER_LOADING_MODE_EXCLUSIVE_LUNARG;
enum VK_DIRECT_DRIVER_LOADING_MODE_INCLUSIVE_LUNARG = VkDirectDriverLoadingModeLUNARG.VK_DIRECT_DRIVER_LOADING_MODE_INCLUSIVE_LUNARG;

struct VkDirectDriverLoadingInfoLUNARG {
    VkStructureType sType = VK_STRUCTURE_TYPE_DIRECT_DRIVER_LOADING_INFO_LUNARG;
    void* pNext;
    VkFlags flags;
    PFN_vkGetInstanceProcAddrLUNARG pfnGetInstanceProcAddr;
}

struct VkDirectDriverLoadingListLUNARG {
    VkStructureType sType = VK_STRUCTURE_TYPE_DIRECT_DRIVER_LOADING_LIST_LUNARG;
    const(void)* pNext;
    VkDirectDriverLoadingModeLUNARG mode;
    uint driverCount;
    const(VkDirectDriverLoadingInfoLUNARG)* pDrivers;
}

alias PFN_vkGetInstanceProcAddrLUNARG = PFN_vkVoidFunction function(
    VkInstance instance,
    const(char)* pName,
);
