/**
    VK_KHR_device_group
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.device_group;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_DEVICE_GROUP_SPEC_VERSION = 4;
enum string VK_KHR_DEVICE_GROUP_EXTENSION_NAME = "VK_KHR_device_group";

alias VkPeerMemoryFeatureFlagsKHR = VkPeerMemoryFeatureFlags;
alias VkPeerMemoryFeatureFlagBitsKHR = VkPeerMemoryFeatureFlags;
alias VkMemoryAllocateFlagsKHR = VkMemoryAllocateFlags;
alias VkMemoryAllocateFlagBitsKHR = VkMemoryAllocateFlags;
alias VkMemoryAllocateFlagsInfoKHR = VkMemoryAllocateFlagsInfo;
alias VkDeviceGroupRenderPassBeginInfoKHR = VkDeviceGroupRenderPassBeginInfo;
alias VkDeviceGroupCommandBufferBeginInfoKHR = VkDeviceGroupCommandBufferBeginInfo;
alias VkDeviceGroupSubmitInfoKHR = VkDeviceGroupSubmitInfo;
alias VkDeviceGroupBindSparseInfoKHR = VkDeviceGroupBindSparseInfo;
alias VkBindBufferMemoryDeviceGroupInfoKHR = VkBindBufferMemoryDeviceGroupInfo;
alias VkBindImageMemoryDeviceGroupInfoKHR = VkBindImageMemoryDeviceGroupInfo;

alias PFN_vkGetDeviceGroupPeerMemoryFeaturesKHR = void function(VkDevice device, uint heapIndex, uint localDeviceIndex, uint remoteDeviceIndex, VkPeerMemoryFeatureFlags* pPeerMemoryFeatures);
alias PFN_vkCmdSetDeviceMaskKHR = void function(VkCommandBuffer commandBuffer, uint deviceMask);
alias PFN_vkCmdDispatchBaseKHR = void function(VkCommandBuffer commandBuffer, uint baseGroupX, uint baseGroupY, uint baseGroupZ, uint groupCountX, uint groupCountY, uint groupCountZ);