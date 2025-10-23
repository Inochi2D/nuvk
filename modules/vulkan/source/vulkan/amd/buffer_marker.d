/**
 * VK_AMD_buffer_marker (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.buffer_marker;

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

struct VK_AMD_buffer_marker {
    @VkProcName("vkCmdWriteBufferMarkerAMD")
    PFN_vkCmdWriteBufferMarkerAMD vkCmdWriteBufferMarkerAMD;
    @VkProcName("vkCmdWriteBufferMarker2AMD")
    PFN_vkCmdWriteBufferMarker2AMD vkCmdWriteBufferMarker2AMD;
}

enum VK_AMD_BUFFER_MARKER_SPEC_VERSION = 1;
enum VK_AMD_BUFFER_MARKER_EXTENSION_NAME = "VK_AMD_buffer_marker";

alias PFN_vkCmdWriteBufferMarkerAMD = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineStageFlags pipelineStage,
    VkBuffer dstBuffer,
    VkDeviceSize dstOffset,
    uint marker,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
}

alias PFN_vkCmdWriteBufferMarker2AMD = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineStageFlags2 stage,
    VkBuffer dstBuffer,
    VkDeviceSize dstOffset,
    uint marker,
);
