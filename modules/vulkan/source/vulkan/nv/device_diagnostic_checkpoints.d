/**
 * VK_NV_device_diagnostic_checkpoints (Device)
 * 
 * Author:
 *     NVIDIA
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.device_diagnostic_checkpoints;

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

struct VK_NV_device_diagnostic_checkpoints {
    @VkProcName("vkCmdSetCheckpointNV")
    PFN_vkCmdSetCheckpointNV vkCmdSetCheckpointNV;
    
    @VkProcName("vkGetQueueCheckpointDataNV")
    PFN_vkGetQueueCheckpointDataNV vkGetQueueCheckpointDataNV;
    @VkProcName("vkGetQueueCheckpointData2NV")
    PFN_vkGetQueueCheckpointData2NV vkGetQueueCheckpointData2NV;
}

enum VK_NV_DEVICE_DIAGNOSTIC_CHECKPOINTS_SPEC_VERSION = 2;
enum VK_NV_DEVICE_DIAGNOSTIC_CHECKPOINTS_EXTENSION_NAME = "VK_NV_device_diagnostic_checkpoints";

struct VkQueueFamilyCheckpointPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_NV;
    void* pNext;
    VkPipelineStageFlags checkpointExecutionStageMask;
}

struct VkCheckpointDataNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CHECKPOINT_DATA_NV;
    void* pNext;
    VkPipelineStageFlags stage;
    void* pCheckpointMarker;
}

alias PFN_vkCmdSetCheckpointNV = void function(
    VkCommandBuffer commandBuffer,
    const(void)* pCheckpointMarker,
);

alias PFN_vkGetQueueCheckpointDataNV = void function(
    VkQueue queue,
    uint* pCheckpointDataCount,
    VkCheckpointDataNV* pCheckpointData,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
}

struct VkQueueFamilyCheckpointProperties2NV {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_2_NV;
    void* pNext;
    VkPipelineStageFlags2 checkpointExecutionStageMask;
}

struct VkCheckpointData2NV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CHECKPOINT_DATA_2_NV;
    void* pNext;
    VkPipelineStageFlags2 stage;
    void* pCheckpointMarker;
}

alias PFN_vkGetQueueCheckpointData2NV = void function(
    VkQueue queue,
    uint* pCheckpointDataCount,
    VkCheckpointData2NV* pCheckpointData,
);
