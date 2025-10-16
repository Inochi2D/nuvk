/**
 * VK_EXT_transform_feedback (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.transform_feedback;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_EXT_transform_feedback {
    
    @VkProcName("vkCmdBindTransformFeedbackBuffersEXT")
    PFN_vkCmdBindTransformFeedbackBuffersEXT vkCmdBindTransformFeedbackBuffersEXT;
    
    @VkProcName("vkCmdBeginTransformFeedbackEXT")
    PFN_vkCmdBeginTransformFeedbackEXT vkCmdBeginTransformFeedbackEXT;
    
    @VkProcName("vkCmdEndTransformFeedbackEXT")
    PFN_vkCmdEndTransformFeedbackEXT vkCmdEndTransformFeedbackEXT;
    
    @VkProcName("vkCmdBeginQueryIndexedEXT")
    PFN_vkCmdBeginQueryIndexedEXT vkCmdBeginQueryIndexedEXT;
    
    @VkProcName("vkCmdEndQueryIndexedEXT")
    PFN_vkCmdEndQueryIndexedEXT vkCmdEndQueryIndexedEXT;
    
    @VkProcName("vkCmdDrawIndirectByteCountEXT")
    PFN_vkCmdDrawIndirectByteCountEXT vkCmdDrawIndirectByteCountEXT;
}

enum VK_EXT_TRANSFORM_FEEDBACK_SPEC_VERSION = 1;
enum VK_EXT_TRANSFORM_FEEDBACK_EXTENSION_NAME = "VK_EXT_transform_feedback";

struct VkPhysicalDeviceTransformFeedbackFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_FEATURES_EXT;
    void* pNext;
    VkBool32 transformFeedback;
    VkBool32 geometryStreams;
}

struct VkPhysicalDeviceTransformFeedbackPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_PROPERTIES_EXT;
    void* pNext;
    uint maxTransformFeedbackStreams;
    uint maxTransformFeedbackBuffers;
    VkDeviceSize maxTransformFeedbackBufferSize;
    uint maxTransformFeedbackStreamDataSize;
    uint maxTransformFeedbackBufferDataSize;
    uint maxTransformFeedbackBufferDataStride;
    VkBool32 transformFeedbackQueries;
    VkBool32 transformFeedbackStreamsLinesTriangles;
    VkBool32 transformFeedbackRasterizationStreamSelect;
    VkBool32 transformFeedbackDraw;
}

struct VkPipelineRasterizationStateStreamCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_STREAM_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    uint rasterizationStream;
}

alias VkPipelineRasterizationStateStreamCreateFlagsEXT = VkFlags;

alias PFN_vkCmdBindTransformFeedbackBuffersEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstBinding,
    uint bindingCount,
    const(VkBuffer)* pBuffers,
    const(VkDeviceSize)* pOffsets,
    const(VkDeviceSize)* pSizes,
);

alias PFN_vkCmdBeginTransformFeedbackEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstCounterBuffer,
    uint counterBufferCount,
    const(VkBuffer)* pCounterBuffers,
    const(VkDeviceSize)* pCounterBufferOffsets,
);

alias PFN_vkCmdEndTransformFeedbackEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstCounterBuffer,
    uint counterBufferCount,
    const(VkBuffer)* pCounterBuffers,
    const(VkDeviceSize)* pCounterBufferOffsets,
);

alias PFN_vkCmdBeginQueryIndexedEXT = void function(
    VkCommandBuffer commandBuffer,
    VkQueryPool queryPool,
    uint query,
    VkQueryControlFlags flags,
    uint index,
);

alias PFN_vkCmdEndQueryIndexedEXT = void function(
    VkCommandBuffer commandBuffer,
    VkQueryPool queryPool,
    uint query,
    uint index,
);

alias PFN_vkCmdDrawIndirectByteCountEXT = void function(
    VkCommandBuffer commandBuffer,
    uint instanceCount,
    uint firstInstance,
    VkBuffer counterBuffer,
    VkDeviceSize counterBufferOffset,
    uint counterOffset,
    uint vertexStride,
);
