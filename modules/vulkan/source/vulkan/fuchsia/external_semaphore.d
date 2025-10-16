/**
 * VK_FUCHSIA_external_semaphore (Device)
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
module vulkan.fuchsia.external_semaphore;

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

public import vulkan.khr.external_semaphore;
public import vulkan.khr.external_semaphore_capabilities;

struct VK_FUCHSIA_external_semaphore {
    
    @VkProcName("vkImportSemaphoreZirconHandleFUCHSIA")
    PFN_vkImportSemaphoreZirconHandleFUCHSIA vkImportSemaphoreZirconHandleFUCHSIA;
    
    @VkProcName("vkGetSemaphoreZirconHandleFUCHSIA")
    PFN_vkGetSemaphoreZirconHandleFUCHSIA vkGetSemaphoreZirconHandleFUCHSIA;
}

enum VK_FUCHSIA_EXTERNAL_SEMAPHORE_SPEC_VERSION = 1;
enum VK_FUCHSIA_EXTERNAL_SEMAPHORE_EXTENSION_NAME = "VK_FUCHSIA_external_semaphore";

struct VkImportSemaphoreZirconHandleInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_ZIRCON_HANDLE_INFO_FUCHSIA;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkFlags flags;
    VkExternalSemaphoreHandleTypeFlagBits handleType;
    zx_handle_t zirconHandle;
}

struct VkSemaphoreGetZirconHandleInfoFUCHSIA {
    VkStructureType sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkExternalSemaphoreHandleTypeFlagBits handleType;
}

alias PFN_vkImportSemaphoreZirconHandleFUCHSIA = VkResult function(
    VkDevice device,
    const(VkImportSemaphoreZirconHandleInfoFUCHSIA)* pImportSemaphoreZirconHandleInfo,
);

alias PFN_vkGetSemaphoreZirconHandleFUCHSIA = VkResult function(
    VkDevice device,
    const(VkSemaphoreGetZirconHandleInfoFUCHSIA)* pGetZirconHandleInfo,
    zx_handle_t* pZirconHandle,
);
