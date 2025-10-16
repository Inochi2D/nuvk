/**
 * VK_KHR_pipeline_executable_properties
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.pipeline_executable_properties;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_KHR_pipeline_executable_properties {
    
    @VkProcName("vkGetPipelineExecutablePropertiesKHR")
    PFN_vkGetPipelineExecutablePropertiesKHR vkGetPipelineExecutablePropertiesKHR;
    
    @VkProcName("vkGetPipelineExecutableStatisticsKHR")
    PFN_vkGetPipelineExecutableStatisticsKHR vkGetPipelineExecutableStatisticsKHR;
    
    @VkProcName("vkGetPipelineExecutableInternalRepresentationsKHR")
    PFN_vkGetPipelineExecutableInternalRepresentationsKHR vkGetPipelineExecutableInternalRepresentationsKHR;
}

enum VK_KHR_PIPELINE_EXECUTABLE_PROPERTIES_SPEC_VERSION = 1;
enum VK_KHR_PIPELINE_EXECUTABLE_PROPERTIES_EXTENSION_NAME = "VK_KHR_pipeline_executable_properties";

struct VkPhysicalDevicePipelineExecutablePropertiesFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_EXECUTABLE_PROPERTIES_FEATURES_KHR;
    void* pNext;
    VkBool32 pipelineExecutableInfo;
}

struct VkPipelineInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_INFO_KHR;
    const(void)* pNext;
    VkPipeline pipeline;
}

struct VkPipelineExecutablePropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_PROPERTIES_KHR;
    void* pNext;
    VkFlags stages;
    char[VK_MAX_DESCRIPTION_SIZE] name;
    char[VK_MAX_DESCRIPTION_SIZE] description;
    uint subgroupSize;
}

struct VkPipelineExecutableInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_INFO_KHR;
    const(void)* pNext;
    VkPipeline pipeline;
    uint executableIndex;
}

enum VkPipelineExecutableStatisticFormatKHR {
    VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_BOOL32_KHR = 0,
    VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_INT64_KHR = 1,
    VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_UINT64_KHR = 2,
    VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_FLOAT64_KHR = 3,
}

enum VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_BOOL32_KHR = VkPipelineExecutableStatisticFormatKHR.VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_BOOL32_KHR;
enum VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_INT64_KHR = VkPipelineExecutableStatisticFormatKHR.VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_INT64_KHR;
enum VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_UINT64_KHR = VkPipelineExecutableStatisticFormatKHR.VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_UINT64_KHR;
enum VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_FLOAT64_KHR = VkPipelineExecutableStatisticFormatKHR.VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_FLOAT64_KHR;

union VkPipelineExecutableStatisticValueKHR {
    VkBool32 b32;
    long i64;
    ulong u64;
    double f64;
}

struct VkPipelineExecutableStatisticKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_STATISTIC_KHR;
    void* pNext;
    char[VK_MAX_DESCRIPTION_SIZE] name;
    char[VK_MAX_DESCRIPTION_SIZE] description;
    VkPipelineExecutableStatisticFormatKHR format;
    VkPipelineExecutableStatisticValueKHR value;
}

struct VkPipelineExecutableInternalRepresentationKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_INTERNAL_REPRESENTATION_KHR;
    void* pNext;
    char[VK_MAX_DESCRIPTION_SIZE] name;
    char[VK_MAX_DESCRIPTION_SIZE] description;
    VkBool32 isText;
    size_t dataSize;
    void* pData;
}

alias PFN_vkGetPipelineExecutablePropertiesKHR = VkResult function(
    VkDevice device,
    const(VkPipelineInfoKHR)* pPipelineInfo,
    uint* pExecutableCount,
    VkPipelineExecutablePropertiesKHR* pProperties,
);

alias PFN_vkGetPipelineExecutableStatisticsKHR = VkResult function(
    VkDevice device,
    const(VkPipelineExecutableInfoKHR)* pExecutableInfo,
    uint* pStatisticCount,
    VkPipelineExecutableStatisticKHR* pStatistics,
);

alias PFN_vkGetPipelineExecutableInternalRepresentationsKHR = VkResult function(
    VkDevice device,
    const(VkPipelineExecutableInfoKHR)* pExecutableInfo,
    uint* pInternalRepresentationCount,
    VkPipelineExecutableInternalRepresentationKHR* pInternalRepresentations,
);
