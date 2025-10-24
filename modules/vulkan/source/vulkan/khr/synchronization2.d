/**
 * VK_KHR_synchronization2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.synchronization2;

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

struct VK_KHR_synchronization2 {
    @VkProcName("vkCmdSetEvent2")
    PFN_vkCmdSetEvent2 vkCmdSetEvent2;
    
    @VkProcName("vkCmdResetEvent2")
    PFN_vkCmdResetEvent2 vkCmdResetEvent2;
    
    @VkProcName("vkCmdWaitEvents2")
    PFN_vkCmdWaitEvents2 vkCmdWaitEvents2;
    
    @VkProcName("vkCmdPipelineBarrier2")
    PFN_vkCmdPipelineBarrier2 vkCmdPipelineBarrier2;
    
    @VkProcName("vkCmdWriteTimestamp2")
    PFN_vkCmdWriteTimestamp2 vkCmdWriteTimestamp2;
    
    @VkProcName("vkQueueSubmit2")
    PFN_vkQueueSubmit2 vkQueueSubmit2;
    
    
    
    
    
    
    
    
    
    
    
    
    
}

enum VK_KHR_SYNCHRONIZATION_2_SPEC_VERSION = 1;
enum VK_KHR_SYNCHRONIZATION_2_EXTENSION_NAME = "VK_KHR_synchronization2";

alias VkFlags64 = ulong;

alias VkPipelineStageFlags2KHR = VkPipelineStageFlags2;

alias VkPipelineStageFlagBits2KHR = VkPipelineStageFlags2;

alias VkAccessFlags2KHR = VkAccessFlags2;

alias VkAccessFlagBits2KHR = VkAccessFlags2;

alias VkMemoryBarrier2KHR = VkMemoryBarrier2;

alias VkBufferMemoryBarrier2KHR = VkBufferMemoryBarrier2;

alias VkImageMemoryBarrier2KHR = VkImageMemoryBarrier2;

alias VkDependencyInfoKHR = VkDependencyInfo;

alias VkSubmitInfo2KHR = VkSubmitInfo2;

alias VkSemaphoreSubmitInfoKHR = VkSemaphoreSubmitInfo;

alias VkCommandBufferSubmitInfoKHR = VkCommandBufferSubmitInfo;

alias VkSubmitFlagBitsKHR = VkSubmitFlags;

alias VkSubmitFlagsKHR = VkSubmitFlags;

alias VkPhysicalDeviceSynchronization2FeaturesKHR = VkPhysicalDeviceSynchronization2Features;

alias PFN_vkCmdSetEvent2 = void function(
    VkCommandBuffer commandBuffer,
    VkEvent event,
    const(VkDependencyInfo)* pDependencyInfo,
);

alias PFN_vkCmdResetEvent2 = void function(
    VkCommandBuffer commandBuffer,
    VkEvent event,
    VkPipelineStageFlags2 stageMask,
);

alias PFN_vkCmdWaitEvents2 = void function(
    VkCommandBuffer commandBuffer,
    uint eventCount,
    const(VkEvent)* pEvents,
    const(VkDependencyInfo)* pDependencyInfos,
);

alias PFN_vkCmdPipelineBarrier2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkDependencyInfo)* pDependencyInfo,
);

alias PFN_vkCmdWriteTimestamp2 = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineStageFlags2 stage,
    VkQueryPool queryPool,
    uint query,
);

alias PFN_vkQueueSubmit2 = VkResult function(
    VkQueue queue,
    uint submitCount,
    const(VkSubmitInfo2)* pSubmits,
    VkFence fence,
);
