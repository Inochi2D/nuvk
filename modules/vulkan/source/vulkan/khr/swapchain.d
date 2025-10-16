/**
 * VK_KHR_swapchain (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.swapchain;

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

public import vulkan.khr.surface;

struct VK_KHR_swapchain {
    
    @VkProcName("vkCreateSwapchainKHR")
    PFN_vkCreateSwapchainKHR vkCreateSwapchainKHR;
    
    @VkProcName("vkDestroySwapchainKHR")
    PFN_vkDestroySwapchainKHR vkDestroySwapchainKHR;
    
    @VkProcName("vkGetSwapchainImagesKHR")
    PFN_vkGetSwapchainImagesKHR vkGetSwapchainImagesKHR;
    
    @VkProcName("vkAcquireNextImageKHR")
    PFN_vkAcquireNextImageKHR vkAcquireNextImageKHR;
    
    @VkProcName("vkQueuePresentKHR")
    PFN_vkQueuePresentKHR vkQueuePresentKHR;
    
    version (VK_VERSION_1_1) {
        @VkProcName("vkGetDeviceGroupPresentCapabilitiesKHR")
        PFN_vkGetDeviceGroupPresentCapabilitiesKHR vkGetDeviceGroupPresentCapabilitiesKHR;
        
        @VkProcName("vkGetDeviceGroupSurfacePresentModesKHR")
        PFN_vkGetDeviceGroupSurfacePresentModesKHR vkGetDeviceGroupSurfacePresentModesKHR;
        
        @VkProcName("vkGetPhysicalDevicePresentRectanglesKHR")
        PFN_vkGetPhysicalDevicePresentRectanglesKHR vkGetPhysicalDevicePresentRectanglesKHR;
        
        @VkProcName("vkAcquireNextImage2KHR")
        PFN_vkAcquireNextImage2KHR vkAcquireNextImage2KHR;
    }
}

enum VK_KHR_SWAPCHAIN_SPEC_VERSION = 70;
enum VK_KHR_SWAPCHAIN_EXTENSION_NAME = "VK_KHR_swapchain";

enum VkSwapchainCreateFlagBitsKHR : uint {
    VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = 1,
    VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR = 2,
    VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR = 4,
    VK_SWAPCHAIN_CREATE_RESERVED_9_BIT_EXT = 512,
    VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT = VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR,
    VK_SWAPCHAIN_CREATE_RESERVED_5_BIT_EXT = 32,
    VK_SWAPCHAIN_CREATE_RESERVED_4_BIT_EXT = 16,
    VK_SWAPCHAIN_CREATE_PRESENT_ID_2_BIT_KHR = 64,
    VK_SWAPCHAIN_CREATE_PRESENT_WAIT_2_BIT_KHR = 128,
    VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR = 8,
    VK_SWAPCHAIN_CREATE_RESERVED_8_BIT_EXT = 256,
}

enum VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_RESERVED_9_BIT_EXT = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_RESERVED_9_BIT_EXT;
enum VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT = VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_RESERVED_5_BIT_EXT = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_RESERVED_5_BIT_EXT;
enum VK_SWAPCHAIN_CREATE_RESERVED_4_BIT_EXT = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_RESERVED_4_BIT_EXT;
enum VK_SWAPCHAIN_CREATE_PRESENT_ID_2_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_PRESENT_ID_2_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_PRESENT_WAIT_2_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_PRESENT_WAIT_2_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_RESERVED_8_BIT_EXT = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_RESERVED_8_BIT_EXT;

alias VkSwapchainCreateFlagsKHR = VkFlags;

struct VkSwapchainCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags flags;
    VkSurfaceKHR surface;
    uint minImageCount;
    VkFormat imageFormat;
    VkColorSpaceKHR imageColorSpace;
    VkExtent2D imageExtent;
    uint imageArrayLayers;
    VkFlags imageUsage;
    VkSharingMode imageSharingMode;
    uint queueFamilyIndexCount;
    const(uint)* pQueueFamilyIndices;
    VkSurfaceTransformFlagBitsKHR preTransform;
    VkCompositeAlphaFlagBitsKHR compositeAlpha;
    VkPresentModeKHR presentMode;
    VkBool32 clipped;
    VkSwapchainKHR oldSwapchain;
}

alias VkSwapchainKHR = OpaqueHandle!("VkSwapchainKHR");

struct VkPresentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
    const(void)* pNext;
    uint waitSemaphoreCount;
    const(VkSemaphore)* pWaitSemaphores;
    uint swapchainCount;
    const(VkSwapchainKHR)* pSwapchains;
    const(uint)* pImageIndices;
    VkResult* pResults;
}

alias PFN_vkCreateSwapchainKHR = VkResult function(
    VkDevice device,
    const(VkSwapchainCreateInfoKHR)* pCreateInfo,
    const(VkSwapchainCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSwapchainKHR* pSwapchain,
);

alias PFN_vkDestroySwapchainKHR = void function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetSwapchainImagesKHR = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    uint* pSwapchainImageCount,
    VkImage* pSwapchainImages,
);

alias PFN_vkAcquireNextImageKHR = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    ulong timeout,
    VkSemaphore semaphore,
    VkFence fence,
    uint* pImageIndex,
);

alias PFN_vkQueuePresentKHR = VkResult function(
    VkQueue queue,
    const(VkPresentInfoKHR)* pPresentInfo,
);

version (VK_VERSION_1_1):

struct VkImageSwapchainCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
}

struct VkBindImageMemorySwapchainInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    uint imageIndex;
}

struct VkAcquireNextImageInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    ulong timeout;
    VkSemaphore semaphore;
    VkFence fence;
    uint deviceMask;
}

enum VkDeviceGroupPresentModeFlagBitsKHR : uint {
    VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR = 1,
    VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR = 2,
    VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR = 4,
    VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = 8,
}

enum VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR;

alias VkDeviceGroupPresentModeFlagsKHR = VkFlags;

struct VkDeviceGroupPresentCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR;
    void* pNext;
    uint[VK_MAX_DEVICE_GROUP_SIZE] presentMask;
    VkFlags modes;
}

struct VkDeviceGroupPresentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_INFO_KHR;
    const(void)* pNext;
    uint swapchainCount;
    const(uint)* pDeviceMasks;
    VkDeviceGroupPresentModeFlagBitsKHR mode;
}

struct VkDeviceGroupSwapchainCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_GROUP_SWAPCHAIN_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags modes;
}

alias PFN_vkGetDeviceGroupPresentCapabilitiesKHR = VkResult function(
    VkDevice device,
    VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities,
);

alias PFN_vkGetDeviceGroupSurfacePresentModesKHR = VkResult function(
    VkDevice device,
    VkSurfaceKHR surface,
    VkDeviceGroupPresentModeFlagsKHR* pModes,
);

alias PFN_vkGetPhysicalDevicePresentRectanglesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    uint* pRectCount,
    VkRect2D* pRects,
);

alias PFN_vkAcquireNextImage2KHR = VkResult function(
    VkDevice device,
    const(VkAcquireNextImageInfoKHR)* pAcquireInfo,
    uint* pImageIndex,
);
