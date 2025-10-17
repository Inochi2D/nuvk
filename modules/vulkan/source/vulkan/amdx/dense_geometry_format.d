/**
 * VK_AMDX_dense_geometry_format (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amdx.dense_geometry_format;

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

version (VK_VERSION_1_4) {} else {
    public import vulkan.khr.maintenance5;
}
public import vulkan.khr.acceleration_structure;

enum VK_AMDX_DENSE_GEOMETRY_FORMAT_SPEC_VERSION = 1;
enum VK_AMDX_DENSE_GEOMETRY_FORMAT_EXTENSION_NAME = "VK_AMDX_dense_geometry_format";
enum uint VK_COMPRESSED_TRIANGLE_FORMAT_DGF1_BYTE_ALIGNMENT_AMDX = 128;
enum uint VK_COMPRESSED_TRIANGLE_FORMAT_DGF1_BYTE_STRIDE_AMDX = 128;

struct VkPhysicalDeviceDenseGeometryFormatFeaturesAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DENSE_GEOMETRY_FORMAT_FEATURES_AMDX;
    void* pNext;
    VkBool32 denseGeometryFormat;
}

import vulkan.khr.acceleration_structure : VkDeviceOrHostAddressConstKHR;
struct VkAccelerationStructureDenseGeometryFormatTrianglesDataAMDX {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_DENSE_GEOMETRY_FORMAT_TRIANGLES_DATA_AMDX;
    const(void)* pNext;
    VkDeviceOrHostAddressConstKHR compressedData;
    VkDeviceSize dataSize;
    uint numTriangles;
    uint numVertices;
    uint maxPrimitiveIndex;
    uint maxGeometryIndex;
    VkCompressedTriangleFormatAMDX format;
}

enum VkCompressedTriangleFormatAMDX {
    VK_COMPRESSED_TRIANGLE_FORMAT_DGF1_AMDX = 0,
}

enum VK_COMPRESSED_TRIANGLE_FORMAT_DGF1_AMDX = VkCompressedTriangleFormatAMDX.VK_COMPRESSED_TRIANGLE_FORMAT_DGF1_AMDX;
