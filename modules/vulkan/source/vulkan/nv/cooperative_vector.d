/**
 * VK_NV_cooperative_vector
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.cooperative_vector;

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

struct VK_NV_cooperative_vector {
    
    @VkProcName("vkGetPhysicalDeviceCooperativeVectorPropertiesNV")
    PFN_vkGetPhysicalDeviceCooperativeVectorPropertiesNV vkGetPhysicalDeviceCooperativeVectorPropertiesNV;
    
    @VkProcName("vkConvertCooperativeVectorMatrixNV")
    PFN_vkConvertCooperativeVectorMatrixNV vkConvertCooperativeVectorMatrixNV;
    
    @VkProcName("vkCmdConvertCooperativeVectorMatrixNV")
    PFN_vkCmdConvertCooperativeVectorMatrixNV vkCmdConvertCooperativeVectorMatrixNV;
}

enum VK_NV_COOPERATIVE_VECTOR_SPEC_VERSION = 4;
enum VK_NV_COOPERATIVE_VECTOR_EXTENSION_NAME = "VK_NV_cooperative_vector";

struct VkPhysicalDeviceCooperativeVectorPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_VECTOR_PROPERTIES_NV;
    void* pNext;
    VkFlags cooperativeVectorSupportedStages;
    VkBool32 cooperativeVectorTrainingFloat16Accumulation;
    VkBool32 cooperativeVectorTrainingFloat32Accumulation;
    uint maxCooperativeVectorComponents;
}

struct VkPhysicalDeviceCooperativeVectorFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_VECTOR_FEATURES_NV;
    void* pNext;
    VkBool32 cooperativeVector;
    VkBool32 cooperativeVectorTraining;
}

struct VkCooperativeVectorPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_COOPERATIVE_VECTOR_PROPERTIES_NV;
    void* pNext;
    VkComponentTypeKHR inputType;
    VkComponentTypeKHR inputInterpretation;
    VkComponentTypeKHR matrixInterpretation;
    VkComponentTypeKHR biasInterpretation;
    VkComponentTypeKHR resultType;
    VkBool32 transpose;
}

struct VkConvertCooperativeVectorMatrixInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CONVERT_COOPERATIVE_VECTOR_MATRIX_INFO_NV;
    const(void)* pNext;
    size_t srcSize;
    VkDeviceOrHostAddressConstKHR srcData;
    size_t* pDstSize;
    VkDeviceOrHostAddressKHR dstData;
    VkComponentTypeKHR srcComponentType;
    VkComponentTypeKHR dstComponentType;
    uint numRows;
    uint numColumns;
    VkCooperativeVectorMatrixLayoutNV srcLayout;
    size_t srcStride;
    VkCooperativeVectorMatrixLayoutNV dstLayout;
    size_t dstStride;
}

enum VkCooperativeVectorMatrixLayoutNV {
    VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_ROW_MAJOR_NV = 0,
    VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_COLUMN_MAJOR_NV = 1,
    VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_INFERENCING_OPTIMAL_NV = 2,
    VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_TRAINING_OPTIMAL_NV = 3,
}

enum VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_ROW_MAJOR_NV = VkCooperativeVectorMatrixLayoutNV.VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_ROW_MAJOR_NV;
enum VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_COLUMN_MAJOR_NV = VkCooperativeVectorMatrixLayoutNV.VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_COLUMN_MAJOR_NV;
enum VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_INFERENCING_OPTIMAL_NV = VkCooperativeVectorMatrixLayoutNV.VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_INFERENCING_OPTIMAL_NV;
enum VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_TRAINING_OPTIMAL_NV = VkCooperativeVectorMatrixLayoutNV.VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_TRAINING_OPTIMAL_NV;

enum VkComponentTypeKHR {
    VK_COMPONENT_TYPE_FLOAT16_KHR = 0,
    VK_COMPONENT_TYPE_FLOAT32_KHR = 1,
    VK_COMPONENT_TYPE_FLOAT64_KHR = 2,
    VK_COMPONENT_TYPE_SINT8_KHR = 3,
    VK_COMPONENT_TYPE_SINT16_KHR = 4,
    VK_COMPONENT_TYPE_SINT32_KHR = 5,
    VK_COMPONENT_TYPE_SINT64_KHR = 6,
    VK_COMPONENT_TYPE_UINT8_KHR = 7,
    VK_COMPONENT_TYPE_UINT16_KHR = 8,
    VK_COMPONENT_TYPE_UINT32_KHR = 9,
    VK_COMPONENT_TYPE_UINT64_KHR = 10,
    VK_COMPONENT_TYPE_BFLOAT16_KHR = 1000141000,
    VK_COMPONENT_TYPE_FLOAT16_NV = VK_COMPONENT_TYPE_FLOAT16_KHR,
    VK_COMPONENT_TYPE_FLOAT32_NV = VK_COMPONENT_TYPE_FLOAT32_KHR,
    VK_COMPONENT_TYPE_FLOAT64_NV = VK_COMPONENT_TYPE_FLOAT64_KHR,
    VK_COMPONENT_TYPE_SINT8_NV = VK_COMPONENT_TYPE_SINT8_KHR,
    VK_COMPONENT_TYPE_SINT16_NV = VK_COMPONENT_TYPE_SINT16_KHR,
    VK_COMPONENT_TYPE_SINT32_NV = VK_COMPONENT_TYPE_SINT32_KHR,
    VK_COMPONENT_TYPE_SINT64_NV = VK_COMPONENT_TYPE_SINT64_KHR,
    VK_COMPONENT_TYPE_UINT8_NV = VK_COMPONENT_TYPE_UINT8_KHR,
    VK_COMPONENT_TYPE_UINT16_NV = VK_COMPONENT_TYPE_UINT16_KHR,
    VK_COMPONENT_TYPE_UINT32_NV = VK_COMPONENT_TYPE_UINT32_KHR,
    VK_COMPONENT_TYPE_UINT64_NV = VK_COMPONENT_TYPE_UINT64_KHR,
    VK_COMPONENT_TYPE_SINT8_PACKED_NV = 1000491000,
    VK_COMPONENT_TYPE_UINT8_PACKED_NV = 1000491001,
    VK_COMPONENT_TYPE_FLOAT_E4M3_NV = VK_COMPONENT_TYPE_FLOAT8_E4M3_EXT,
    VK_COMPONENT_TYPE_FLOAT_E5M2_NV = VK_COMPONENT_TYPE_FLOAT8_E5M2_EXT,
    VK_COMPONENT_TYPE_FLOAT8_E4M3_EXT = 1000491002,
    VK_COMPONENT_TYPE_FLOAT8_E5M2_EXT = 1000491003,
}

enum VK_COMPONENT_TYPE_FLOAT16_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_FLOAT16_KHR;
enum VK_COMPONENT_TYPE_FLOAT32_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_FLOAT32_KHR;
enum VK_COMPONENT_TYPE_FLOAT64_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_FLOAT64_KHR;
enum VK_COMPONENT_TYPE_SINT8_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_SINT8_KHR;
enum VK_COMPONENT_TYPE_SINT16_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_SINT16_KHR;
enum VK_COMPONENT_TYPE_SINT32_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_SINT32_KHR;
enum VK_COMPONENT_TYPE_SINT64_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_SINT64_KHR;
enum VK_COMPONENT_TYPE_UINT8_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_UINT8_KHR;
enum VK_COMPONENT_TYPE_UINT16_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_UINT16_KHR;
enum VK_COMPONENT_TYPE_UINT32_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_UINT32_KHR;
enum VK_COMPONENT_TYPE_UINT64_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_UINT64_KHR;
enum VK_COMPONENT_TYPE_BFLOAT16_KHR = VkComponentTypeKHR.VK_COMPONENT_TYPE_BFLOAT16_KHR;
enum VK_COMPONENT_TYPE_FLOAT16_NV = VK_COMPONENT_TYPE_FLOAT16_KHR;
enum VK_COMPONENT_TYPE_FLOAT32_NV = VK_COMPONENT_TYPE_FLOAT32_KHR;
enum VK_COMPONENT_TYPE_FLOAT64_NV = VK_COMPONENT_TYPE_FLOAT64_KHR;
enum VK_COMPONENT_TYPE_SINT8_NV = VK_COMPONENT_TYPE_SINT8_KHR;
enum VK_COMPONENT_TYPE_SINT16_NV = VK_COMPONENT_TYPE_SINT16_KHR;
enum VK_COMPONENT_TYPE_SINT32_NV = VK_COMPONENT_TYPE_SINT32_KHR;
enum VK_COMPONENT_TYPE_SINT64_NV = VK_COMPONENT_TYPE_SINT64_KHR;
enum VK_COMPONENT_TYPE_UINT8_NV = VK_COMPONENT_TYPE_UINT8_KHR;
enum VK_COMPONENT_TYPE_UINT16_NV = VK_COMPONENT_TYPE_UINT16_KHR;
enum VK_COMPONENT_TYPE_UINT32_NV = VK_COMPONENT_TYPE_UINT32_KHR;
enum VK_COMPONENT_TYPE_UINT64_NV = VK_COMPONENT_TYPE_UINT64_KHR;
enum VK_COMPONENT_TYPE_SINT8_PACKED_NV = VkComponentTypeKHR.VK_COMPONENT_TYPE_SINT8_PACKED_NV;
enum VK_COMPONENT_TYPE_UINT8_PACKED_NV = VkComponentTypeKHR.VK_COMPONENT_TYPE_UINT8_PACKED_NV;
enum VK_COMPONENT_TYPE_FLOAT_E4M3_NV = VK_COMPONENT_TYPE_FLOAT8_E4M3_EXT;
enum VK_COMPONENT_TYPE_FLOAT_E5M2_NV = VK_COMPONENT_TYPE_FLOAT8_E5M2_EXT;
enum VK_COMPONENT_TYPE_FLOAT8_E4M3_EXT = VkComponentTypeKHR.VK_COMPONENT_TYPE_FLOAT8_E4M3_EXT;
enum VK_COMPONENT_TYPE_FLOAT8_E5M2_EXT = VkComponentTypeKHR.VK_COMPONENT_TYPE_FLOAT8_E5M2_EXT;

union VkDeviceOrHostAddressKHR {
    VkDeviceAddress deviceAddress;
    void* hostAddress;
}

union VkDeviceOrHostAddressConstKHR {
    VkDeviceAddress deviceAddress;
    const(void)* hostAddress;
}

alias PFN_vkGetPhysicalDeviceCooperativeVectorPropertiesNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pPropertyCount,
    VkCooperativeVectorPropertiesNV* pProperties,
);

alias PFN_vkConvertCooperativeVectorMatrixNV = VkResult function(
    VkDevice device,
    const(VkConvertCooperativeVectorMatrixInfoNV)* pInfo,
);

alias PFN_vkCmdConvertCooperativeVectorMatrixNV = void function(
    VkCommandBuffer commandBuffer,
    uint infoCount,
    const(VkConvertCooperativeVectorMatrixInfoNV)* pInfos,
);
