/**
    VK_KHR_get_physical_device_properties2
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.get_physical_device_properties2;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_SPEC_VERSION = 2;
enum string VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME = "VK_KHR_get_physical_device_properties2";

alias VkPhysicalDeviceFeatures2KHR = VkPhysicalDeviceFeatures2;
alias VkPhysicalDeviceProperties2KHR = VkPhysicalDeviceProperties2;
alias VkFormatProperties2KHR = VkFormatProperties2;
alias VkImageFormatProperties2KHR = VkImageFormatProperties2;
alias VkPhysicalDeviceImageFormatInfo2KHR = VkPhysicalDeviceImageFormatInfo2;
alias VkQueueFamilyProperties2KHR = VkQueueFamilyProperties2;
alias VkPhysicalDeviceMemoryProperties2KHR = VkPhysicalDeviceMemoryProperties2;
alias VkSparseImageFormatProperties2KHR = VkSparseImageFormatProperties2;
alias VkPhysicalDeviceSparseImageFormatInfo2KHR = VkPhysicalDeviceSparseImageFormatInfo2;

alias PFN_vkGetPhysicalDeviceFeatures2KHR = void function(
    VkPhysicalDevice physicalDevice, VkPhysicalDeviceFeatures2* pFeatures);
alias PFN_vkGetPhysicalDeviceProperties2KHR = void function(
    VkPhysicalDevice physicalDevice, VkPhysicalDeviceProperties2* pProperties);
alias PFN_vkGetPhysicalDeviceFormatProperties2KHR = void function(
    VkPhysicalDevice physicalDevice, VkFormat format, VkFormatProperties2* pFormatProperties);
alias PFN_vkGetPhysicalDeviceImageFormatProperties2KHR = VkResult function(VkPhysicalDevice physicalDevice, const(
        VkPhysicalDeviceImageFormatInfo2)* pImageFormatInfo, VkImageFormatProperties2* pImageFormatProperties);
alias PFN_vkGetPhysicalDeviceQueueFamilyProperties2KHR = void function(VkPhysicalDevice physicalDevice, uint* pQueueFamilyPropertyCount, VkQueueFamilyProperties2* pQueueFamilyProperties);
alias PFN_vkGetPhysicalDeviceMemoryProperties2KHR = void function(
    VkPhysicalDevice physicalDevice, VkPhysicalDeviceMemoryProperties2* pMemoryProperties);
alias PFN_vkGetPhysicalDeviceSparseImageFormatProperties2KHR = void function(VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceSparseImageFormatInfo2)* pFormatInfo, uint* pPropertyCount, VkSparseImageFormatProperties2* pProperties);
