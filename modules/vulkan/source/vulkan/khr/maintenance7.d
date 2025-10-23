/**
 * VK_KHR_maintenance7 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance7;

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


enum VK_KHR_MAINTENANCE_7_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_7_EXTENSION_NAME = "VK_KHR_maintenance7";

struct VkPhysicalDeviceMaintenance7FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_7_FEATURES_KHR;
    void* pNext;
    VkBool32 maintenance7;
}

struct VkPhysicalDeviceMaintenance7PropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_7_PROPERTIES_KHR;
    void* pNext;
    VkBool32 robustFragmentShadingRateAttachmentAccess;
    VkBool32 separateDepthStencilAttachmentAccess;
    uint maxDescriptorSetTotalUniformBuffersDynamic;
    uint maxDescriptorSetTotalStorageBuffersDynamic;
    uint maxDescriptorSetTotalBuffersDynamic;
    uint maxDescriptorSetUpdateAfterBindTotalUniformBuffersDynamic;
    uint maxDescriptorSetUpdateAfterBindTotalStorageBuffersDynamic;
    uint maxDescriptorSetUpdateAfterBindTotalBuffersDynamic;
}

struct VkPhysicalDeviceLayeredApiPropertiesListKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_PROPERTIES_LIST_KHR;
    void* pNext;
    uint layeredApiCount;
    VkPhysicalDeviceLayeredApiPropertiesKHR* pLayeredApis;
}

struct VkPhysicalDeviceLayeredApiPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_PROPERTIES_KHR;
    void* pNext;
    uint vendorID;
    uint deviceID;
    VkPhysicalDeviceLayeredApiKHR layeredAPI;
    char[VK_MAX_PHYSICAL_DEVICE_NAME_SIZE] deviceName;
}

alias VkPhysicalDeviceLayeredApiKHR = uint;
enum VkPhysicalDeviceLayeredApiKHR
    VK_PHYSICAL_DEVICE_LAYERED_API_VULKAN_KHR = 0,
    VK_PHYSICAL_DEVICE_LAYERED_API_D3D12_KHR = 1,
    VK_PHYSICAL_DEVICE_LAYERED_API_METAL_KHR = 2,
    VK_PHYSICAL_DEVICE_LAYERED_API_OPENGL_KHR = 3,
    VK_PHYSICAL_DEVICE_LAYERED_API_OPENGLES_KHR = 4;

struct VkPhysicalDeviceLayeredApiVulkanPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_VULKAN_PROPERTIES_KHR;
    void* pNext;
    VkPhysicalDeviceProperties2 properties;
}
