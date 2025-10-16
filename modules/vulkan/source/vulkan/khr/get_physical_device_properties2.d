/**
 * VK_KHR_get_physical_device_properties2
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.get_physical_device_properties2;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

struct VK_KHR_get_physical_device_properties2 {
    
    @VkProcName("vkGetPhysicalDeviceFeatures2")
    PFN_vkGetPhysicalDeviceFeatures2 vkGetPhysicalDeviceFeatures2;
    
    @VkProcName("vkGetPhysicalDeviceProperties2")
    PFN_vkGetPhysicalDeviceProperties2 vkGetPhysicalDeviceProperties2;
    
    @VkProcName("vkGetPhysicalDeviceFormatProperties2")
    PFN_vkGetPhysicalDeviceFormatProperties2 vkGetPhysicalDeviceFormatProperties2;
    
    @VkProcName("vkGetPhysicalDeviceImageFormatProperties2")
    PFN_vkGetPhysicalDeviceImageFormatProperties2 vkGetPhysicalDeviceImageFormatProperties2;
    
    @VkProcName("vkGetPhysicalDeviceQueueFamilyProperties2")
    PFN_vkGetPhysicalDeviceQueueFamilyProperties2 vkGetPhysicalDeviceQueueFamilyProperties2;
    
    @VkProcName("vkGetPhysicalDeviceMemoryProperties2")
    PFN_vkGetPhysicalDeviceMemoryProperties2 vkGetPhysicalDeviceMemoryProperties2;
    
    @VkProcName("vkGetPhysicalDeviceSparseImageFormatProperties2")
    PFN_vkGetPhysicalDeviceSparseImageFormatProperties2 vkGetPhysicalDeviceSparseImageFormatProperties2;
}

enum VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_SPEC_VERSION = 2;
enum VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME = "VK_KHR_get_physical_device_properties2";

alias VkPhysicalDeviceFeatures2KHR = VkPhysicalDeviceFeatures2;

alias VkPhysicalDeviceProperties2KHR = VkPhysicalDeviceProperties2;

alias VkFormatProperties2KHR = VkFormatProperties2;

alias VkImageFormatProperties2KHR = VkImageFormatProperties2;

alias VkPhysicalDeviceImageFormatInfo2KHR = VkPhysicalDeviceImageFormatInfo2;

alias VkQueueFamilyProperties2KHR = VkQueueFamilyProperties2;

alias VkPhysicalDeviceMemoryProperties2KHR = VkPhysicalDeviceMemoryProperties2;

alias VkSparseImageFormatProperties2KHR = VkSparseImageFormatProperties2;

alias VkPhysicalDeviceSparseImageFormatInfo2KHR = VkPhysicalDeviceSparseImageFormatInfo2;

alias PFN_vkGetPhysicalDeviceFeatures2 = void function(
    VkPhysicalDevice physicalDevice,
    VkPhysicalDeviceFeatures2* pFeatures,
);

alias PFN_vkGetPhysicalDeviceProperties2 = void function(
    VkPhysicalDevice physicalDevice,
    VkPhysicalDeviceProperties2* pProperties,
);

alias PFN_vkGetPhysicalDeviceFormatProperties2 = void function(
    VkPhysicalDevice physicalDevice,
    VkFormat format,
    VkFormatProperties2* pFormatProperties,
);

alias PFN_vkGetPhysicalDeviceImageFormatProperties2 = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceImageFormatInfo2)* pImageFormatInfo,
    VkImageFormatProperties2* pImageFormatProperties,
);

alias PFN_vkGetPhysicalDeviceQueueFamilyProperties2 = void function(
    VkPhysicalDevice physicalDevice,
    uint* pQueueFamilyPropertyCount,
    VkQueueFamilyProperties2* pQueueFamilyProperties,
);

alias PFN_vkGetPhysicalDeviceMemoryProperties2 = void function(
    VkPhysicalDevice physicalDevice,
    VkPhysicalDeviceMemoryProperties2* pMemoryProperties,
);

alias PFN_vkGetPhysicalDeviceSparseImageFormatProperties2 = void function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceSparseImageFormatInfo2)* pFormatInfo,
    uint* pPropertyCount,
    VkSparseImageFormatProperties2* pProperties,
);
