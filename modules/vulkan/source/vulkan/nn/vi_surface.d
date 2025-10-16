/**
 * VK_NN_vi_surface (Instance)
 * 
 * Author:
 *     Nintendo Co., Ltd.
 * 
 * Platform:
 *     Nintendo Vi
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nn.vi_surface;

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

public import vulkan.khr.surface;

struct VK_NN_vi_surface {
    
    @VkProcName("vkCreateViSurfaceNN")
    PFN_vkCreateViSurfaceNN vkCreateViSurfaceNN;
}

enum VK_NN_VI_SURFACE_SPEC_VERSION = 1;
enum VK_NN_VI_SURFACE_EXTENSION_NAME = "VK_NN_vi_surface";

alias VkViSurfaceCreateFlagsNN = VkFlags;

struct VkViSurfaceCreateInfoNN {
    VkStructureType sType = VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN;
    const(void)* pNext;
    VkFlags flags;
    void* window;
}

alias PFN_vkCreateViSurfaceNN = VkResult function(
    VkInstance instance,
    const(VkViSurfaceCreateInfoNN)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
