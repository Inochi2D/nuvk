/**
 * VK_QNX_external_memory_screen_buffer (Device)
 * 
 * Author:
 *     BlackBerry Limited
 * 
 * Platform:
 *     QNX Screen Graphics Subsystem
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qnx.external_memory_screen_buffer;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.qnx;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.ext.queue_family_foreign;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.dedicated_allocation;
    public import vulkan.khr.external_memory;
    public import vulkan.khr.sampler_ycbcr_conversion;
}

struct VK_QNX_external_memory_screen_buffer {
    
    @VkProcName("vkGetScreenBufferPropertiesQNX")
    PFN_vkGetScreenBufferPropertiesQNX vkGetScreenBufferPropertiesQNX;
}

enum VK_QNX_EXTERNAL_MEMORY_SCREEN_BUFFER_SPEC_VERSION = 1;
enum VK_QNX_EXTERNAL_MEMORY_SCREEN_BUFFER_EXTENSION_NAME = "VK_QNX_external_memory_screen_buffer";

struct VkScreenBufferPropertiesQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_SCREEN_BUFFER_PROPERTIES_QNX;
    void* pNext;
    VkDeviceSize allocationSize;
    uint memoryTypeBits;
}

struct VkScreenBufferFormatPropertiesQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_SCREEN_BUFFER_FORMAT_PROPERTIES_QNX;
    void* pNext;
    VkFormat format;
    ulong externalFormat;
    ulong screenUsage;
    VkFlags formatFeatures;
    VkComponentMapping samplerYcbcrConversionComponents;
    VkSamplerYcbcrModelConversion suggestedYcbcrModel;
    VkSamplerYcbcrRange suggestedYcbcrRange;
    VkChromaLocation suggestedXChromaOffset;
    VkChromaLocation suggestedYChromaOffset;
}

struct VkImportScreenBufferInfoQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_SCREEN_BUFFER_INFO_QNX;
    const(void)* pNext;
    _screen_buffer* buffer;
}

struct VkExternalFormatQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_QNX;
    void* pNext;
    ulong externalFormat;
}

struct VkPhysicalDeviceExternalMemoryScreenBufferFeaturesQNX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_SCREEN_BUFFER_FEATURES_QNX;
    void* pNext;
    VkBool32 screenBufferImport;
}

alias PFN_vkGetScreenBufferPropertiesQNX = VkResult function(
    VkDevice device,
    _screen_buffer* buffer,
    VkScreenBufferPropertiesQNX* pProperties,
);
