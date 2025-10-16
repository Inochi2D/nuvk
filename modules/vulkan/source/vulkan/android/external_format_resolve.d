/**
 * VK_ANDROID_external_format_resolve (Device)
 * 
 * Author:
 *     Google LLC
 * 
 * Platform:
 *     Android OS
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.android.external_format_resolve;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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

public import vulkan.android.external_memory_android_hardware_buffer;
version (Android):

enum VK_ANDROID_EXTERNAL_FORMAT_RESOLVE_SPEC_VERSION = 1;
enum VK_ANDROID_EXTERNAL_FORMAT_RESOLVE_EXTENSION_NAME = "VK_ANDROID_external_format_resolve";

struct VkPhysicalDeviceExternalFormatResolveFeaturesANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FORMAT_RESOLVE_FEATURES_ANDROID;
    void* pNext;
    VkBool32 externalFormatResolve;
}

struct VkPhysicalDeviceExternalFormatResolvePropertiesANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FORMAT_RESOLVE_PROPERTIES_ANDROID;
    void* pNext;
    VkBool32 nullColorAttachmentWithExternalFormatResolve;
    VkChromaLocation externalFormatResolveChromaOffsetX;
    VkChromaLocation externalFormatResolveChromaOffsetY;
}

struct VkAndroidHardwareBufferFormatResolvePropertiesANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_RESOLVE_PROPERTIES_ANDROID;
    void* pNext;
    VkFormat colorAttachmentFormat;
}
