/**
 * VK_FUCHSIA_buffer_collection (Device)
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
module vulkan.fuchsia.buffer_collection;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.sampler_ycbcr_conversion;
}
public import vulkan.fuchsia.external_memory;

struct VK_FUCHSIA_buffer_collection {
    
    @VkProcName("vkCreateBufferCollectionFUCHSIA")
    PFN_vkCreateBufferCollectionFUCHSIA vkCreateBufferCollectionFUCHSIA;
    
    @VkProcName("vkSetBufferCollectionImageConstraintsFUCHSIA")
    PFN_vkSetBufferCollectionImageConstraintsFUCHSIA vkSetBufferCollectionImageConstraintsFUCHSIA;
    
    @VkProcName("vkSetBufferCollectionBufferConstraintsFUCHSIA")
    PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA vkSetBufferCollectionBufferConstraintsFUCHSIA;
    
    @VkProcName("vkDestroyBufferCollectionFUCHSIA")
    PFN_vkDestroyBufferCollectionFUCHSIA vkDestroyBufferCollectionFUCHSIA;
    
    @VkProcName("vkGetBufferCollectionPropertiesFUCHSIA")
    PFN_vkGetBufferCollectionPropertiesFUCHSIA vkGetBufferCollectionPropertiesFUCHSIA;
    
}

enum VK_FUCHSIA_BUFFER_COLLECTION_SPEC_VERSION = 2;
enum VK_FUCHSIA_BUFFER_COLLECTION_EXTENSION_NAME = "VK_FUCHSIA_buffer_collection";

alias VkBufferCollectionFUCHSIA = OpaqueHandle!("VkBufferCollectionFUCHSIA");

struct VkBufferCollectionCreateInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CREATE_INFO_FUCHSIA;
    const(void)* pNext;
    zx_handle_t collectionToken;
}

struct VkImportMemoryBufferCollectionFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_BUFFER_COLLECTION_FUCHSIA;
    const(void)* pNext;
    VkBufferCollectionFUCHSIA collection;
    uint index;
}

struct VkBufferCollectionImageCreateInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_IMAGE_CREATE_INFO_FUCHSIA;
    const(void)* pNext;
    VkBufferCollectionFUCHSIA collection;
    uint index;
}

struct VkBufferConstraintsInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_CONSTRAINTS_INFO_FUCHSIA;
    const(void)* pNext;
    VkBufferCreateInfo createInfo;
    VkFlags requiredFormatFeatures;
    VkBufferCollectionConstraintsInfoFUCHSIA bufferCollectionConstraints;
}

struct VkBufferCollectionBufferCreateInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_BUFFER_CREATE_INFO_FUCHSIA;
    const(void)* pNext;
    VkBufferCollectionFUCHSIA collection;
    uint index;
}

struct VkBufferCollectionPropertiesFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_PROPERTIES_FUCHSIA;
    void* pNext;
    uint memoryTypeBits;
    uint bufferCount;
    uint createInfoIndex;
    ulong sysmemPixelFormat;
    VkFlags formatFeatures;
    VkSysmemColorSpaceFUCHSIA sysmemColorSpaceIndex;
    VkComponentMapping samplerYcbcrConversionComponents;
    VkSamplerYcbcrModelConversion suggestedYcbcrModel;
    VkSamplerYcbcrRange suggestedYcbcrRange;
    VkChromaLocation suggestedXChromaOffset;
    VkChromaLocation suggestedYChromaOffset;
}

alias VkImageFormatConstraintsFlagsFUCHSIA = VkFlags;

struct VkSysmemColorSpaceFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_SYSMEM_COLOR_SPACE_FUCHSIA;
    const(void)* pNext;
    uint colorSpace;
}

enum VkImageConstraintsInfoFlagBitsFUCHSIA : uint {
    VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA = 1,
    VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA = 2,
    VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA = 4,
    VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA = 8,
    VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA = 16,
}

enum VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA;
enum VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA;
enum VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA;
enum VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA;
enum VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA;

alias VkImageConstraintsInfoFlagsFUCHSIA = VkFlags;

struct VkImageConstraintsInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_CONSTRAINTS_INFO_FUCHSIA;
    const(void)* pNext;
    uint formatConstraintsCount;
    const(VkImageFormatConstraintsInfoFUCHSIA)* pFormatConstraints;
    VkBufferCollectionConstraintsInfoFUCHSIA bufferCollectionConstraints;
    VkFlags flags;
}

struct VkImageFormatConstraintsInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_FORMAT_CONSTRAINTS_INFO_FUCHSIA;
    const(void)* pNext;
    VkImageCreateInfo imageCreateInfo;
    VkFlags requiredFormatFeatures;
    VkFlags flags;
    ulong sysmemPixelFormat;
    uint colorSpaceCount;
    const(VkSysmemColorSpaceFUCHSIA)* pColorSpaces;
}

struct VkBufferCollectionConstraintsInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CONSTRAINTS_INFO_FUCHSIA;
    const(void)* pNext;
    uint minBufferCount;
    uint maxBufferCount;
    uint minBufferCountForCamping;
    uint minBufferCountForDedicatedSlack;
    uint minBufferCountForSharedSlack;
}

alias PFN_vkCreateBufferCollectionFUCHSIA = VkResult function(
    VkDevice device,
    const(VkBufferCollectionCreateInfoFUCHSIA)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkBufferCollectionFUCHSIA* pCollection,
);

alias PFN_vkSetBufferCollectionImageConstraintsFUCHSIA = VkResult function(
    VkDevice device,
    VkBufferCollectionFUCHSIA collection,
    const(VkImageConstraintsInfoFUCHSIA)* pImageConstraintsInfo,
);

alias PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA = VkResult function(
    VkDevice device,
    VkBufferCollectionFUCHSIA collection,
    const(VkBufferConstraintsInfoFUCHSIA)* pBufferConstraintsInfo,
);

alias PFN_vkDestroyBufferCollectionFUCHSIA = void function(
    VkDevice device,
    VkBufferCollectionFUCHSIA collection,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetBufferCollectionPropertiesFUCHSIA = VkResult function(
    VkDevice device,
    VkBufferCollectionFUCHSIA collection,
    VkBufferCollectionPropertiesFUCHSIA* pProperties,
);
