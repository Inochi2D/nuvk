/**
 * VK_OHOS_surface (Instance)
 * 
 * Author:
 *     Huawei Technologies Co. Ltd.
 * 
 * Platform:
 *     Open Harmony OS
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ohos.surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.ohos;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_OHOS_surface {
    
    @VkProcName("vkCreateSurfaceOHOS")
    PFN_vkCreateSurfaceOHOS vkCreateSurfaceOHOS;
}

enum VK_OHOS_SURFACE_SPEC_VERSION = 1;
enum VK_OHOS_SURFACE_EXTENSION_NAME = "VK_OHOS_surface";

alias VkSurfaceCreateFlagsOHOS = VkFlags;

struct VkSurfaceCreateInfoOHOS {
    VkStructureType sType = VK_STRUCTURE_TYPE_SURFACE_CREATE_INFO_OHOS;
    const(void)* pNext;
    VkFlags flags;
    OHNativeWindow* window;
}


alias PFN_vkCreateSurfaceOHOS = VkResult function(
    VkInstance instance,
    const(VkSurfaceCreateInfoOHOS)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
