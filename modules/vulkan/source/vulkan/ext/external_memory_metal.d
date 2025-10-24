/**
 * VK_EXT_external_memory_metal (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Platform:
 *     Metal on CoreAnimation on Apple platforms
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.external_memory_metal;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.platforms.metal;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.external_memory;
}

struct VK_EXT_external_memory_metal {
    @VkProcName("vkGetMemoryMetalHandleEXT")
    PFN_vkGetMemoryMetalHandleEXT vkGetMemoryMetalHandleEXT;
    
    @VkProcName("vkGetMemoryMetalHandlePropertiesEXT")
    PFN_vkGetMemoryMetalHandlePropertiesEXT vkGetMemoryMetalHandlePropertiesEXT;
}

enum VK_EXT_EXTERNAL_MEMORY_METAL_SPEC_VERSION = 1;
enum VK_EXT_EXTERNAL_MEMORY_METAL_EXTENSION_NAME = "VK_EXT_external_memory_metal";

struct VkImportMemoryMetalHandleInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_METAL_HANDLE_INFO_EXT;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlags handleType;
    void* handle;
}

struct VkMemoryMetalHandlePropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_METAL_HANDLE_PROPERTIES_EXT;
    void* pNext;
    uint memoryTypeBits;
}

struct VkMemoryGetMetalHandleInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_METAL_HANDLE_INFO_EXT;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlags handleType;
}

alias PFN_vkGetMemoryMetalHandleEXT = VkResult function(
    VkDevice device,
    const(VkMemoryGetMetalHandleInfoEXT)* pGetMetalHandleInfo,
    void** pHandle,
);

alias PFN_vkGetMemoryMetalHandlePropertiesEXT = VkResult function(
    VkDevice device,
    VkExternalMemoryHandleTypeFlags handleType,
    const(void)* pHandle,
    VkMemoryMetalHandlePropertiesEXT* pMemoryMetalHandleProperties,
);
