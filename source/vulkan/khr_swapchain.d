/**
    vulkan_core.h (VkSwapchainKHR)
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr_swapchain;
import vulkan.core;

public import vulkan.khr_surface;
import numem.core.types : OpaqueHandle;

extern (System) @nogc nothrow:

/**
    A Vulkan Swapchain
*/
alias VkSwapchainKHR = OpaqueHandle!("VkSwapchainKHR");

enum uint VK_KHR_SWAPCHAIN_SPEC_VERSION = 70;
enum string VK_KHR_SWAPCHAIN_EXTENSION_NAME = "VK_KHR_swapchain";

alias VkSwapchainCreateFlagsKHR = VkFlags;
enum VkSwapchainCreateFlagsKHR VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = 0x00000001,
    VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR = 0x00000002,
    VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR = 0x00000004,
    VK_SWAPCHAIN_CREATE_PRESENT_ID_2_BIT_KHR = 0x00000040,
    VK_SWAPCHAIN_CREATE_PRESENT_WAIT_2_BIT_KHR = 0x00000080,
    VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR = 0x00000008,
    VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT = VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_KHR;

alias VkDeviceGroupPresentModeFlagsKHR = VkFlags;
enum VkDeviceGroupPresentModeFlagsKHR VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR = 0x00000001,
    VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR = 0x00000002,
    VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR = 0x00000004,
    VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = 0x00000008;

struct VkSwapchainCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSwapchainCreateFlagsKHR flags;
    VkSurfaceKHR surface;
    uint minImageCount;
    VkFormat imageFormat;
    VkColorSpaceKHR imageColorSpace;
    VkExtent2D imageExtent;
    uint imageArrayLayers;
    VkImageUsageFlags imageUsage;
    VkSharingMode imageSharingMode;
    uint queueFamilyIndexCount;
    const(uint)* pQueueFamilyIndices;
    VkSurfaceTransformFlagsKHR preTransform;
    VkCompositeAlphaFlagsKHR compositeAlpha;
    VkPresentModeKHR presentMode;
    VkBool32 clipped;
    VkSwapchainKHR oldSwapchain;
}

struct VkPresentInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint waitSemaphoreCount;
    const(VkSemaphore)* pWaitSemaphores;
    uint swapchainCount;
    const(VkSwapchainKHR)* pSwapchains;
    const(uint)* pImageIndices;
    VkResult* pResults;
}

struct VkImageSwapchainCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
}

struct VkBindImageMemorySwapchainInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    uint imageIndex;
}

struct VkAcquireNextImageInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    ulong timeout;
    VkSemaphore semaphore;
    VkFence fence;
    uint deviceMask;
}

struct VkDeviceGroupPresentCapabilitiesKHR {
    VkStructureType sType;
    void* pNext;
    uint[VK_MAX_DEVICE_GROUP_SIZE] presentMask;
    VkDeviceGroupPresentModeFlagsKHR modes;
}

struct VkDeviceGroupPresentInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    uint swapchainCount;
    const(uint)* pDeviceMasks;
    VkDeviceGroupPresentModeFlagsKHR mode;
}

struct VkDeviceGroupSwapchainCreateInfoKHR {
    VkStructureType sType;
    const(void)* pNext;
    VkDeviceGroupPresentModeFlagsKHR modes;
}

alias PFN_vkCreateSwapchainKHR = VkResult function(VkDevice device, const(VkSwapchainCreateInfoKHR)* pCreateInfo, const(
        VkAllocationCallbacks)* pAllocator, VkSwapchainKHR* pSwapchain);
alias PFN_vkDestroySwapchainKHR = void function(VkDevice device, VkSwapchainKHR swapchain, const(
        VkAllocationCallbacks)* pAllocator);
alias PFN_vkGetSwapchainImagesKHR = VkResult function(VkDevice device, VkSwapchainKHR swapchain, uint* pSwapchainImageCount, VkImage* pSwapchainImages);
alias PFN_vkAcquireNextImageKHR = VkResult function(VkDevice device, VkSwapchainKHR swapchain, ulong timeout, VkSemaphore semaphore, VkFence fence, uint* pImageIndex);
alias PFN_vkQueuePresentKHR = VkResult function(VkQueue queue, const(VkPresentInfoKHR)* pPresentInfo);
alias PFN_vkGetDeviceGroupPresentCapabilitiesKHR = VkResult function(VkDevice device, VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities);
alias PFN_vkGetDeviceGroupSurfacePresentModesKHR = VkResult function(VkDevice device, VkSurfaceKHR surface, VkDeviceGroupPresentModeFlagsKHR* pModes);
alias PFN_vkGetPhysicalDevicePresentRectanglesKHR = VkResult function(
    VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, uint* pRectCount, VkRect2D* pRects);
alias PFN_vkAcquireNextImage2KHR = VkResult function(VkDevice device, const(
        VkAcquireNextImageInfoKHR)* pAcquireInfo, uint* pImageIndex);

version(VK_KHR_swapchain) {
    extern VkResult vkCreateSwapchainKHR(VkDevice device, const(VkSwapchainCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSwapchainKHR* pSwapchain);
    extern void vkDestroySwapchainKHR(VkDevice device, VkSwapchainKHR swapchain, const(VkAllocationCallbacks)* pAllocator);
    extern VkResult vkGetSwapchainImagesKHR(VkDevice device, VkSwapchainKHR swapchain, uint* pSwapchainImageCount, VkImage* pSwapchainImages);
    extern VkResult vkAcquireNextImageKHR(VkDevice device, VkSwapchainKHR swapchain, ulong timeout, VkSemaphore semaphore, VkFence fence, uint* pImageIndex);
    extern VkResult vkQueuePresentKHR(VkQueue queue, const(VkPresentInfoKHR)* pPresentInfo);
    extern VkResult vkGetDeviceGroupPresentCapabilitiesKHR(VkDevice device, VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities);
    extern VkResult vkGetDeviceGroupSurfacePresentModesKHR(VkDevice device, VkSurfaceKHR surface, VkDeviceGroupPresentModeFlagsKHR* pModes);
    extern VkResult vkGetPhysicalDevicePresentRectanglesKHR( VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, uint* pRectCount, VkRect2D* pRects);
    extern VkResult vkAcquireNextImage2KHR(VkDevice device, const(VkAcquireNextImageInfoKHR)* pAcquireInfo, uint* pImageIndex);
}