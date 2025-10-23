/**
 * VK_KHR_performance_query (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.performance_query;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_KHR_performance_query {
    @VkProcName("vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR")
    PFN_vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR;
    
    @VkProcName("vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR")
    PFN_vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR;
    
    @VkProcName("vkAcquireProfilingLockKHR")
    PFN_vkAcquireProfilingLockKHR vkAcquireProfilingLockKHR;
    
    @VkProcName("vkReleaseProfilingLockKHR")
    PFN_vkReleaseProfilingLockKHR vkReleaseProfilingLockKHR;
    
    version (VKSC_VERSION_1_0) {
    }
}

enum VK_KHR_PERFORMANCE_QUERY_SPEC_VERSION = 1;
enum VK_KHR_PERFORMANCE_QUERY_EXTENSION_NAME = "VK_KHR_performance_query";

struct VkPhysicalDevicePerformanceQueryFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PERFORMANCE_QUERY_FEATURES_KHR;
    void* pNext;
    VkBool32 performanceCounterQueryPools;
    VkBool32 performanceCounterMultipleQueryPools;
}

struct VkPhysicalDevicePerformanceQueryPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PERFORMANCE_QUERY_PROPERTIES_KHR;
    void* pNext;
    VkBool32 allowCommandBufferQueryCopies;
}

struct VkPerformanceCounterKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_COUNTER_KHR;
    void* pNext;
    VkPerformanceCounterUnitKHR unit;
    VkPerformanceCounterScopeKHR scope_;
    VkPerformanceCounterStorageKHR storage;
    ubyte[VK_UUID_SIZE] uuid;
}

struct VkPerformanceCounterDescriptionKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_COUNTER_DESCRIPTION_KHR;
    void* pNext;
    VkPerformanceCounterDescriptionFlagsKHR flags;
    char[VK_MAX_DESCRIPTION_SIZE] name;
    char[VK_MAX_DESCRIPTION_SIZE] category;
    char[VK_MAX_DESCRIPTION_SIZE] description;
}


alias VkPerformanceCounterDescriptionFlagsKHR = uint;
enum VkPerformanceCounterDescriptionFlagsKHR
    VK_PERFORMANCE_COUNTER_DESCRIPTION_PERFORMANCE_IMPACTING_BIT_KHR = 1,
    VK_PERFORMANCE_COUNTER_DESCRIPTION_PERFORMANCE_IMPACTING_KHR = VK_PERFORMANCE_COUNTER_DESCRIPTION_PERFORMANCE_IMPACTING_BIT_KHR,
    VK_PERFORMANCE_COUNTER_DESCRIPTION_CONCURRENTLY_IMPACTED_BIT_KHR = 2,
    VK_PERFORMANCE_COUNTER_DESCRIPTION_CONCURRENTLY_IMPACTED_KHR = VK_PERFORMANCE_COUNTER_DESCRIPTION_CONCURRENTLY_IMPACTED_BIT_KHR;

struct VkQueryPoolPerformanceCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUERY_POOL_PERFORMANCE_CREATE_INFO_KHR;
    const(void)* pNext;
    uint queueFamilyIndex;
    uint counterIndexCount;
    const(uint)* pCounterIndices;
}

alias VkPerformanceCounterScopeKHR = uint;
enum VkPerformanceCounterScopeKHR
    VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_BUFFER_KHR = 0,
    VK_PERFORMANCE_COUNTER_SCOPE_RENDER_PASS_KHR = 1,
    VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_KHR = 2,
    VK_QUERY_SCOPE_COMMAND_BUFFER_KHR = VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_BUFFER_KHR,
    VK_QUERY_SCOPE_RENDER_PASS_KHR = VK_PERFORMANCE_COUNTER_SCOPE_RENDER_PASS_KHR,
    VK_QUERY_SCOPE_COMMAND_KHR = VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_KHR;

alias VkPerformanceCounterStorageKHR = uint;
enum VkPerformanceCounterStorageKHR
    VK_PERFORMANCE_COUNTER_STORAGE_INT32_KHR = 0,
    VK_PERFORMANCE_COUNTER_STORAGE_INT64_KHR = 1,
    VK_PERFORMANCE_COUNTER_STORAGE_UINT32_KHR = 2,
    VK_PERFORMANCE_COUNTER_STORAGE_UINT64_KHR = 3,
    VK_PERFORMANCE_COUNTER_STORAGE_FLOAT32_KHR = 4,
    VK_PERFORMANCE_COUNTER_STORAGE_FLOAT64_KHR = 5;

alias VkPerformanceCounterUnitKHR = uint;
enum VkPerformanceCounterUnitKHR
    VK_PERFORMANCE_COUNTER_UNIT_GENERIC_KHR = 0,
    VK_PERFORMANCE_COUNTER_UNIT_PERCENTAGE_KHR = 1,
    VK_PERFORMANCE_COUNTER_UNIT_NANOSECONDS_KHR = 2,
    VK_PERFORMANCE_COUNTER_UNIT_BYTES_KHR = 3,
    VK_PERFORMANCE_COUNTER_UNIT_BYTES_PER_SECOND_KHR = 4,
    VK_PERFORMANCE_COUNTER_UNIT_KELVIN_KHR = 5,
    VK_PERFORMANCE_COUNTER_UNIT_WATTS_KHR = 6,
    VK_PERFORMANCE_COUNTER_UNIT_VOLTS_KHR = 7,
    VK_PERFORMANCE_COUNTER_UNIT_AMPS_KHR = 8,
    VK_PERFORMANCE_COUNTER_UNIT_HERTZ_KHR = 9,
    VK_PERFORMANCE_COUNTER_UNIT_CYCLES_KHR = 10;

union VkPerformanceCounterResultKHR {
    int int32;
    long int64;
    uint uint32;
    ulong uint64;
    float float32;
    double float64;
}

struct VkAcquireProfilingLockInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACQUIRE_PROFILING_LOCK_INFO_KHR;
    const(void)* pNext;
    VkAcquireProfilingLockFlagsKHR flags;
    ulong timeout;
}


alias VkAcquireProfilingLockFlagsKHR = uint;

struct VkPerformanceQuerySubmitInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_QUERY_SUBMIT_INFO_KHR;
    const(void)* pNext;
    uint counterPassIndex;
}

alias PFN_vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint queueFamilyIndex,
    uint* pCounterCount,
    VkPerformanceCounterKHR* pCounters,
    VkPerformanceCounterDescriptionKHR* pCounterDescriptions,
);

alias PFN_vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR = void function(
    VkPhysicalDevice physicalDevice,
    const(VkQueryPoolPerformanceCreateInfoKHR)* pPerformanceQueryCreateInfo,
    uint* pNumPasses,
);

alias PFN_vkAcquireProfilingLockKHR = VkResult function(
    VkDevice device,
    const(VkAcquireProfilingLockInfoKHR)* pInfo,
);

alias PFN_vkReleaseProfilingLockKHR = void function(
    VkDevice device,
);


struct VkPerformanceQueryReservationInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PERFORMANCE_QUERY_RESERVATION_INFO_KHR;
    const(void)* pNext;
    uint maxPerformanceQueriesPerPool;
}
