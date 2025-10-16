/**
 * VK_ANDROID_external_memory_android_hardware_buffer
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
module vulkan.android.external_memory_android_hardware_buffer;

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

public import vulkan.ext.queue_family_foreign;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.dedicated_allocation;
    public import vulkan.khr.external_memory;
    public import vulkan.khr.sampler_ycbcr_conversion;
}
version (Android):

struct VK_ANDROID_external_memory_android_hardware_buffer {
    
    @VkProcName("vkGetAndroidHardwareBufferPropertiesANDROID")
    PFN_vkGetAndroidHardwareBufferPropertiesANDROID vkGetAndroidHardwareBufferPropertiesANDROID;
    
    @VkProcName("vkGetMemoryAndroidHardwareBufferANDROID")
    PFN_vkGetMemoryAndroidHardwareBufferANDROID vkGetMemoryAndroidHardwareBufferANDROID;
}

enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_SPEC_VERSION = 5;
enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_EXTENSION_NAME = "VK_ANDROID_external_memory_android_hardware_buffer";

struct VkAndroidHardwareBufferUsageANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID;
    void* pNext;
    ulong androidHardwareBufferUsage;
}

struct VkAndroidHardwareBufferPropertiesANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID;
    void* pNext;
    VkDeviceSize allocationSize;
    uint memoryTypeBits;
}

struct VkAndroidHardwareBufferFormatPropertiesANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID;
    void* pNext;
    VkFormat format;
    ulong externalFormat;
    VkFlags formatFeatures;
    VkComponentMapping samplerYcbcrConversionComponents;
    VkSamplerYcbcrModelConversion suggestedYcbcrModel;
    VkSamplerYcbcrRange suggestedYcbcrRange;
    VkChromaLocation suggestedXChromaOffset;
    VkChromaLocation suggestedYChromaOffset;
}

struct VkImportAndroidHardwareBufferInfoANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
    const(void)* pNext;
    AHardwareBuffer* buffer;
}

struct VkMemoryGetAndroidHardwareBufferInfoANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
    const(void)* pNext;
    VkDeviceMemory memory;
}

struct VkExternalFormatANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID;
    void* pNext;
    ulong externalFormat;
}


alias PFN_vkGetAndroidHardwareBufferPropertiesANDROID = VkResult function(
    VkDevice device,
    AHardwareBuffer* buffer,
    VkAndroidHardwareBufferPropertiesANDROID* pProperties,
);

alias PFN_vkGetMemoryAndroidHardwareBufferANDROID = VkResult function(
    VkDevice device,
    const(VkMemoryGetAndroidHardwareBufferInfoANDROID)* pInfo,
    AHardwareBuffer** pBuffer,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.format_feature_flags2;
}

struct VkAndroidHardwareBufferFormatProperties2ANDROID {
    VkStructureType sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_2_ANDROID;
    void* pNext;
    VkFormat format;
    ulong externalFormat;
    VkFlags64 formatFeatures;
    VkComponentMapping samplerYcbcrConversionComponents;
    VkSamplerYcbcrModelConversion suggestedYcbcrModel;
    VkSamplerYcbcrRange suggestedYcbcrRange;
    VkChromaLocation suggestedXChromaOffset;
    VkChromaLocation suggestedYChromaOffset;
}
