/**
 * VK_NV_displacement_micromap (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.displacement_micromap;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
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

public import vulkan.ext.opacity_micromap;

enum VK_NV_DISPLACEMENT_MICROMAP_SPEC_VERSION = 2;
enum VK_NV_DISPLACEMENT_MICROMAP_EXTENSION_NAME = "VK_NV_displacement_micromap";

struct VkPhysicalDeviceDisplacementMicromapFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISPLACEMENT_MICROMAP_FEATURES_NV;
    void* pNext;
    VkBool32 displacementMicromap;
}

struct VkPhysicalDeviceDisplacementMicromapPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISPLACEMENT_MICROMAP_PROPERTIES_NV;
    void* pNext;
    uint maxDisplacementMicromapSubdivisionLevel;
}

struct VkAccelerationStructureTrianglesDisplacementMicromapNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_TRIANGLES_DISPLACEMENT_MICROMAP_NV;
    void* pNext;
    VkFormat displacementBiasAndScaleFormat;
    VkFormat displacementVectorFormat;
    VkDeviceOrHostAddressConstKHR displacementBiasAndScaleBuffer;
    VkDeviceSize displacementBiasAndScaleStride;
    VkDeviceOrHostAddressConstKHR displacementVectorBuffer;
    VkDeviceSize displacementVectorStride;
    VkDeviceOrHostAddressConstKHR displacedMicromapPrimitiveFlags;
    VkDeviceSize displacedMicromapPrimitiveFlagsStride;
    VkIndexType indexType;
    VkDeviceOrHostAddressConstKHR indexBuffer;
    VkDeviceSize indexStride;
    uint baseTriangle;
    uint usageCountsCount;
    const(VkMicromapUsageEXT)* pUsageCounts;
    const(const(VkMicromapUsageEXT)*)* ppUsageCounts;
    VkMicromapEXT micromap;
}

enum VkDisplacementMicromapFormatNV {
    VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV = 1,
    VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV = 2,
    VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV = 3,
}

enum VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV;
enum VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV;
enum VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV;
