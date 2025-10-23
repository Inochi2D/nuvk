/**
 * VK_KHR_copy_commands2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.copy_commands2;

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

struct VK_KHR_copy_commands2 {
    @VkProcName("vkCmdCopyBuffer2")
    PFN_vkCmdCopyBuffer2 vkCmdCopyBuffer2;
    
    @VkProcName("vkCmdCopyImage2")
    PFN_vkCmdCopyImage2 vkCmdCopyImage2;
    
    @VkProcName("vkCmdCopyBufferToImage2")
    PFN_vkCmdCopyBufferToImage2 vkCmdCopyBufferToImage2;
    
    @VkProcName("vkCmdCopyImageToBuffer2")
    PFN_vkCmdCopyImageToBuffer2 vkCmdCopyImageToBuffer2;
    
    @VkProcName("vkCmdBlitImage2")
    PFN_vkCmdBlitImage2 vkCmdBlitImage2;
    
    @VkProcName("vkCmdResolveImage2")
    PFN_vkCmdResolveImage2 vkCmdResolveImage2;
}

enum VK_KHR_COPY_COMMANDS_2_SPEC_VERSION = 1;
enum VK_KHR_COPY_COMMANDS_2_EXTENSION_NAME = "VK_KHR_copy_commands2";

alias VkCopyBufferInfo2KHR = VkCopyBufferInfo2;

alias VkCopyImageInfo2KHR = VkCopyImageInfo2;

alias VkCopyBufferToImageInfo2KHR = VkCopyBufferToImageInfo2;

alias VkCopyImageToBufferInfo2KHR = VkCopyImageToBufferInfo2;

alias VkBlitImageInfo2KHR = VkBlitImageInfo2;

alias VkResolveImageInfo2KHR = VkResolveImageInfo2;

alias VkBufferCopy2KHR = VkBufferCopy2;

alias VkImageCopy2KHR = VkImageCopy2;

alias VkImageBlit2KHR = VkImageBlit2;

alias VkBufferImageCopy2KHR = VkBufferImageCopy2;

alias VkImageResolve2KHR = VkImageResolve2;

alias PFN_vkCmdCopyBuffer2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyBufferInfo2)* pCopyBufferInfo,
);

alias PFN_vkCmdCopyImage2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyImageInfo2)* pCopyImageInfo,
);

alias PFN_vkCmdCopyBufferToImage2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyBufferToImageInfo2)* pCopyBufferToImageInfo,
);

alias PFN_vkCmdCopyImageToBuffer2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyImageToBufferInfo2)* pCopyImageToBufferInfo,
);

alias PFN_vkCmdBlitImage2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkBlitImageInfo2)* pBlitImageInfo,
);

alias PFN_vkCmdResolveImage2 = void function(
    VkCommandBuffer commandBuffer,
    const(VkResolveImageInfo2)* pResolveImageInfo,
);
