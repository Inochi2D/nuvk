/**
 * VK_NV_ray_tracing_linear_swept_spheres
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.ray_tracing_linear_swept_spheres;

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

public import vulkan.khr.ray_tracing_pipeline;

enum VK_NV_RAY_TRACING_LINEAR_SWEPT_SPHERES_SPEC_VERSION = 1;
enum VK_NV_RAY_TRACING_LINEAR_SWEPT_SPHERES_EXTENSION_NAME = "VK_NV_ray_tracing_linear_swept_spheres";

struct VkPhysicalDeviceRayTracingLinearSweptSpheresFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_LINEAR_SWEPT_SPHERES_FEATURES_NV;
    void* pNext;
    VkBool32 spheres;
    VkBool32 linearSweptSpheres;
}

struct VkAccelerationStructureGeometryLinearSweptSpheresDataNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_LINEAR_SWEPT_SPHERES_DATA_NV;
    const(void)* pNext;
    VkFormat vertexFormat;
    VkDeviceOrHostAddressConstKHR vertexData;
    VkDeviceSize vertexStride;
    VkFormat radiusFormat;
    VkDeviceOrHostAddressConstKHR radiusData;
    VkDeviceSize radiusStride;
    VkIndexType indexType;
    VkDeviceOrHostAddressConstKHR indexData;
    VkDeviceSize indexStride;
    VkRayTracingLssIndexingModeNV indexingMode;
    VkRayTracingLssPrimitiveEndCapsModeNV endCapsMode;
}

struct VkAccelerationStructureGeometrySpheresDataNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_SPHERES_DATA_NV;
    const(void)* pNext;
    VkFormat vertexFormat;
    VkDeviceOrHostAddressConstKHR vertexData;
    VkDeviceSize vertexStride;
    VkFormat radiusFormat;
    VkDeviceOrHostAddressConstKHR radiusData;
    VkDeviceSize radiusStride;
    VkIndexType indexType;
    VkDeviceOrHostAddressConstKHR indexData;
    VkDeviceSize indexStride;
}

enum VkRayTracingLssIndexingModeNV {
    VK_RAY_TRACING_LSS_INDEXING_MODE_LIST_NV = 0,
    VK_RAY_TRACING_LSS_INDEXING_MODE_SUCCESSIVE_NV = 1,
}

enum VK_RAY_TRACING_LSS_INDEXING_MODE_LIST_NV = VkRayTracingLssIndexingModeNV.VK_RAY_TRACING_LSS_INDEXING_MODE_LIST_NV;
enum VK_RAY_TRACING_LSS_INDEXING_MODE_SUCCESSIVE_NV = VkRayTracingLssIndexingModeNV.VK_RAY_TRACING_LSS_INDEXING_MODE_SUCCESSIVE_NV;

enum VkRayTracingLssPrimitiveEndCapsModeNV {
    VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_NONE_NV = 0,
    VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_CHAINED_NV = 1,
}

enum VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_NONE_NV = VkRayTracingLssPrimitiveEndCapsModeNV.VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_NONE_NV;
enum VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_CHAINED_NV = VkRayTracingLssPrimitiveEndCapsModeNV.VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_CHAINED_NV;
