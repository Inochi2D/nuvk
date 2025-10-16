/**
 * VK_KHR_android_surface (Instance)
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     Android OS
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.android_surface;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.android;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.surface;
version (Android):

struct VK_KHR_android_surface {
    
    @VkProcName("vkCreateAndroidSurfaceKHR")
    PFN_vkCreateAndroidSurfaceKHR vkCreateAndroidSurfaceKHR;
}

enum VK_KHR_ANDROID_SURFACE_SPEC_VERSION = 6;
enum VK_KHR_ANDROID_SURFACE_EXTENSION_NAME = "VK_KHR_android_surface";


alias VkAndroidSurfaceCreateFlagsKHR = VkFlags;

struct VkAndroidSurfaceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    ANativeWindow* window;
}

alias PFN_vkCreateAndroidSurfaceKHR = VkResult function(
    VkInstance instance,
    const(VkAndroidSurfaceCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSurfaceKHR* pSurface,
);
