/**
 * VK_KHR_maintenance5 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance5;

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

version (VK_VERSION_1_3) {} else {
    version (VK_VERSION_1_1):
    public import vulkan.khr.dynamic_rendering;
}

struct VK_KHR_maintenance5 {
    
    @VkProcName("vkCmdBindIndexBuffer2")
    PFN_vkCmdBindIndexBuffer2 vkCmdBindIndexBuffer2;
    
    @VkProcName("vkGetRenderingAreaGranularity")
    PFN_vkGetRenderingAreaGranularity vkGetRenderingAreaGranularity;
    
    @VkProcName("vkGetDeviceImageSubresourceLayout")
    PFN_vkGetDeviceImageSubresourceLayout vkGetDeviceImageSubresourceLayout;
    
    @VkProcName("vkGetImageSubresourceLayout2")
    PFN_vkGetImageSubresourceLayout2 vkGetImageSubresourceLayout2;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

enum VK_KHR_MAINTENANCE_5_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_5_EXTENSION_NAME = "VK_KHR_maintenance5";

alias VkPhysicalDeviceMaintenance5FeaturesKHR = VkPhysicalDeviceMaintenance5Features;

alias VkPhysicalDeviceMaintenance5PropertiesKHR = VkPhysicalDeviceMaintenance5Properties;

alias VkRenderingAreaInfoKHR = VkRenderingAreaInfo;

alias VkDeviceImageSubresourceInfoKHR = VkDeviceImageSubresourceInfo;

alias VkImageSubresource2KHR = VkImageSubresource2;

alias VkSubresourceLayout2KHR = VkSubresourceLayout2;

alias PFN_vkCmdBindIndexBuffer2 = void function(
    VkCommandBuffer commandBuffer,
    VkBuffer buffer,
    VkDeviceSize offset,
    VkDeviceSize size,
    VkIndexType indexType,
);

alias PFN_vkGetRenderingAreaGranularity = void function(
    VkDevice device,
    const(VkRenderingAreaInfo)* pRenderingAreaInfo,
    VkExtent2D* pGranularity,
);

alias PFN_vkGetDeviceImageSubresourceLayout = void function(
    VkDevice device,
    const(VkDeviceImageSubresourceInfo)* pInfo,
    VkSubresourceLayout2* pLayout,
);

alias PFN_vkGetImageSubresourceLayout2 = void function(
    VkDevice device,
    VkImage image,
    const(VkImageSubresource2)* pSubresource,
    VkSubresourceLayout2* pLayout,
);

alias VkPipelineCreateFlags2KHR = VkPipelineCreateFlags2;

alias VkPipelineCreateFlagBits2KHR = VkPipelineCreateFlagBits2;

alias VkPipelineCreateFlags2CreateInfoKHR = VkPipelineCreateFlags2CreateInfo;

alias VkBufferUsageFlags2KHR = VkBufferUsageFlags2;

alias VkBufferUsageFlagBits2KHR = VkBufferUsageFlagBits2;

alias VkBufferUsageFlags2CreateInfoKHR = VkBufferUsageFlags2CreateInfo;
