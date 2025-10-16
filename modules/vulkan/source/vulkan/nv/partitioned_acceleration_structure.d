/**
 * VK_NV_partitioned_acceleration_structure
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.partitioned_acceleration_structure;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.nv.cluster_acceleration_structure;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.acceleration_structure;

struct VK_NV_partitioned_acceleration_structure {
    
    @VkProcName("vkGetPartitionedAccelerationStructuresBuildSizesNV")
    PFN_vkGetPartitionedAccelerationStructuresBuildSizesNV vkGetPartitionedAccelerationStructuresBuildSizesNV;
    
    @VkProcName("vkCmdBuildPartitionedAccelerationStructuresNV")
    PFN_vkCmdBuildPartitionedAccelerationStructuresNV vkCmdBuildPartitionedAccelerationStructuresNV;
}

enum VK_NV_PARTITIONED_ACCELERATION_STRUCTURE_SPEC_VERSION = 1;
enum VK_NV_PARTITIONED_ACCELERATION_STRUCTURE_EXTENSION_NAME = "VK_NV_partitioned_acceleration_structure";
enum uint VK_PARTITIONED_ACCELERATION_STRUCTURE_PARTITION_INDEX_GLOBAL_NV = ~0U;

struct VkPhysicalDevicePartitionedAccelerationStructureFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PARTITIONED_ACCELERATION_STRUCTURE_FEATURES_NV;
    void* pNext;
    VkBool32 partitionedAccelerationStructure;
}

struct VkPhysicalDevicePartitionedAccelerationStructurePropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PARTITIONED_ACCELERATION_STRUCTURE_PROPERTIES_NV;
    void* pNext;
    uint maxPartitionCount;
}

struct VkPartitionedAccelerationStructureFlagsNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PARTITIONED_ACCELERATION_STRUCTURE_FLAGS_NV;
    void* pNext;
    VkBool32 enablePartitionTranslation;
}

enum VkPartitionedAccelerationStructureOpTypeNV {
    VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_INSTANCE_NV = 0,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_UPDATE_INSTANCE_NV = 1,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_PARTITION_TRANSLATION_NV = 2,
}

enum VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_INSTANCE_NV = VkPartitionedAccelerationStructureOpTypeNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_INSTANCE_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_UPDATE_INSTANCE_NV = VkPartitionedAccelerationStructureOpTypeNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_UPDATE_INSTANCE_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_PARTITION_TRANSLATION_NV = VkPartitionedAccelerationStructureOpTypeNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_PARTITION_TRANSLATION_NV;

struct VkBuildPartitionedAccelerationStructureIndirectCommandNV {
    VkPartitionedAccelerationStructureOpTypeNV opType;
    uint argCount;
    VkStridedDeviceAddressNV argData;
}

alias VkPartitionedAccelerationStructureInstanceFlagsNV = VkFlags;

enum VkPartitionedAccelerationStructureInstanceFlagBitsNV : uint {
    VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FACING_CULL_DISABLE_BIT_NV = 1,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FLIP_FACING_BIT_NV = 2,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_OPAQUE_BIT_NV = 4,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_NO_OPAQUE_BIT_NV = 8,
    VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_ENABLE_EXPLICIT_BOUNDING_BOX_NV = 16,
}

enum VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FACING_CULL_DISABLE_BIT_NV = VkPartitionedAccelerationStructureInstanceFlagBitsNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FACING_CULL_DISABLE_BIT_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FLIP_FACING_BIT_NV = VkPartitionedAccelerationStructureInstanceFlagBitsNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FLIP_FACING_BIT_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_OPAQUE_BIT_NV = VkPartitionedAccelerationStructureInstanceFlagBitsNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_OPAQUE_BIT_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_NO_OPAQUE_BIT_NV = VkPartitionedAccelerationStructureInstanceFlagBitsNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_NO_OPAQUE_BIT_NV;
enum VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_ENABLE_EXPLICIT_BOUNDING_BOX_NV = VkPartitionedAccelerationStructureInstanceFlagBitsNV.VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_ENABLE_EXPLICIT_BOUNDING_BOX_NV;

struct VkPartitionedAccelerationStructureWriteInstanceDataNV {
    VkTransformMatrixKHR transform;
    float explicitAABB;
    uint instanceID;
    uint instanceMask;
    uint instanceContributionToHitGroupIndex;
    VkFlags instanceFlags;
    uint instanceIndex;
    uint partitionIndex;
    VkDeviceAddress accelerationStructure;
}

struct VkPartitionedAccelerationStructureUpdateInstanceDataNV {
    uint instanceIndex;
    uint instanceContributionToHitGroupIndex;
    VkDeviceAddress accelerationStructure;
}

struct VkPartitionedAccelerationStructureWritePartitionTranslationDataNV {
    uint partitionIndex;
    float partitionTranslation;
}

struct VkWriteDescriptorSetPartitionedAccelerationStructureNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_PARTITIONED_ACCELERATION_STRUCTURE_NV;
    void* pNext;
    uint accelerationStructureCount;
    const(VkDeviceAddress)* pAccelerationStructures;
}

struct VkPartitionedAccelerationStructureInstancesInputNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCES_INPUT_NV;
    void* pNext;
    VkFlags flags;
    uint instanceCount;
    uint maxInstancePerPartitionCount;
    uint partitionCount;
    uint maxInstanceInGlobalPartitionCount;
}

struct VkBuildPartitionedAccelerationStructureInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUILD_PARTITIONED_ACCELERATION_STRUCTURE_INFO_NV;
    void* pNext;
    VkPartitionedAccelerationStructureInstancesInputNV input;
    VkDeviceAddress srcAccelerationStructureData;
    VkDeviceAddress dstAccelerationStructureData;
    VkDeviceAddress scratchData;
    VkDeviceAddress srcInfos;
    VkDeviceAddress srcInfosCount;
}

alias PFN_vkGetPartitionedAccelerationStructuresBuildSizesNV = void function(
    VkDevice device,
    const(VkPartitionedAccelerationStructureInstancesInputNV)* pInfo,
    VkAccelerationStructureBuildSizesInfoKHR* pSizeInfo,
);

alias PFN_vkCmdBuildPartitionedAccelerationStructuresNV = void function(
    VkCommandBuffer commandBuffer,
    const(VkBuildPartitionedAccelerationStructureInfoNV)* pBuildInfo,
);
