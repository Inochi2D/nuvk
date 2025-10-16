/**
 * VK_EXT_external_memory_host (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.external_memory_host;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;

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

struct VK_EXT_external_memory_host {
    
    @VkProcName("vkGetMemoryHostPointerPropertiesEXT")
    PFN_vkGetMemoryHostPointerPropertiesEXT vkGetMemoryHostPointerPropertiesEXT;
}

enum VK_EXT_EXTERNAL_MEMORY_HOST_SPEC_VERSION = 1;
enum VK_EXT_EXTERNAL_MEMORY_HOST_EXTENSION_NAME = "VK_EXT_external_memory_host";

struct VkImportMemoryHostPointerInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_HOST_POINTER_INFO_EXT;
    const(void)* pNext;
    VkExternalMemoryHandleTypeFlagBits handleType;
    void* pHostPointer;
}

struct VkMemoryHostPointerPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_HOST_POINTER_PROPERTIES_EXT;
    void* pNext;
    uint memoryTypeBits;
}

struct VkPhysicalDeviceExternalMemoryHostPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_HOST_PROPERTIES_EXT;
    void* pNext;
    VkDeviceSize minImportedHostPointerAlignment;
}

alias PFN_vkGetMemoryHostPointerPropertiesEXT = VkResult function(
    VkDevice device,
    VkExternalMemoryHandleTypeFlagBits handleType,
    const(void)* pHostPointer,
    VkMemoryHostPointerPropertiesEXT* pMemoryHostPointerProperties,
);
