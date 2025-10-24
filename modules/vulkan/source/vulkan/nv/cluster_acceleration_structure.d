/**
 * VK_NV_cluster_acceleration_structure (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.cluster_acceleration_structure;

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

public import vulkan.khr.acceleration_structure;

struct VK_NV_cluster_acceleration_structure {
    @VkProcName("vkGetClusterAccelerationStructureBuildSizesNV")
    PFN_vkGetClusterAccelerationStructureBuildSizesNV vkGetClusterAccelerationStructureBuildSizesNV;
    
    @VkProcName("vkCmdBuildClusterAccelerationStructureIndirectNV")
    PFN_vkCmdBuildClusterAccelerationStructureIndirectNV vkCmdBuildClusterAccelerationStructureIndirectNV;
    
    
}

enum VK_NV_CLUSTER_ACCELERATION_STRUCTURE_SPEC_VERSION = 4;
enum VK_NV_CLUSTER_ACCELERATION_STRUCTURE_EXTENSION_NAME = "VK_NV_cluster_acceleration_structure";

struct VkPhysicalDeviceClusterAccelerationStructureFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_ACCELERATION_STRUCTURE_FEATURES_NV;
    void* pNext;
    VkBool32 clusterAccelerationStructure;
}

struct VkPhysicalDeviceClusterAccelerationStructurePropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_ACCELERATION_STRUCTURE_PROPERTIES_NV;
    void* pNext;
    uint maxVerticesPerCluster;
    uint maxTrianglesPerCluster;
    uint clusterScratchByteAlignment;
    uint clusterByteAlignment;
    uint clusterTemplateByteAlignment;
    uint clusterBottomLevelByteAlignment;
    uint clusterTemplateBoundsByteAlignment;
    uint maxClusterGeometryIndex;
}

struct VkClusterAccelerationStructureClustersBottomLevelInputNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_CLUSTERS_BOTTOM_LEVEL_INPUT_NV;
    void* pNext;
    uint maxTotalClusterCount;
    uint maxClusterCountPerAccelerationStructure;
}

struct VkClusterAccelerationStructureTriangleClusterInputNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_TRIANGLE_CLUSTER_INPUT_NV;
    void* pNext;
    VkFormat vertexFormat;
    uint maxGeometryIndexValue;
    uint maxClusterUniqueGeometryCount;
    uint maxClusterTriangleCount;
    uint maxClusterVertexCount;
    uint maxTotalTriangleCount;
    uint maxTotalVertexCount;
    uint minPositionTruncateBitCount;
}

struct VkClusterAccelerationStructureMoveObjectsInputNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_MOVE_OBJECTS_INPUT_NV;
    void* pNext;
    VkClusterAccelerationStructureTypeNV type;
    VkBool32 noMoveOverlap;
    VkDeviceSize maxMovedBytes;
}

union VkClusterAccelerationStructureOpInputNV {
    VkClusterAccelerationStructureClustersBottomLevelInputNV* pClustersBottomLevel;
    VkClusterAccelerationStructureTriangleClusterInputNV* pTriangleClusters;
    VkClusterAccelerationStructureMoveObjectsInputNV* pMoveObjects;
}

import vulkan.khr.acceleration_structure : VkBuildAccelerationStructureFlagsKHR;
struct VkClusterAccelerationStructureInputInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_INPUT_INFO_NV;
    void* pNext;
    uint maxAccelerationStructureCount;
    VkBuildAccelerationStructureFlagsKHR flags;
    VkClusterAccelerationStructureOpTypeNV opType;
    VkClusterAccelerationStructureOpModeNV opMode;
    VkClusterAccelerationStructureOpInputNV opInput;
}

import vulkan.khr.ray_tracing_pipeline : VkStridedDeviceAddressRegionKHR, VkStridedDeviceAddressRegionKHR, VkStridedDeviceAddressRegionKHR;
struct VkClusterAccelerationStructureCommandsInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_COMMANDS_INFO_NV;
    void* pNext;
    VkClusterAccelerationStructureInputInfoNV input;
    VkDeviceAddress dstImplicitData;
    VkDeviceAddress scratchData;
    VkStridedDeviceAddressRegionKHR dstAddressesArray;
    VkStridedDeviceAddressRegionKHR dstSizesArray;
    VkStridedDeviceAddressRegionKHR srcInfosArray;
    VkDeviceAddress srcInfosCount;
    VkClusterAccelerationStructureAddressResolutionFlagsNV addressResolutionFlags;
}

struct VkStridedDeviceAddressNV {
    VkDeviceAddress startAddress;
    VkDeviceSize strideInBytes;
}

struct VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV {
    uint geometryIndex:24;
    uint reserved:5;
    uint geometryFlags:3;
    mixin DMD20473;
}


alias VkClusterAccelerationStructureClusterFlagsNV = uint;
enum VkClusterAccelerationStructureClusterFlagsNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_CLUSTER_ALLOW_DISABLE_OPACITY_MICROMAPS_NV = 1;


alias VkClusterAccelerationStructureGeometryFlagsNV = uint;
enum VkClusterAccelerationStructureGeometryFlagsNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_CULL_DISABLE_BIT_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_NO_DUPLICATE_ANYHIT_INVOCATION_BIT_NV = 2,
    VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_OPAQUE_BIT_NV = 4;


alias VkClusterAccelerationStructureAddressResolutionFlagsNV = uint;
enum VkClusterAccelerationStructureAddressResolutionFlagsNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_NONE_NV = 0,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_IMPLICIT_DATA_BIT_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SCRATCH_DATA_BIT_NV = 2,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_ADDRESS_ARRAY_BIT_NV = 4,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_SIZES_ARRAY_BIT_NV = 8,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SRC_INFOS_ARRAY_BIT_NV = 16,
    VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SRC_INFOS_COUNT_BIT_NV = 32;

struct VkClusterAccelerationStructureMoveObjectsInfoNV {
    VkDeviceAddress srcAccelerationStructure;
}

struct VkClusterAccelerationStructureBuildClustersBottomLevelInfoNV {
    uint clusterReferencesCount;
    uint clusterReferencesStride;
    VkDeviceAddress clusterReferences;
}

struct VkClusterAccelerationStructureBuildTriangleClusterInfoNV {
    uint clusterID;
    VkClusterAccelerationStructureClusterFlagsNV clusterFlags;
    uint triangleCount:9;
    uint vertexCount:9;
    uint positionTruncateBitCount:6;
    uint indexType:4;
    uint opacityMicromapIndexType:4;
    VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV baseGeometryIndexAndGeometryFlags;
    ushort indexBufferStride;
    ushort vertexBufferStride;
    ushort geometryIndexAndFlagsBufferStride;
    ushort opacityMicromapIndexBufferStride;
    VkDeviceAddress indexBuffer;
    VkDeviceAddress vertexBuffer;
    VkDeviceAddress geometryIndexAndFlagsBuffer;
    VkDeviceAddress opacityMicromapArray;
    VkDeviceAddress opacityMicromapIndexBuffer;
    mixin DMD20473;
}

struct VkClusterAccelerationStructureBuildTriangleClusterTemplateInfoNV {
    uint clusterID;
    VkClusterAccelerationStructureClusterFlagsNV clusterFlags;
    uint triangleCount:9;
    uint vertexCount:9;
    uint positionTruncateBitCount:6;
    uint indexType:4;
    uint opacityMicromapIndexType:4;
    VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV baseGeometryIndexAndGeometryFlags;
    ushort indexBufferStride;
    ushort vertexBufferStride;
    ushort geometryIndexAndFlagsBufferStride;
    ushort opacityMicromapIndexBufferStride;
    VkDeviceAddress indexBuffer;
    VkDeviceAddress vertexBuffer;
    VkDeviceAddress geometryIndexAndFlagsBuffer;
    VkDeviceAddress opacityMicromapArray;
    VkDeviceAddress opacityMicromapIndexBuffer;
    VkDeviceAddress instantiationBoundingBoxLimit;
    mixin DMD20473;
}

struct VkClusterAccelerationStructureInstantiateClusterInfoNV {
    uint clusterIdOffset;
    uint geometryIndexOffset:24;
    uint reserved:8;
    VkDeviceAddress clusterTemplateAddress;
    VkStridedDeviceAddressNV vertexBuffer;
    mixin DMD20473;
}

alias VkClusterAccelerationStructureIndexFormatFlagsNV = uint;
enum VkClusterAccelerationStructureIndexFormatFlagsNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_8BIT_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_16BIT_NV = 2,
    VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_32BIT_NV = 4;


alias VkClusterAccelerationStructureTypeNV = uint;
enum VkClusterAccelerationStructureTypeNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_CLUSTERS_BOTTOM_LEVEL_NV = 0,
    VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_TRIANGLE_CLUSTER_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_TRIANGLE_CLUSTER_TEMPLATE_NV = 2;

alias VkClusterAccelerationStructureOpTypeNV = uint;
enum VkClusterAccelerationStructureOpTypeNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_MOVE_OBJECTS_NV = 0,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_CLUSTERS_BOTTOM_LEVEL_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_TRIANGLE_CLUSTER_NV = 2,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_TRIANGLE_CLUSTER_TEMPLATE_NV = 3,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_INSTANTIATE_TRIANGLE_CLUSTER_NV = 4,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_GET_CLUSTER_TEMPLATE_INDICES_NV = 5;

alias VkClusterAccelerationStructureOpModeNV = uint;
enum VkClusterAccelerationStructureOpModeNV
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_IMPLICIT_DESTINATIONS_NV = 0,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_EXPLICIT_DESTINATIONS_NV = 1,
    VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_COMPUTE_SIZES_NV = 2;

struct VkClusterAccelerationStructureGetTemplateIndicesInfoNV {
    VkDeviceAddress clusterTemplateAddress;
}

import vulkan.khr.acceleration_structure : VkAccelerationStructureBuildSizesInfoKHR;
alias PFN_vkGetClusterAccelerationStructureBuildSizesNV = void function(
    VkDevice device,
    const(VkClusterAccelerationStructureInputInfoNV)* pInfo,
    VkAccelerationStructureBuildSizesInfoKHR* pSizeInfo,
);

alias PFN_vkCmdBuildClusterAccelerationStructureIndirectNV = void function(
    VkCommandBuffer commandBuffer,
    const(VkClusterAccelerationStructureCommandsInfoNV)* pCommandInfos,
);

public import vulkan.khr.ray_tracing_pipeline;

struct VkRayTracingPipelineClusterAccelerationStructureCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CLUSTER_ACCELERATION_STRUCTURE_CREATE_INFO_NV;
    void* pNext;
    VkBool32 allowClusterAccelerationStructure;
}
