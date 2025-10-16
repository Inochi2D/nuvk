/**
 * VK_KHR_acceleration_structure (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.acceleration_structure;

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

public import vulkan.khr.deferred_host_operations;
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.buffer_device_address;
    version (VK_VERSION_1_1):
    public import vulkan.ext.descriptor_indexing;
}

struct VK_KHR_acceleration_structure {
    
    @VkProcName("vkCreateAccelerationStructureKHR")
    PFN_vkCreateAccelerationStructureKHR vkCreateAccelerationStructureKHR;
    
    @VkProcName("vkDestroyAccelerationStructureKHR")
    PFN_vkDestroyAccelerationStructureKHR vkDestroyAccelerationStructureKHR;
    
    @VkProcName("vkCmdBuildAccelerationStructuresKHR")
    PFN_vkCmdBuildAccelerationStructuresKHR vkCmdBuildAccelerationStructuresKHR;
    
    @VkProcName("vkCmdBuildAccelerationStructuresIndirectKHR")
    PFN_vkCmdBuildAccelerationStructuresIndirectKHR vkCmdBuildAccelerationStructuresIndirectKHR;
    
    @VkProcName("vkBuildAccelerationStructuresKHR")
    PFN_vkBuildAccelerationStructuresKHR vkBuildAccelerationStructuresKHR;
    
    @VkProcName("vkCopyAccelerationStructureKHR")
    PFN_vkCopyAccelerationStructureKHR vkCopyAccelerationStructureKHR;
    
    @VkProcName("vkCopyAccelerationStructureToMemoryKHR")
    PFN_vkCopyAccelerationStructureToMemoryKHR vkCopyAccelerationStructureToMemoryKHR;
    
    @VkProcName("vkCopyMemoryToAccelerationStructureKHR")
    PFN_vkCopyMemoryToAccelerationStructureKHR vkCopyMemoryToAccelerationStructureKHR;
    
    @VkProcName("vkWriteAccelerationStructuresPropertiesKHR")
    PFN_vkWriteAccelerationStructuresPropertiesKHR vkWriteAccelerationStructuresPropertiesKHR;
    
    @VkProcName("vkCmdCopyAccelerationStructureKHR")
    PFN_vkCmdCopyAccelerationStructureKHR vkCmdCopyAccelerationStructureKHR;
    
    @VkProcName("vkCmdCopyAccelerationStructureToMemoryKHR")
    PFN_vkCmdCopyAccelerationStructureToMemoryKHR vkCmdCopyAccelerationStructureToMemoryKHR;
    
    @VkProcName("vkCmdCopyMemoryToAccelerationStructureKHR")
    PFN_vkCmdCopyMemoryToAccelerationStructureKHR vkCmdCopyMemoryToAccelerationStructureKHR;
    
    @VkProcName("vkGetAccelerationStructureDeviceAddressKHR")
    PFN_vkGetAccelerationStructureDeviceAddressKHR vkGetAccelerationStructureDeviceAddressKHR;
    
    @VkProcName("vkCmdWriteAccelerationStructuresPropertiesKHR")
    PFN_vkCmdWriteAccelerationStructuresPropertiesKHR vkCmdWriteAccelerationStructuresPropertiesKHR;
    
    @VkProcName("vkGetDeviceAccelerationStructureCompatibilityKHR")
    PFN_vkGetDeviceAccelerationStructureCompatibilityKHR vkGetDeviceAccelerationStructureCompatibilityKHR;
    
    @VkProcName("vkGetAccelerationStructureBuildSizesKHR")
    PFN_vkGetAccelerationStructureBuildSizesKHR vkGetAccelerationStructureBuildSizesKHR;
    
    
    version (VK_VERSION_1_2) {
    }
}

enum VK_KHR_ACCELERATION_STRUCTURE_SPEC_VERSION = 13;
enum VK_KHR_ACCELERATION_STRUCTURE_EXTENSION_NAME = "VK_KHR_acceleration_structure";

enum VkAccelerationStructureTypeKHR {
    VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR = 0,
    VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR = 1,
    VK_ACCELERATION_STRUCTURE_TYPE_GENERIC_KHR = 2,
    VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_NV = VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR,
    VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_NV = VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR,
}

enum VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR = VkAccelerationStructureTypeKHR.VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR;
enum VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR = VkAccelerationStructureTypeKHR.VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR;
enum VK_ACCELERATION_STRUCTURE_TYPE_GENERIC_KHR = VkAccelerationStructureTypeKHR.VK_ACCELERATION_STRUCTURE_TYPE_GENERIC_KHR;
enum VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_NV = VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR;
enum VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_NV = VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR;

union VkDeviceOrHostAddressKHR {
    VkDeviceAddress deviceAddress;
    void* hostAddress;
}

union VkDeviceOrHostAddressConstKHR {
    VkDeviceAddress deviceAddress;
    const(void)* hostAddress;
}

struct VkAccelerationStructureBuildRangeInfoKHR {
    uint primitiveCount;
    uint primitiveOffset;
    uint firstVertex;
    uint transformOffset;
}

struct VkAabbPositionsKHR {
    float minX;
    float minY;
    float minZ;
    float maxX;
    float maxY;
    float maxZ;
}

struct VkAccelerationStructureGeometryTrianglesDataKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_TRIANGLES_DATA_KHR;
    const(void)* pNext;
    VkFormat vertexFormat;
    VkDeviceOrHostAddressConstKHR vertexData;
    VkDeviceSize vertexStride;
    uint maxVertex;
    VkIndexType indexType;
    VkDeviceOrHostAddressConstKHR indexData;
    VkDeviceOrHostAddressConstKHR transformData;
}

struct VkTransformMatrixKHR {
    float[3][4] matrix;
}

struct VkAccelerationStructureBuildGeometryInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_BUILD_GEOMETRY_INFO_KHR;
    const(void)* pNext;
    VkAccelerationStructureTypeKHR type;
    VkFlags flags;
    VkBuildAccelerationStructureModeKHR mode;
    VkAccelerationStructureKHR srcAccelerationStructure;
    VkAccelerationStructureKHR dstAccelerationStructure;
    uint geometryCount;
    const(VkAccelerationStructureGeometryKHR)* pGeometries;
    const(const(VkAccelerationStructureGeometryKHR)*)* ppGeometries;
    VkDeviceOrHostAddressKHR scratchData;
}

enum VkAccelerationStructureBuildTypeKHR {
    VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR = 0,
    VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR = 1,
    VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR = 2,
}

enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR;
enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR;
enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR;

struct VkAccelerationStructureGeometryAabbsDataKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_AABBS_DATA_KHR;
    const(void)* pNext;
    VkDeviceOrHostAddressConstKHR data;
    VkDeviceSize stride;
}

struct VkAccelerationStructureInstanceKHR {
    VkTransformMatrixKHR transform;
    uint instanceCustomIndex:24;
    uint mask:8;
    uint instanceShaderBindingTableRecordOffset:24;
    VkFlags flags:8;
    ulong accelerationStructureReference;
    mixin DMD20473;
}

struct VkAccelerationStructureGeometryInstancesDataKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_INSTANCES_DATA_KHR;
    const(void)* pNext;
    VkBool32 arrayOfPointers;
    VkDeviceOrHostAddressConstKHR data;
}

union VkAccelerationStructureGeometryDataKHR {
    VkAccelerationStructureGeometryTrianglesDataKHR triangles;
    VkAccelerationStructureGeometryAabbsDataKHR aabbs;
    VkAccelerationStructureGeometryInstancesDataKHR instances;
}

struct VkAccelerationStructureGeometryKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_KHR;
    const(void)* pNext;
    VkGeometryTypeKHR geometryType;
    VkAccelerationStructureGeometryDataKHR geometry;
    VkFlags flags;
}

alias VkGeometryFlagsKHR = VkFlags;
alias VkGeometryInstanceFlagsKHR = VkFlags;

enum VkGeometryFlagBitsKHR : uint {
    VK_GEOMETRY_OPAQUE_BIT_KHR = 1,
    VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR = 2,
    VK_GEOMETRY_OPAQUE_BIT_NV = VK_GEOMETRY_OPAQUE_BIT_KHR,
    VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_NV = VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR,
}

enum VK_GEOMETRY_OPAQUE_BIT_KHR = VkGeometryFlagBitsKHR.VK_GEOMETRY_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR = VkGeometryFlagBitsKHR.VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR;
enum VK_GEOMETRY_OPAQUE_BIT_NV = VK_GEOMETRY_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_NV = VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR;

enum VkGeometryInstanceFlagBitsKHR : uint {
    VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR = 1,
    VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR = 2,
    VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR = 4,
    VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR = 8,
    VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_KHR = VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR,
    VK_GEOMETRY_INSTANCE_TRIANGLE_CULL_DISABLE_BIT_NV = VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR,
    VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_NV = VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_KHR,
    VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_NV = VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR,
    VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_NV = VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR,
    VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_BIT_EXT = 16,
    VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_EXT = VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_BIT_EXT,
    VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_BIT_EXT = 32,
    VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_EXT = VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_BIT_EXT,
}

enum VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_KHR = VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_TRIANGLE_CULL_DISABLE_BIT_NV = VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_NV = VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_NV = VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_NV = VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR;
enum VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_BIT_EXT = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_BIT_EXT;
deprecated("aliased")
enum VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_EXT = VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_BIT_EXT;
enum VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_BIT_EXT = VkGeometryInstanceFlagBitsKHR.VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_BIT_EXT;
deprecated("aliased")
enum VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_EXT = VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_BIT_EXT;

struct VkAccelerationStructureCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkFlags createFlags;
    VkBuffer buffer;
    VkDeviceSize offset;
    VkDeviceSize size;
    VkAccelerationStructureTypeKHR type;
    VkDeviceAddress deviceAddress;
}

alias VkAccelerationStructureKHR = OpaqueHandle!("VkAccelerationStructureKHR");

enum VkBuildAccelerationStructureFlagBitsKHR : uint {
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR = 1,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR = 2,
    VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR = 4,
    VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR = 8,
    VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR = 16,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_MOTION_BIT_NV = 32,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_BIT_EXT = 64,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_BIT_EXT,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_BIT_EXT = 128,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_BIT_EXT,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_BIT_EXT = 256,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_BIT_EXT,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_BIT_NV = 512,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_BIT_NV,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_BIT_KHR = 2048,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_KHR = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_BIT_KHR,
    VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_CLUSTER_OPACITY_MICROMAPS_BIT_NV = 4096,
}

enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_NV = VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_MOTION_BIT_NV = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_MOTION_BIT_NV;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_BIT_EXT = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_BIT_EXT;
deprecated("aliased")
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_BIT_EXT;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_BIT_EXT = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_BIT_EXT;
deprecated("aliased")
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_BIT_EXT;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_BIT_EXT = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_BIT_EXT;
deprecated("aliased")
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_EXT = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_BIT_EXT;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_BIT_NV = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_BIT_NV;
deprecated("aliased")
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_NV = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISPLACEMENT_MICROMAP_UPDATE_BIT_NV;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_BIT_KHR = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_BIT_KHR;
deprecated("aliased")
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_KHR = VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_BIT_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_CLUSTER_OPACITY_MICROMAPS_BIT_NV = VkBuildAccelerationStructureFlagBitsKHR.VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_CLUSTER_OPACITY_MICROMAPS_BIT_NV;

alias VkBuildAccelerationStructureFlagsKHR = VkFlags;

enum VkCopyAccelerationStructureModeKHR {
    VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR = 0,
    VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR = 1,
    VK_COPY_ACCELERATION_STRUCTURE_MODE_SERIALIZE_KHR = 2,
    VK_COPY_ACCELERATION_STRUCTURE_MODE_DESERIALIZE_KHR = 3,
    VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_NV = VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR,
    VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_NV = VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR,
}

enum VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR = VkCopyAccelerationStructureModeKHR.VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR;
enum VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR = VkCopyAccelerationStructureModeKHR.VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR;
enum VK_COPY_ACCELERATION_STRUCTURE_MODE_SERIALIZE_KHR = VkCopyAccelerationStructureModeKHR.VK_COPY_ACCELERATION_STRUCTURE_MODE_SERIALIZE_KHR;
enum VK_COPY_ACCELERATION_STRUCTURE_MODE_DESERIALIZE_KHR = VkCopyAccelerationStructureModeKHR.VK_COPY_ACCELERATION_STRUCTURE_MODE_DESERIALIZE_KHR;
enum VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_NV = VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR;
enum VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_NV = VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR;

enum VkGeometryTypeKHR {
    VK_GEOMETRY_TYPE_TRIANGLES_KHR = 0,
    VK_GEOMETRY_TYPE_AABBS_KHR = 1,
    VK_GEOMETRY_TYPE_INSTANCES_KHR = 2,
    VK_GEOMETRY_TYPE_TRIANGLES_NV = VK_GEOMETRY_TYPE_TRIANGLES_KHR,
    VK_GEOMETRY_TYPE_AABBS_NV = VK_GEOMETRY_TYPE_AABBS_KHR,
    VK_GEOMETRY_TYPE_SPHERES_NV = 1000429004,
    VK_GEOMETRY_TYPE_LINEAR_SWEPT_SPHERES_NV = 1000429005,
    VK_GEOMETRY_TYPE_DENSE_GEOMETRY_FORMAT_TRIANGLES_AMDX = 1000478000,
}

enum VK_GEOMETRY_TYPE_TRIANGLES_KHR = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_TRIANGLES_KHR;
enum VK_GEOMETRY_TYPE_AABBS_KHR = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_AABBS_KHR;
enum VK_GEOMETRY_TYPE_INSTANCES_KHR = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_INSTANCES_KHR;
enum VK_GEOMETRY_TYPE_TRIANGLES_NV = VK_GEOMETRY_TYPE_TRIANGLES_KHR;
enum VK_GEOMETRY_TYPE_AABBS_NV = VK_GEOMETRY_TYPE_AABBS_KHR;
enum VK_GEOMETRY_TYPE_SPHERES_NV = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_SPHERES_NV;
enum VK_GEOMETRY_TYPE_LINEAR_SWEPT_SPHERES_NV = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_LINEAR_SWEPT_SPHERES_NV;
enum VK_GEOMETRY_TYPE_DENSE_GEOMETRY_FORMAT_TRIANGLES_AMDX = VkGeometryTypeKHR.VK_GEOMETRY_TYPE_DENSE_GEOMETRY_FORMAT_TRIANGLES_AMDX;

struct VkWriteDescriptorSetAccelerationStructureKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_KHR;
    const(void)* pNext;
    uint accelerationStructureCount;
    const(VkAccelerationStructureKHR)* pAccelerationStructures;
}

struct VkPhysicalDeviceAccelerationStructureFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ACCELERATION_STRUCTURE_FEATURES_KHR;
    void* pNext;
    VkBool32 accelerationStructure;
    VkBool32 accelerationStructureCaptureReplay;
    VkBool32 accelerationStructureIndirectBuild;
    VkBool32 accelerationStructureHostCommands;
    VkBool32 descriptorBindingAccelerationStructureUpdateAfterBind;
}

struct VkPhysicalDeviceAccelerationStructurePropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ACCELERATION_STRUCTURE_PROPERTIES_KHR;
    void* pNext;
    ulong maxGeometryCount;
    ulong maxInstanceCount;
    ulong maxPrimitiveCount;
    uint maxPerStageDescriptorAccelerationStructures;
    uint maxPerStageDescriptorUpdateAfterBindAccelerationStructures;
    uint maxDescriptorSetAccelerationStructures;
    uint maxDescriptorSetUpdateAfterBindAccelerationStructures;
    uint minAccelerationStructureScratchOffsetAlignment;
}

struct VkAccelerationStructureDeviceAddressInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_DEVICE_ADDRESS_INFO_KHR;
    const(void)* pNext;
    VkAccelerationStructureKHR accelerationStructure;
}

struct VkAccelerationStructureVersionInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_VERSION_INFO_KHR;
    const(void)* pNext;
    const(ubyte)* pVersionData;
}

struct VkCopyAccelerationStructureToMemoryInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_TO_MEMORY_INFO_KHR;
    const(void)* pNext;
    VkAccelerationStructureKHR src;
    VkDeviceOrHostAddressKHR dst;
    VkCopyAccelerationStructureModeKHR mode;
}

struct VkCopyMemoryToAccelerationStructureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MEMORY_TO_ACCELERATION_STRUCTURE_INFO_KHR;
    const(void)* pNext;
    VkDeviceOrHostAddressConstKHR src;
    VkAccelerationStructureKHR dst;
    VkCopyAccelerationStructureModeKHR mode;
}

struct VkCopyAccelerationStructureInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_INFO_KHR;
    const(void)* pNext;
    VkAccelerationStructureKHR src;
    VkAccelerationStructureKHR dst;
    VkCopyAccelerationStructureModeKHR mode;
}

enum VkAccelerationStructureCompatibilityKHR {
    VK_ACCELERATION_STRUCTURE_COMPATIBILITY_COMPATIBLE_KHR = 0,
    VK_ACCELERATION_STRUCTURE_COMPATIBILITY_INCOMPATIBLE_KHR = 1,
}

enum VK_ACCELERATION_STRUCTURE_COMPATIBILITY_COMPATIBLE_KHR = VkAccelerationStructureCompatibilityKHR.VK_ACCELERATION_STRUCTURE_COMPATIBILITY_COMPATIBLE_KHR;
enum VK_ACCELERATION_STRUCTURE_COMPATIBILITY_INCOMPATIBLE_KHR = VkAccelerationStructureCompatibilityKHR.VK_ACCELERATION_STRUCTURE_COMPATIBILITY_INCOMPATIBLE_KHR;

enum VkAccelerationStructureCreateFlagBitsKHR : uint {
    VK_ACCELERATION_STRUCTURE_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR = 1,
    VK_ACCELERATION_STRUCTURE_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 8,
    VK_ACCELERATION_STRUCTURE_CREATE_MOTION_BIT_NV = 4,
}

enum VK_ACCELERATION_STRUCTURE_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR = VkAccelerationStructureCreateFlagBitsKHR.VK_ACCELERATION_STRUCTURE_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR;
enum VK_ACCELERATION_STRUCTURE_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = VkAccelerationStructureCreateFlagBitsKHR.VK_ACCELERATION_STRUCTURE_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT;
enum VK_ACCELERATION_STRUCTURE_CREATE_MOTION_BIT_NV = VkAccelerationStructureCreateFlagBitsKHR.VK_ACCELERATION_STRUCTURE_CREATE_MOTION_BIT_NV;

alias VkAccelerationStructureCreateFlagsKHR = VkFlags;

enum VkBuildAccelerationStructureModeKHR {
    VK_BUILD_ACCELERATION_STRUCTURE_MODE_BUILD_KHR = 0,
    VK_BUILD_ACCELERATION_STRUCTURE_MODE_UPDATE_KHR = 1,
}

enum VK_BUILD_ACCELERATION_STRUCTURE_MODE_BUILD_KHR = VkBuildAccelerationStructureModeKHR.VK_BUILD_ACCELERATION_STRUCTURE_MODE_BUILD_KHR;
enum VK_BUILD_ACCELERATION_STRUCTURE_MODE_UPDATE_KHR = VkBuildAccelerationStructureModeKHR.VK_BUILD_ACCELERATION_STRUCTURE_MODE_UPDATE_KHR;

struct VkAccelerationStructureBuildSizesInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_BUILD_SIZES_INFO_KHR;
    const(void)* pNext;
    VkDeviceSize accelerationStructureSize;
    VkDeviceSize updateScratchSize;
    VkDeviceSize buildScratchSize;
}

alias PFN_vkCreateAccelerationStructureKHR = VkResult function(
    VkDevice device,
    const(VkAccelerationStructureCreateInfoKHR)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkAccelerationStructureKHR* pAccelerationStructure,
);

alias PFN_vkDestroyAccelerationStructureKHR = void function(
    VkDevice device,
    VkAccelerationStructureKHR accelerationStructure,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCmdBuildAccelerationStructuresKHR = void function(
    VkCommandBuffer commandBuffer,
    uint infoCount,
    const(VkAccelerationStructureBuildGeometryInfoKHR)* pInfos,
    const(const(VkAccelerationStructureBuildRangeInfoKHR)*)* ppBuildRangeInfos,
);

alias PFN_vkCmdBuildAccelerationStructuresIndirectKHR = void function(
    VkCommandBuffer commandBuffer,
    uint infoCount,
    const(VkAccelerationStructureBuildGeometryInfoKHR)* pInfos,
    const(VkDeviceAddress)* pIndirectDeviceAddresses,
    const(uint)* pIndirectStrides,
    const(const(uint)*)* ppMaxPrimitiveCounts,
);

alias PFN_vkBuildAccelerationStructuresKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    uint infoCount,
    const(VkAccelerationStructureBuildGeometryInfoKHR)* pInfos,
    const(const(VkAccelerationStructureBuildRangeInfoKHR)*)* ppBuildRangeInfos,
);

alias PFN_vkCopyAccelerationStructureKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyAccelerationStructureInfoKHR)* pInfo,
);

alias PFN_vkCopyAccelerationStructureToMemoryKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyAccelerationStructureToMemoryInfoKHR)* pInfo,
);

alias PFN_vkCopyMemoryToAccelerationStructureKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyMemoryToAccelerationStructureInfoKHR)* pInfo,
);

alias PFN_vkWriteAccelerationStructuresPropertiesKHR = VkResult function(
    VkDevice device,
    uint accelerationStructureCount,
    const(VkAccelerationStructureKHR)* pAccelerationStructures,
    VkQueryType queryType,
    size_t dataSize,
    void* pData,
    size_t stride,
);

alias PFN_vkCmdCopyAccelerationStructureKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyAccelerationStructureInfoKHR)* pInfo,
);

alias PFN_vkCmdCopyAccelerationStructureToMemoryKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyAccelerationStructureToMemoryInfoKHR)* pInfo,
);

alias PFN_vkCmdCopyMemoryToAccelerationStructureKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMemoryToAccelerationStructureInfoKHR)* pInfo,
);

alias PFN_vkGetAccelerationStructureDeviceAddressKHR = VkDeviceAddress function(
    VkDevice device,
    const(VkAccelerationStructureDeviceAddressInfoKHR)* pInfo,
);

alias PFN_vkCmdWriteAccelerationStructuresPropertiesKHR = void function(
    VkCommandBuffer commandBuffer,
    uint accelerationStructureCount,
    const(VkAccelerationStructureKHR)* pAccelerationStructures,
    VkQueryType queryType,
    VkQueryPool queryPool,
    uint firstQuery,
);

alias PFN_vkGetDeviceAccelerationStructureCompatibilityKHR = void function(
    VkDevice device,
    const(VkAccelerationStructureVersionInfoKHR)* pVersionInfo,
    VkAccelerationStructureCompatibilityKHR* pCompatibility,
);

alias PFN_vkGetAccelerationStructureBuildSizesKHR = void function(
    VkDevice device,
    VkAccelerationStructureBuildTypeKHR buildType,
    const(VkAccelerationStructureBuildGeometryInfoKHR)* pBuildInfo,
    const(uint)* pMaxPrimitiveCounts,
    VkAccelerationStructureBuildSizesInfoKHR* pSizeInfo,
);
