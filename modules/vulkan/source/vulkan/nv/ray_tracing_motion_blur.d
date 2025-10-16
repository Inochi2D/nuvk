/**
 * VK_NV_ray_tracing_motion_blur
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.ray_tracing_motion_blur;

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

enum VK_NV_RAY_TRACING_MOTION_BLUR_SPEC_VERSION = 1;
enum VK_NV_RAY_TRACING_MOTION_BLUR_EXTENSION_NAME = "VK_NV_ray_tracing_motion_blur";

struct VkAccelerationStructureGeometryMotionTrianglesDataNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_MOTION_TRIANGLES_DATA_NV;
    const(void)* pNext;
    VkDeviceOrHostAddressConstKHR vertexData;
}

struct VkAccelerationStructureMotionInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MOTION_INFO_NV;
    const(void)* pNext;
    uint maxInstances;
    VkFlags flags;
}

struct VkAccelerationStructureMotionInstanceNV {
    VkAccelerationStructureMotionInstanceTypeNV type;
    VkFlags flags;
    VkAccelerationStructureMotionInstanceDataNV data;
}

union VkAccelerationStructureMotionInstanceDataNV {
    VkAccelerationStructureInstanceKHR staticInstance;
    VkAccelerationStructureMatrixMotionInstanceNV matrixMotionInstance;
    VkAccelerationStructureSRTMotionInstanceNV srtMotionInstance;
}

struct VkAccelerationStructureMatrixMotionInstanceNV {
    VkTransformMatrixKHR transformT0;
    VkTransformMatrixKHR transformT1;
    uint instanceCustomIndex;
    uint mask;
    uint instanceShaderBindingTableRecordOffset;
    VkFlags flags;
    ulong accelerationStructureReference;
}

struct VkAccelerationStructureSRTMotionInstanceNV {
    VkSRTDataNV transformT0;
    VkSRTDataNV transformT1;
    uint instanceCustomIndex;
    uint mask;
    uint instanceShaderBindingTableRecordOffset;
    VkFlags flags;
    ulong accelerationStructureReference;
}

struct VkSRTDataNV {
    float sx;
    float a;
    float b;
    float pvx;
    float sy;
    float c;
    float pvy;
    float sz;
    float pvz;
    float qx;
    float qy;
    float qz;
    float qw;
    float tx;
    float ty;
    float tz;
}

enum VkAccelerationStructureMotionInstanceTypeNV {
    VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_STATIC_NV = 0,
    VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_MATRIX_MOTION_NV = 1,
    VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_SRT_MOTION_NV = 2,
}

enum VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_STATIC_NV = VkAccelerationStructureMotionInstanceTypeNV.VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_STATIC_NV;
enum VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_MATRIX_MOTION_NV = VkAccelerationStructureMotionInstanceTypeNV.VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_MATRIX_MOTION_NV;
enum VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_SRT_MOTION_NV = VkAccelerationStructureMotionInstanceTypeNV.VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_SRT_MOTION_NV;

struct VkPhysicalDeviceRayTracingMotionBlurFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_MOTION_BLUR_FEATURES_NV;
    void* pNext;
    VkBool32 rayTracingMotionBlur;
    VkBool32 rayTracingMotionBlurPipelineTraceRaysIndirect;
}

alias VkAccelerationStructureMotionInfoFlagsNV = VkFlags;
alias VkAccelerationStructureMotionInstanceFlagsNV = VkFlags;
