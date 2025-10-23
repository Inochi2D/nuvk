/**
 * VK_EXT_device_memory_report (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.device_memory_report;

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
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_EXT_DEVICE_MEMORY_REPORT_SPEC_VERSION = 2;
enum VK_EXT_DEVICE_MEMORY_REPORT_EXTENSION_NAME = "VK_EXT_device_memory_report";

struct VkPhysicalDeviceDeviceMemoryReportFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_MEMORY_REPORT_FEATURES_EXT;
    void* pNext;
    VkBool32 deviceMemoryReport;
}

struct VkDeviceDeviceMemoryReportCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_DEVICE_MEMORY_REPORT_CREATE_INFO_EXT;
    const(void)* pNext;
    VkDeviceMemoryReportFlagsEXT flags;
    PFN_vkDeviceMemoryReportCallbackEXT pfnUserCallback;
    void* pUserData;
}

struct VkDeviceMemoryReportCallbackDataEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_MEMORY_REPORT_CALLBACK_DATA_EXT;
    void* pNext;
    VkDeviceMemoryReportFlagsEXT flags;
    VkDeviceMemoryReportEventTypeEXT type;
    ulong memoryObjectId;
    VkDeviceSize size;
    VkObjectType objectType;
    ulong objectHandle;
    uint heapIndex;
}

alias VkDeviceMemoryReportFlagsEXT = VkFlags;

alias VkDeviceMemoryReportEventTypeEXT = uint;
enum VkDeviceMemoryReportEventTypeEXT
    VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_ALLOCATE_EXT = 0,
    VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_FREE_EXT = 1,
    VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_IMPORT_EXT = 2,
    VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_UNIMPORT_EXT = 3,
    VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_ALLOCATION_FAILED_EXT = 4;

alias PFN_vkDeviceMemoryReportCallbackEXT = void function(
    const(VkDeviceMemoryReportCallbackDataEXT)* pCallbackData,
    void* pUserData,
);
