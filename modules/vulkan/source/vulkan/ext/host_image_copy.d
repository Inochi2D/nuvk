/**
 * VK_EXT_host_image_copy
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.host_image_copy;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.format_feature_flags2;
    public import vulkan.khr.copy_commands2;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_EXT_host_image_copy {
    
    @VkProcName("vkCopyMemoryToImage")
    PFN_vkCopyMemoryToImage vkCopyMemoryToImage;
    
    @VkProcName("vkCopyImageToMemory")
    PFN_vkCopyImageToMemory vkCopyImageToMemory;
    
    @VkProcName("vkCopyImageToImage")
    PFN_vkCopyImageToImage vkCopyImageToImage;
    
    @VkProcName("vkTransitionImageLayout")
    PFN_vkTransitionImageLayout vkTransitionImageLayout;
    
    @VkProcName("vkGetImageSubresourceLayout2")
    PFN_vkGetImageSubresourceLayout2 vkGetImageSubresourceLayout2;
}

enum VK_EXT_HOST_IMAGE_COPY_SPEC_VERSION = 1;
enum VK_EXT_HOST_IMAGE_COPY_EXTENSION_NAME = "VK_EXT_host_image_copy";

alias VkPhysicalDeviceHostImageCopyFeaturesEXT = VkPhysicalDeviceHostImageCopyFeatures;

alias VkPhysicalDeviceHostImageCopyPropertiesEXT = VkPhysicalDeviceHostImageCopyProperties;

alias VkHostImageCopyFlagBitsEXT = VkHostImageCopyFlagBits;

alias VkHostImageCopyFlagsEXT = VkHostImageCopyFlags;

alias VkMemoryToImageCopyEXT = VkMemoryToImageCopy;

alias VkImageToMemoryCopyEXT = VkImageToMemoryCopy;

alias VkCopyMemoryToImageInfoEXT = VkCopyMemoryToImageInfo;

alias VkCopyImageToMemoryInfoEXT = VkCopyImageToMemoryInfo;

alias VkCopyImageToImageInfoEXT = VkCopyImageToImageInfo;

alias VkHostImageLayoutTransitionInfoEXT = VkHostImageLayoutTransitionInfo;

alias VkSubresourceHostMemcpySizeEXT = VkSubresourceHostMemcpySize;

alias VkHostImageCopyDevicePerformanceQueryEXT = VkHostImageCopyDevicePerformanceQuery;

alias VkSubresourceLayout2EXT = VkSubresourceLayout2;

alias VkImageSubresource2EXT = VkImageSubresource2;

alias PFN_vkCopyMemoryToImage = VkResult function(
    VkDevice device,
    const(VkCopyMemoryToImageInfo)* pCopyMemoryToImageInfo,
);

alias PFN_vkCopyImageToMemory = VkResult function(
    VkDevice device,
    const(VkCopyImageToMemoryInfo)* pCopyImageToMemoryInfo,
);

alias PFN_vkCopyImageToImage = VkResult function(
    VkDevice device,
    const(VkCopyImageToImageInfo)* pCopyImageToImageInfo,
);

alias PFN_vkTransitionImageLayout = VkResult function(
    VkDevice device,
    uint transitionCount,
    const(VkHostImageLayoutTransitionInfo)* pTransitions,
);

alias PFN_vkGetImageSubresourceLayout2 = void function(
    VkDevice device,
    VkImage image,
    const(VkImageSubresource2)* pSubresource,
    VkSubresourceLayout2* pLayout,
);
