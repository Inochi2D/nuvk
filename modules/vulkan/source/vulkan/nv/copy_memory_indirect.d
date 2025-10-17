/**
 * VK_NV_copy_memory_indirect (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.copy_memory_indirect;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.copy_memory_indirect;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.buffer_device_address;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_NV_copy_memory_indirect {
    
    @VkProcName("vkCmdCopyMemoryIndirectNV")
    PFN_vkCmdCopyMemoryIndirectNV vkCmdCopyMemoryIndirectNV;
    
    @VkProcName("vkCmdCopyMemoryToImageIndirectNV")
    PFN_vkCmdCopyMemoryToImageIndirectNV vkCmdCopyMemoryToImageIndirectNV;
}

enum VK_NV_COPY_MEMORY_INDIRECT_SPEC_VERSION = 1;
enum VK_NV_COPY_MEMORY_INDIRECT_EXTENSION_NAME = "VK_NV_copy_memory_indirect";

import vulkan.khr.copy_memory_indirect : VkCopyMemoryIndirectCommandKHR;
alias VkCopyMemoryIndirectCommandNV = VkCopyMemoryIndirectCommandKHR;

import vulkan.khr.copy_memory_indirect : VkCopyMemoryToImageIndirectCommandKHR;
alias VkCopyMemoryToImageIndirectCommandNV = VkCopyMemoryToImageIndirectCommandKHR;

struct VkPhysicalDeviceCopyMemoryIndirectFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COPY_MEMORY_INDIRECT_FEATURES_NV;
    void* pNext;
    VkBool32 indirectCopy;
}

import vulkan.khr.copy_memory_indirect : VkPhysicalDeviceCopyMemoryIndirectPropertiesKHR;
alias VkPhysicalDeviceCopyMemoryIndirectPropertiesNV = VkPhysicalDeviceCopyMemoryIndirectPropertiesKHR;

alias PFN_vkCmdCopyMemoryIndirectNV = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress copyBufferAddress,
    uint copyCount,
    uint stride,
);

alias PFN_vkCmdCopyMemoryToImageIndirectNV = void function(
    VkCommandBuffer commandBuffer,
    VkDeviceAddress copyBufferAddress,
    uint copyCount,
    uint stride,
    VkImage dstImage,
    VkImageLayout dstImageLayout,
    const(VkImageSubresourceLayers)* pImageSubresources,
);
