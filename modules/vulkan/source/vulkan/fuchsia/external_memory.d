/**
 * VK_FUCHSIA_external_memory
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
module vulkan.fuchsia.external_memory;

import numem.core.types : OpaqueHandle;
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
    public import vulkan.khr.external_memory;
    public import vulkan.khr.external_memory_capabilities;
}

struct VK_FUCHSIA_external_memory {
    
    @VkProcName("vkGetMemoryZirconHandleFUCHSIA")
    PFN_vkGetMemoryZirconHandleFUCHSIA vkGetMemoryZirconHandleFUCHSIA;
    
    @VkProcName("vkGetMemoryZirconHandlePropertiesFUCHSIA")
    PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA vkGetMemoryZirconHandlePropertiesFUCHSIA;
}

enum VK_FUCHSIA_EXTERNAL_MEMORY_SPEC_VERSION = 1;
enum VK_FUCHSIA_EXTERNAL_MEMORY_EXTENSION_NAME = "VK_FUCHSIA_external_memory";

struct VkImportMemoryZirconHandleInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_ZIRCON_HANDLE_INFO_FUCHSIA;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagBits handleType;
    zx_handle_t handle;
}

struct VkMemoryZirconHandlePropertiesFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_ZIRCON_HANDLE_PROPERTIES_FUCHSIA;
    void* pNext;
    uint memoryTypeBits;
}

struct VkMemoryGetZirconHandleInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
    const(void)* pNext;
    VkDeviceMemory memory;
    VkExternalMemoryHandleTypeFlagBits handleType;
}

alias PFN_vkGetMemoryZirconHandleFUCHSIA = VkResult function(
    VkDevice device,
    const(VkMemoryGetZirconHandleInfoFUCHSIA)* pGetZirconHandleInfo,
    zx_handle_t* pZirconHandle,
);

alias PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA = VkResult function(
    VkDevice device,
    VkExternalMemoryHandleTypeFlagBits handleType,
    zx_handle_t zirconHandle,
    VkMemoryZirconHandlePropertiesFUCHSIA* pMemoryZirconHandleProperties,
);
