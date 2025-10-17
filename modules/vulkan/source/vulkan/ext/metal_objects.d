/**
 * VK_EXT_metal_objects (Device)
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
module vulkan.ext.metal_objects;

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

struct VK_EXT_metal_objects {
    
    @VkProcName("vkExportMetalObjectsEXT")
    PFN_vkExportMetalObjectsEXT vkExportMetalObjectsEXT;
}

enum VK_EXT_METAL_OBJECTS_SPEC_VERSION = 2;
enum VK_EXT_METAL_OBJECTS_EXTENSION_NAME = "VK_EXT_metal_objects";

enum VkExportMetalObjectTypeFlagBitsEXT : uint {
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT = 1,
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT = 2,
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT = 4,
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT = 8,
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT = 16,
    VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT = 32,
}

enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT;
enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT;
enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT;
enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT;
enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT;
enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT;

alias VkExportMetalObjectTypeFlagsEXT = VkBitFlagsBase!(VkFlags, VkExportMetalObjectTypeFlagBitsEXT);

struct VkExportMetalObjectCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECT_CREATE_INFO_EXT;
    const(void)* pNext;
    VkExportMetalObjectTypeFlagBitsEXT exportObjectType;
}

struct VkExportMetalObjectsInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECTS_INFO_EXT;
    const(void)* pNext;
}

struct VkExportMetalDeviceInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_DEVICE_INFO_EXT;
    const(void)* pNext;
    MTLDevice_id mtlDevice;
}

struct VkExportMetalCommandQueueInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_COMMAND_QUEUE_INFO_EXT;
    const(void)* pNext;
    VkQueue queue;
    MTLCommandQueue_id mtlCommandQueue;
}

struct VkExportMetalBufferInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_BUFFER_INFO_EXT;
    const(void)* pNext;
    VkDeviceMemory memory;
    MTLBuffer_id mtlBuffer;
}

struct VkImportMetalBufferInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_METAL_BUFFER_INFO_EXT;
    const(void)* pNext;
    MTLBuffer_id mtlBuffer;
}

struct VkExportMetalTextureInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_TEXTURE_INFO_EXT;
    const(void)* pNext;
    VkImage image;
    VkImageView imageView;
    VkBufferView bufferView;
    VkImageAspectFlagBits plane;
    MTLTexture_id mtlTexture;
}

struct VkImportMetalTextureInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_METAL_TEXTURE_INFO_EXT;
    const(void)* pNext;
    VkImageAspectFlagBits plane;
    MTLTexture_id mtlTexture;
}

struct VkExportMetalIOSurfaceInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_IO_SURFACE_INFO_EXT;
    const(void)* pNext;
    VkImage image;
    IOSurfaceRef ioSurface;
}

struct VkImportMetalIOSurfaceInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_METAL_IO_SURFACE_INFO_EXT;
    const(void)* pNext;
    IOSurfaceRef ioSurface;
}

struct VkExportMetalSharedEventInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXPORT_METAL_SHARED_EVENT_INFO_EXT;
    const(void)* pNext;
    VkSemaphore semaphore;
    VkEvent event;
    MTLSharedEvent_id mtlSharedEvent;
}

struct VkImportMetalSharedEventInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMPORT_METAL_SHARED_EVENT_INFO_EXT;
    const(void)* pNext;
    MTLSharedEvent_id mtlSharedEvent;
}


alias PFN_vkExportMetalObjectsEXT = void function(
    VkDevice device,
    VkExportMetalObjectsInfoEXT* pMetalObjectsInfo,
);
