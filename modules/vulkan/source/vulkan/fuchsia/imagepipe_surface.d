/**
 * VK_FUCHSIA_imagepipe_surface (Instance)
 * 
 * Author:
 *     Google LLC
 * 
 * Platform:
 *     Fuchsia
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.fuchsia.imagepipe_surface;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.fuchsia;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;

struct VK_FUCHSIA_imagepipe_surface {
    
    @VkProcName("vkCreateImagePipeSurfaceFUCHSIA")
    PFN_vkCreateImagePipeSurfaceFUCHSIA vkCreateImagePipeSurfaceFUCHSIA;
}

enum VK_FUCHSIA_IMAGEPIPE_SURFACE_SPEC_VERSION = 1;
enum VK_FUCHSIA_IMAGEPIPE_SURFACE_EXTENSION_NAME = "VK_FUCHSIA_imagepipe_surface";

alias VkImagePipeSurfaceCreateFlagsFUCHSIA = VkFlags;

struct VkImagePipeSurfaceCreateInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA;
    const(void)* pNext;
    VkFlags flags;
    zx_handle_t imagePipeHandle;
}

alias PFN_vkCreateImagePipeSurfaceFUCHSIA = VkResult function(
    VkInstance instance,
    const(VkImagePipeSurfaceCreateInfoFUCHSIA)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
