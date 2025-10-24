/**
 * VK_KHR_copy_memory_indirect (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.copy_memory_indirect;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.buffer_device_address;
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_KHR_copy_memory_indirect {
    @VkProcName("vkCmdCopyMemoryIndirectKHR")
    PFN_vkCmdCopyMemoryIndirectKHR vkCmdCopyMemoryIndirectKHR;
    
    @VkProcName("vkCmdCopyMemoryToImageIndirectKHR")
    PFN_vkCmdCopyMemoryToImageIndirectKHR vkCmdCopyMemoryToImageIndirectKHR;
}

enum VK_KHR_COPY_MEMORY_INDIRECT_SPEC_VERSION = 1;
enum VK_KHR_COPY_MEMORY_INDIRECT_EXTENSION_NAME = "VK_KHR_copy_memory_indirect";

struct VkStridedDeviceAddressRangeKHR {
    VkDeviceAddress address;
    VkDeviceSize size;
    VkDeviceSize stride;
}

alias VkAddressCopyFlagsKHR = uint;
enum VkAddressCopyFlagsKHR
    VK_ADDRESS_COPY_DEVICE_LOCAL_BIT_KHR = 1,
    VK_ADDRESS_COPY_SPARSE_BIT_KHR = 2,
    VK_ADDRESS_COPY_PROTECTED_BIT_KHR = 4;


struct VkCopyMemoryIndirectCommandKHR {
    VkDeviceAddress srcAddress;
    VkDeviceAddress dstAddress;
    VkDeviceSize size;
}

struct VkCopyMemoryIndirectInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MEMORY_INDIRECT_INFO_KHR;
    const(void)* pNext;
    VkAddressCopyFlagsKHR srcCopyFlags;
    VkAddressCopyFlagsKHR dstCopyFlags;
    uint copyCount;
    VkStridedDeviceAddressRangeKHR copyAddressRange;
}

struct VkCopyMemoryToImageIndirectCommandKHR {
    VkDeviceAddress srcAddress;
    uint bufferRowLength;
    uint bufferImageHeight;
    VkImageSubresourceLayers imageSubresource;
    VkOffset3D imageOffset;
    VkExtent3D imageExtent;
}

struct VkCopyMemoryToImageIndirectInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MEMORY_TO_IMAGE_INDIRECT_INFO_KHR;
    const(void)* pNext;
    VkAddressCopyFlagsKHR srcCopyFlags;
    uint copyCount;
    VkStridedDeviceAddressRangeKHR copyAddressRange;
    VkImage dstImage;
    VkImageLayout dstImageLayout;
    const(VkImageSubresourceLayers)* pImageSubresources;
}

struct VkPhysicalDeviceCopyMemoryIndirectFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COPY_MEMORY_INDIRECT_FEATURES_KHR;
    void* pNext;
    VkBool32 indirectMemoryCopy;
    VkBool32 indirectMemoryToImageCopy;
}

struct VkPhysicalDeviceCopyMemoryIndirectPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COPY_MEMORY_INDIRECT_PROPERTIES_KHR;
    void* pNext;
    VkQueueFlags supportedQueues;
}

alias PFN_vkCmdCopyMemoryIndirectKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMemoryIndirectInfoKHR)* pCopyMemoryIndirectInfo,
);

alias PFN_vkCmdCopyMemoryToImageIndirectKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMemoryToImageIndirectInfoKHR)* pCopyMemoryToImageIndirectInfo,
);
