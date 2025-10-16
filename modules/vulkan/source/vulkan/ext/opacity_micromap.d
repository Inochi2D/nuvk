/**
 * VK_EXT_opacity_micromap
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.opacity_micromap;

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
    public import vulkan.khr.synchronization2;
}
public import vulkan.khr.acceleration_structure;

struct VK_EXT_opacity_micromap {
    
    @VkProcName("vkCreateMicromapEXT")
    PFN_vkCreateMicromapEXT vkCreateMicromapEXT;
    
    @VkProcName("vkDestroyMicromapEXT")
    PFN_vkDestroyMicromapEXT vkDestroyMicromapEXT;
    
    @VkProcName("vkCmdBuildMicromapsEXT")
    PFN_vkCmdBuildMicromapsEXT vkCmdBuildMicromapsEXT;
    
    @VkProcName("vkBuildMicromapsEXT")
    PFN_vkBuildMicromapsEXT vkBuildMicromapsEXT;
    
    @VkProcName("vkCopyMicromapEXT")
    PFN_vkCopyMicromapEXT vkCopyMicromapEXT;
    
    @VkProcName("vkCopyMicromapToMemoryEXT")
    PFN_vkCopyMicromapToMemoryEXT vkCopyMicromapToMemoryEXT;
    
    @VkProcName("vkCopyMemoryToMicromapEXT")
    PFN_vkCopyMemoryToMicromapEXT vkCopyMemoryToMicromapEXT;
    
    @VkProcName("vkWriteMicromapsPropertiesEXT")
    PFN_vkWriteMicromapsPropertiesEXT vkWriteMicromapsPropertiesEXT;
    
    @VkProcName("vkCmdCopyMicromapEXT")
    PFN_vkCmdCopyMicromapEXT vkCmdCopyMicromapEXT;
    
    @VkProcName("vkCmdCopyMicromapToMemoryEXT")
    PFN_vkCmdCopyMicromapToMemoryEXT vkCmdCopyMicromapToMemoryEXT;
    
    @VkProcName("vkCmdCopyMemoryToMicromapEXT")
    PFN_vkCmdCopyMemoryToMicromapEXT vkCmdCopyMemoryToMicromapEXT;
    
    @VkProcName("vkCmdWriteMicromapsPropertiesEXT")
    PFN_vkCmdWriteMicromapsPropertiesEXT vkCmdWriteMicromapsPropertiesEXT;
    
    @VkProcName("vkGetDeviceMicromapCompatibilityEXT")
    PFN_vkGetDeviceMicromapCompatibilityEXT vkGetDeviceMicromapCompatibilityEXT;
    
    @VkProcName("vkGetMicromapBuildSizesEXT")
    PFN_vkGetMicromapBuildSizesEXT vkGetMicromapBuildSizesEXT;
}

enum VK_EXT_OPACITY_MICROMAP_SPEC_VERSION = 2;
enum VK_EXT_OPACITY_MICROMAP_EXTENSION_NAME = "VK_EXT_opacity_micromap";

enum VkMicromapTypeEXT {
    VK_MICROMAP_TYPE_OPACITY_MICROMAP_EXT = 0,
    VK_MICROMAP_TYPE_DISPLACEMENT_MICROMAP_NV = 1000397000,
}

enum VK_MICROMAP_TYPE_OPACITY_MICROMAP_EXT = VkMicromapTypeEXT.VK_MICROMAP_TYPE_OPACITY_MICROMAP_EXT;
enum VK_MICROMAP_TYPE_DISPLACEMENT_MICROMAP_NV = VkMicromapTypeEXT.VK_MICROMAP_TYPE_DISPLACEMENT_MICROMAP_NV;

struct VkMicromapBuildInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MICROMAP_BUILD_INFO_EXT;
    const(void)* pNext;
    VkMicromapTypeEXT type;
    VkFlags flags;
    VkBuildMicromapModeEXT mode;
    VkMicromapEXT dstMicromap;
    uint usageCountsCount;
    const(VkMicromapUsageEXT)* pUsageCounts;
    const(const(VkMicromapUsageEXT)*)* ppUsageCounts;
    VkDeviceOrHostAddressConstKHR data;
    VkDeviceOrHostAddressKHR scratchData;
    VkDeviceOrHostAddressConstKHR triangleArray;
    VkDeviceSize triangleArrayStride;
}

struct VkMicromapUsageEXT {
    uint count;
    uint subdivisionLevel;
    uint format;
}

struct VkMicromapCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MICROMAP_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags createFlags;
    VkBuffer buffer;
    VkDeviceSize offset;
    VkDeviceSize size;
    VkMicromapTypeEXT type;
    VkDeviceAddress deviceAddress;
}

alias VkMicromapEXT = OpaqueHandle!("VkMicromapEXT");

enum VkBuildMicromapFlagBitsEXT : uint {
    VK_BUILD_MICROMAP_PREFER_FAST_TRACE_BIT_EXT = 1,
    VK_BUILD_MICROMAP_PREFER_FAST_BUILD_BIT_EXT = 2,
    VK_BUILD_MICROMAP_ALLOW_COMPACTION_BIT_EXT = 4,
}

enum VK_BUILD_MICROMAP_PREFER_FAST_TRACE_BIT_EXT = VkBuildMicromapFlagBitsEXT.VK_BUILD_MICROMAP_PREFER_FAST_TRACE_BIT_EXT;
enum VK_BUILD_MICROMAP_PREFER_FAST_BUILD_BIT_EXT = VkBuildMicromapFlagBitsEXT.VK_BUILD_MICROMAP_PREFER_FAST_BUILD_BIT_EXT;
enum VK_BUILD_MICROMAP_ALLOW_COMPACTION_BIT_EXT = VkBuildMicromapFlagBitsEXT.VK_BUILD_MICROMAP_ALLOW_COMPACTION_BIT_EXT;

alias VkBuildMicromapFlagsEXT = VkFlags;

enum VkCopyMicromapModeEXT {
    VK_COPY_MICROMAP_MODE_CLONE_EXT = 0,
    VK_COPY_MICROMAP_MODE_SERIALIZE_EXT = 1,
    VK_COPY_MICROMAP_MODE_DESERIALIZE_EXT = 2,
    VK_COPY_MICROMAP_MODE_COMPACT_EXT = 3,
}

enum VK_COPY_MICROMAP_MODE_CLONE_EXT = VkCopyMicromapModeEXT.VK_COPY_MICROMAP_MODE_CLONE_EXT;
enum VK_COPY_MICROMAP_MODE_SERIALIZE_EXT = VkCopyMicromapModeEXT.VK_COPY_MICROMAP_MODE_SERIALIZE_EXT;
enum VK_COPY_MICROMAP_MODE_DESERIALIZE_EXT = VkCopyMicromapModeEXT.VK_COPY_MICROMAP_MODE_DESERIALIZE_EXT;
enum VK_COPY_MICROMAP_MODE_COMPACT_EXT = VkCopyMicromapModeEXT.VK_COPY_MICROMAP_MODE_COMPACT_EXT;

struct VkPhysicalDeviceOpacityMicromapFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPACITY_MICROMAP_FEATURES_EXT;
    void* pNext;
    VkBool32 micromap;
    VkBool32 micromapCaptureReplay;
    VkBool32 micromapHostCommands;
}

struct VkPhysicalDeviceOpacityMicromapPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPACITY_MICROMAP_PROPERTIES_EXT;
    void* pNext;
    uint maxOpacity2StateSubdivisionLevel;
    uint maxOpacity4StateSubdivisionLevel;
}

struct VkMicromapVersionInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MICROMAP_VERSION_INFO_EXT;
    const(void)* pNext;
    const(ubyte)* pVersionData;
}

struct VkCopyMicromapToMemoryInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MICROMAP_TO_MEMORY_INFO_EXT;
    const(void)* pNext;
    VkMicromapEXT src;
    VkDeviceOrHostAddressKHR dst;
    VkCopyMicromapModeEXT mode;
}

struct VkCopyMemoryToMicromapInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MEMORY_TO_MICROMAP_INFO_EXT;
    const(void)* pNext;
    VkDeviceOrHostAddressConstKHR src;
    VkMicromapEXT dst;
    VkCopyMicromapModeEXT mode;
}

struct VkCopyMicromapInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_MICROMAP_INFO_EXT;
    const(void)* pNext;
    VkMicromapEXT src;
    VkMicromapEXT dst;
    VkCopyMicromapModeEXT mode;
}

enum VkMicromapCreateFlagBitsEXT : uint {
    VK_MICROMAP_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_EXT = 1,
}

enum VK_MICROMAP_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_EXT = VkMicromapCreateFlagBitsEXT.VK_MICROMAP_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_EXT;

alias VkMicromapCreateFlagsEXT = VkFlags;

enum VkBuildMicromapModeEXT {
    VK_BUILD_MICROMAP_MODE_BUILD_EXT = 0,
}

enum VK_BUILD_MICROMAP_MODE_BUILD_EXT = VkBuildMicromapModeEXT.VK_BUILD_MICROMAP_MODE_BUILD_EXT;

struct VkMicromapBuildSizesInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MICROMAP_BUILD_SIZES_INFO_EXT;
    const(void)* pNext;
    VkDeviceSize micromapSize;
    VkDeviceSize buildScratchSize;
    VkBool32 discardable;
}

enum VkOpacityMicromapFormatEXT {
    VK_OPACITY_MICROMAP_FORMAT_2_STATE_EXT = 1,
    VK_OPACITY_MICROMAP_FORMAT_4_STATE_EXT = 2,
}

enum VK_OPACITY_MICROMAP_FORMAT_2_STATE_EXT = VkOpacityMicromapFormatEXT.VK_OPACITY_MICROMAP_FORMAT_2_STATE_EXT;
enum VK_OPACITY_MICROMAP_FORMAT_4_STATE_EXT = VkOpacityMicromapFormatEXT.VK_OPACITY_MICROMAP_FORMAT_4_STATE_EXT;

struct VkAccelerationStructureTrianglesOpacityMicromapEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_TRIANGLES_OPACITY_MICROMAP_EXT;
    void* pNext;
    VkIndexType indexType;
    VkDeviceOrHostAddressConstKHR indexBuffer;
    VkDeviceSize indexStride;
    uint baseTriangle;
    uint usageCountsCount;
    const(VkMicromapUsageEXT)* pUsageCounts;
    const(const(VkMicromapUsageEXT)*)* ppUsageCounts;
    VkMicromapEXT micromap;
}

struct VkMicromapTriangleEXT {
    uint dataOffset;
    ushort subdivisionLevel;
    ushort format;
}

enum VkOpacityMicromapSpecialIndexEXT {
    VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_TRANSPARENT_EXT = -1,
    VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_OPAQUE_EXT = -2,
    VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_TRANSPARENT_EXT = -3,
    VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_OPAQUE_EXT = -4,
    VK_OPACITY_MICROMAP_SPECIAL_INDEX_CLUSTER_GEOMETRY_DISABLE_OPACITY_MICROMAP_NV = -5,
}

enum VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_TRANSPARENT_EXT = VkOpacityMicromapSpecialIndexEXT.VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_TRANSPARENT_EXT;
enum VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_OPAQUE_EXT = VkOpacityMicromapSpecialIndexEXT.VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_OPAQUE_EXT;
enum VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_TRANSPARENT_EXT = VkOpacityMicromapSpecialIndexEXT.VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_TRANSPARENT_EXT;
enum VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_OPAQUE_EXT = VkOpacityMicromapSpecialIndexEXT.VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_OPAQUE_EXT;
enum VK_OPACITY_MICROMAP_SPECIAL_INDEX_CLUSTER_GEOMETRY_DISABLE_OPACITY_MICROMAP_NV = VkOpacityMicromapSpecialIndexEXT.VK_OPACITY_MICROMAP_SPECIAL_INDEX_CLUSTER_GEOMETRY_DISABLE_OPACITY_MICROMAP_NV;

alias PFN_vkCreateMicromapEXT = VkResult function(
    VkDevice device,
    const(VkMicromapCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkMicromapEXT* pMicromap,
);

alias PFN_vkDestroyMicromapEXT = void function(
    VkDevice device,
    VkMicromapEXT micromap,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCmdBuildMicromapsEXT = void function(
    VkCommandBuffer commandBuffer,
    uint infoCount,
    const(VkMicromapBuildInfoEXT)* pInfos,
);

alias PFN_vkBuildMicromapsEXT = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    uint infoCount,
    const(VkMicromapBuildInfoEXT)* pInfos,
);

alias PFN_vkCopyMicromapEXT = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyMicromapInfoEXT)* pInfo,
);

alias PFN_vkCopyMicromapToMemoryEXT = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyMicromapToMemoryInfoEXT)* pInfo,
);

alias PFN_vkCopyMemoryToMicromapEXT = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR deferredOperation,
    const(VkCopyMemoryToMicromapInfoEXT)* pInfo,
);

alias PFN_vkWriteMicromapsPropertiesEXT = VkResult function(
    VkDevice device,
    uint micromapCount,
    const(VkMicromapEXT)* pMicromaps,
    VkQueryType queryType,
    size_t dataSize,
    void* pData,
    size_t stride,
);

alias PFN_vkCmdCopyMicromapEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMicromapInfoEXT)* pInfo,
);

alias PFN_vkCmdCopyMicromapToMemoryEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMicromapToMemoryInfoEXT)* pInfo,
);

alias PFN_vkCmdCopyMemoryToMicromapEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyMemoryToMicromapInfoEXT)* pInfo,
);

alias PFN_vkCmdWriteMicromapsPropertiesEXT = void function(
    VkCommandBuffer commandBuffer,
    uint micromapCount,
    const(VkMicromapEXT)* pMicromaps,
    VkQueryType queryType,
    VkQueryPool queryPool,
    uint firstQuery,
);

alias PFN_vkGetDeviceMicromapCompatibilityEXT = void function(
    VkDevice device,
    const(VkMicromapVersionInfoEXT)* pVersionInfo,
    VkAccelerationStructureCompatibilityKHR* pCompatibility,
);

alias PFN_vkGetMicromapBuildSizesEXT = void function(
    VkDevice device,
    VkAccelerationStructureBuildTypeKHR buildType,
    const(VkMicromapBuildInfoEXT)* pBuildInfo,
    VkMicromapBuildSizesInfoEXT* pSizeInfo,
);
