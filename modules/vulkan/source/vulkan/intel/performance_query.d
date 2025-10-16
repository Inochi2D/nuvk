/**
 * VK_INTEL_performance_query
 * 
 * Author:
 *     Intel Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.intel.performance_query;

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

struct VK_INTEL_performance_query {
    
    @VkProcName("vkInitializePerformanceApiINTEL")
    PFN_vkInitializePerformanceApiINTEL vkInitializePerformanceApiINTEL;
    
    @VkProcName("vkUninitializePerformanceApiINTEL")
    PFN_vkUninitializePerformanceApiINTEL vkUninitializePerformanceApiINTEL;
    
    @VkProcName("vkCmdSetPerformanceMarkerINTEL")
    PFN_vkCmdSetPerformanceMarkerINTEL vkCmdSetPerformanceMarkerINTEL;
    
    @VkProcName("vkCmdSetPerformanceStreamMarkerINTEL")
    PFN_vkCmdSetPerformanceStreamMarkerINTEL vkCmdSetPerformanceStreamMarkerINTEL;
    
    @VkProcName("vkCmdSetPerformanceOverrideINTEL")
    PFN_vkCmdSetPerformanceOverrideINTEL vkCmdSetPerformanceOverrideINTEL;
    
    @VkProcName("vkAcquirePerformanceConfigurationINTEL")
    PFN_vkAcquirePerformanceConfigurationINTEL vkAcquirePerformanceConfigurationINTEL;
    
    @VkProcName("vkReleasePerformanceConfigurationINTEL")
    PFN_vkReleasePerformanceConfigurationINTEL vkReleasePerformanceConfigurationINTEL;
    
    @VkProcName("vkQueueSetPerformanceConfigurationINTEL")
    PFN_vkQueueSetPerformanceConfigurationINTEL vkQueueSetPerformanceConfigurationINTEL;
    
    @VkProcName("vkGetPerformanceParameterINTEL")
    PFN_vkGetPerformanceParameterINTEL vkGetPerformanceParameterINTEL;
}

enum VK_INTEL_PERFORMANCE_QUERY_SPEC_VERSION = 2;
enum VK_INTEL_PERFORMANCE_QUERY_EXTENSION_NAME = "VK_INTEL_performance_query";

enum VkPerformanceConfigurationTypeINTEL {
    VK_PERFORMANCE_CONFIGURATION_TYPE_COMMAND_QUEUE_METRICS_DISCOVERY_ACTIVATED_INTEL = 0,
}

enum VK_PERFORMANCE_CONFIGURATION_TYPE_COMMAND_QUEUE_METRICS_DISCOVERY_ACTIVATED_INTEL = VkPerformanceConfigurationTypeINTEL.VK_PERFORMANCE_CONFIGURATION_TYPE_COMMAND_QUEUE_METRICS_DISCOVERY_ACTIVATED_INTEL;

enum VkQueryPoolSamplingModeINTEL {
    VK_QUERY_POOL_SAMPLING_MODE_MANUAL_INTEL = 0,
}

enum VK_QUERY_POOL_SAMPLING_MODE_MANUAL_INTEL = VkQueryPoolSamplingModeINTEL.VK_QUERY_POOL_SAMPLING_MODE_MANUAL_INTEL;

enum VkPerformanceOverrideTypeINTEL {
    VK_PERFORMANCE_OVERRIDE_TYPE_NULL_HARDWARE_INTEL = 0,
    VK_PERFORMANCE_OVERRIDE_TYPE_FLUSH_GPU_CACHES_INTEL = 1,
}

enum VK_PERFORMANCE_OVERRIDE_TYPE_NULL_HARDWARE_INTEL = VkPerformanceOverrideTypeINTEL.VK_PERFORMANCE_OVERRIDE_TYPE_NULL_HARDWARE_INTEL;
enum VK_PERFORMANCE_OVERRIDE_TYPE_FLUSH_GPU_CACHES_INTEL = VkPerformanceOverrideTypeINTEL.VK_PERFORMANCE_OVERRIDE_TYPE_FLUSH_GPU_CACHES_INTEL;

enum VkPerformanceParameterTypeINTEL {
    VK_PERFORMANCE_PARAMETER_TYPE_HW_COUNTERS_SUPPORTED_INTEL = 0,
    VK_PERFORMANCE_PARAMETER_TYPE_STREAM_MARKER_VALID_BITS_INTEL = 1,
}

enum VK_PERFORMANCE_PARAMETER_TYPE_HW_COUNTERS_SUPPORTED_INTEL = VkPerformanceParameterTypeINTEL.VK_PERFORMANCE_PARAMETER_TYPE_HW_COUNTERS_SUPPORTED_INTEL;
enum VK_PERFORMANCE_PARAMETER_TYPE_STREAM_MARKER_VALID_BITS_INTEL = VkPerformanceParameterTypeINTEL.VK_PERFORMANCE_PARAMETER_TYPE_STREAM_MARKER_VALID_BITS_INTEL;

enum VkPerformanceValueTypeINTEL {
    VK_PERFORMANCE_VALUE_TYPE_UINT32_INTEL = 0,
    VK_PERFORMANCE_VALUE_TYPE_UINT64_INTEL = 1,
    VK_PERFORMANCE_VALUE_TYPE_FLOAT_INTEL = 2,
    VK_PERFORMANCE_VALUE_TYPE_BOOL_INTEL = 3,
    VK_PERFORMANCE_VALUE_TYPE_STRING_INTEL = 4,
}

enum VK_PERFORMANCE_VALUE_TYPE_UINT32_INTEL = VkPerformanceValueTypeINTEL.VK_PERFORMANCE_VALUE_TYPE_UINT32_INTEL;
enum VK_PERFORMANCE_VALUE_TYPE_UINT64_INTEL = VkPerformanceValueTypeINTEL.VK_PERFORMANCE_VALUE_TYPE_UINT64_INTEL;
enum VK_PERFORMANCE_VALUE_TYPE_FLOAT_INTEL = VkPerformanceValueTypeINTEL.VK_PERFORMANCE_VALUE_TYPE_FLOAT_INTEL;
enum VK_PERFORMANCE_VALUE_TYPE_BOOL_INTEL = VkPerformanceValueTypeINTEL.VK_PERFORMANCE_VALUE_TYPE_BOOL_INTEL;
enum VK_PERFORMANCE_VALUE_TYPE_STRING_INTEL = VkPerformanceValueTypeINTEL.VK_PERFORMANCE_VALUE_TYPE_STRING_INTEL;

union VkPerformanceValueDataINTEL {
    uint value32;
    ulong value64;
    float valueFloat;
    VkBool32 valueBool;
    const(char)* valueString;
}

struct VkPerformanceValueINTEL {
    VkPerformanceValueTypeINTEL type;
    VkPerformanceValueDataINTEL data;
}

struct VkInitializePerformanceApiInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_INITIALIZE_PERFORMANCE_API_INFO_INTEL;
    const(void)* pNext;
    void* pUserData;
}

alias VkQueryPoolCreateInfoINTEL = VkQueryPoolPerformanceQueryCreateInfoINTEL;

struct VkQueryPoolPerformanceQueryCreateInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUERY_POOL_PERFORMANCE_QUERY_CREATE_INFO_INTEL;
    const(void)* pNext;
    VkQueryPoolSamplingModeINTEL performanceCountersSampling;
}

struct VkPerformanceMarkerInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_MARKER_INFO_INTEL;
    const(void)* pNext;
    ulong marker;
}

struct VkPerformanceStreamMarkerInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_STREAM_MARKER_INFO_INTEL;
    const(void)* pNext;
    uint marker;
}

struct VkPerformanceOverrideInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_OVERRIDE_INFO_INTEL;
    const(void)* pNext;
    VkPerformanceOverrideTypeINTEL type;
    VkBool32 enable;
    ulong parameter;
}

struct VkPerformanceConfigurationAcquireInfoINTEL {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_CONFIGURATION_ACQUIRE_INFO_INTEL;
    const(void)* pNext;
    VkPerformanceConfigurationTypeINTEL type;
}

alias VkPerformanceConfigurationINTEL = OpaqueHandle!("VkPerformanceConfigurationINTEL");

alias PFN_vkInitializePerformanceApiINTEL = VkResult function(
    VkDevice device,
    const(VkInitializePerformanceApiInfoINTEL)* pInitializeInfo,
);

alias PFN_vkUninitializePerformanceApiINTEL = void function(
    VkDevice device,
);

alias PFN_vkCmdSetPerformanceMarkerINTEL = VkResult function(
    VkCommandBuffer commandBuffer,
    const(VkPerformanceMarkerInfoINTEL)* pMarkerInfo,
);

alias PFN_vkCmdSetPerformanceStreamMarkerINTEL = VkResult function(
    VkCommandBuffer commandBuffer,
    const(VkPerformanceStreamMarkerInfoINTEL)* pMarkerInfo,
);

alias PFN_vkCmdSetPerformanceOverrideINTEL = VkResult function(
    VkCommandBuffer commandBuffer,
    const(VkPerformanceOverrideInfoINTEL)* pOverrideInfo,
);

alias PFN_vkAcquirePerformanceConfigurationINTEL = VkResult function(
    VkDevice device,
    const(VkPerformanceConfigurationAcquireInfoINTEL)* pAcquireInfo,
    VkPerformanceConfigurationINTEL* pConfiguration,
);

alias PFN_vkReleasePerformanceConfigurationINTEL = VkResult function(
    VkDevice device,
    VkPerformanceConfigurationINTEL configuration,
);

alias PFN_vkQueueSetPerformanceConfigurationINTEL = VkResult function(
    VkQueue queue,
    VkPerformanceConfigurationINTEL configuration,
);

alias PFN_vkGetPerformanceParameterINTEL = VkResult function(
    VkDevice device,
    VkPerformanceParameterTypeINTEL parameter,
    VkPerformanceValueINTEL* pValue,
);
