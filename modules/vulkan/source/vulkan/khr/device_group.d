/**
 * VK_KHR_device_group (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.device_group;

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

public import vulkan.khr.device_group_creation;

struct VK_KHR_device_group {
    
    @VkProcName("vkGetDeviceGroupPeerMemoryFeatures")
    PFN_vkGetDeviceGroupPeerMemoryFeatures vkGetDeviceGroupPeerMemoryFeatures;
    
    @VkProcName("vkCmdSetDeviceMask")
    PFN_vkCmdSetDeviceMask vkCmdSetDeviceMask;
    
    @VkProcName("vkCmdDispatchBase")
    PFN_vkCmdDispatchBase vkCmdDispatchBase;
    
    
    @VkProcName("vkGetDeviceGroupPresentCapabilitiesKHR")
    PFN_vkGetDeviceGroupPresentCapabilitiesKHR vkGetDeviceGroupPresentCapabilitiesKHR;
    
    @VkProcName("vkGetDeviceGroupSurfacePresentModesKHR")
    PFN_vkGetDeviceGroupSurfacePresentModesKHR vkGetDeviceGroupSurfacePresentModesKHR;
    
    @VkProcName("vkGetPhysicalDevicePresentRectanglesKHR")
    PFN_vkGetPhysicalDevicePresentRectanglesKHR vkGetPhysicalDevicePresentRectanglesKHR;
    
    @VkProcName("vkAcquireNextImage2KHR")
    PFN_vkAcquireNextImage2KHR vkAcquireNextImage2KHR;
}

enum VK_KHR_DEVICE_GROUP_SPEC_VERSION = 4;
enum VK_KHR_DEVICE_GROUP_EXTENSION_NAME = "VK_KHR_device_group";

alias VkPeerMemoryFeatureFlagsKHR = VkPeerMemoryFeatureFlags;

alias VkPeerMemoryFeatureFlagBitsKHR = VkPeerMemoryFeatureFlagBits;

alias VkMemoryAllocateFlagsKHR = VkMemoryAllocateFlags;

alias VkMemoryAllocateFlagBitsKHR = VkMemoryAllocateFlagBits;

alias VkMemoryAllocateFlagsInfoKHR = VkMemoryAllocateFlagsInfo;

alias VkDeviceGroupRenderPassBeginInfoKHR = VkDeviceGroupRenderPassBeginInfo;

alias VkDeviceGroupCommandBufferBeginInfoKHR = VkDeviceGroupCommandBufferBeginInfo;

alias VkDeviceGroupSubmitInfoKHR = VkDeviceGroupSubmitInfo;

alias VkDeviceGroupBindSparseInfoKHR = VkDeviceGroupBindSparseInfo;

alias PFN_vkGetDeviceGroupPeerMemoryFeatures = void function(
    VkDevice device,
    uint heapIndex,
    uint localDeviceIndex,
    uint remoteDeviceIndex,
    VkPeerMemoryFeatureFlags* pPeerMemoryFeatures,
);

alias PFN_vkCmdSetDeviceMask = void function(
    VkCommandBuffer commandBuffer,
    uint deviceMask,
);

alias PFN_vkCmdDispatchBase = void function(
    VkCommandBuffer commandBuffer,
    uint baseGroupX,
    uint baseGroupY,
    uint baseGroupZ,
    uint groupCountX,
    uint groupCountY,
    uint groupCountZ,
);

public import vulkan.khr.bind_memory2;

alias VkBindBufferMemoryDeviceGroupInfoKHR = VkBindBufferMemoryDeviceGroupInfo;

alias VkBindImageMemoryDeviceGroupInfoKHR = VkBindImageMemoryDeviceGroupInfo;

public import vulkan.khr.surface;

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

alias VkDeviceGroupPresentModeFlagsKHR = VkBitFlagsBase!(VkFlags, VkDeviceGroupPresentModeFlagBitsKHR);

struct VkDeviceGroupPresentCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR;
    void* pNext;
    uint[VK_MAX_DEVICE_GROUP_SIZE] presentMask;
    VkFlags modes;
}

alias PFN_vkGetDeviceGroupPresentCapabilitiesKHR = VkResult function(
    VkDevice device,
    VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities,
);

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkGetDeviceGroupSurfacePresentModesKHR = VkResult function(
    VkDevice device,
    VkSurfaceKHR surface,
    VkDeviceGroupPresentModeFlagsKHR* pModes,
);

import vulkan.khr.surface : VkSurfaceKHR;
alias PFN_vkGetPhysicalDevicePresentRectanglesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    VkSurfaceKHR surface,
    uint* pRectCount,
    VkRect2D* pRects,
);

public import vulkan.khr.swapchain;

import vulkan.khr.swapchain : VkSwapchainKHR;
struct VkImageSwapchainCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
struct VkBindImageMemorySwapchainInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    uint imageIndex;
}

import vulkan.khr.swapchain : VkSwapchainKHR;
struct VkAcquireNextImageInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR;
    const(void)* pNext;
    VkSwapchainKHR swapchain;
    ulong timeout;
    VkSemaphore semaphore;
    VkFence fence;
    uint deviceMask;
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

alias PFN_vkAcquireNextImage2KHR = VkResult function(
    VkDevice device,
    const(VkAcquireNextImageInfoKHR)* pAcquireInfo,
    uint* pImageIndex,
);
