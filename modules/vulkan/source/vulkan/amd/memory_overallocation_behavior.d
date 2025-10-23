/**
 * VK_AMD_memory_overallocation_behavior (Device)
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.memory_overallocation_behavior;

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

enum VK_AMD_MEMORY_OVERALLOCATION_BEHAVIOR_SPEC_VERSION = 1;
enum VK_AMD_MEMORY_OVERALLOCATION_BEHAVIOR_EXTENSION_NAME = "VK_AMD_memory_overallocation_behavior";

alias VkMemoryOverallocationBehaviorAMD = uint;
enum VkMemoryOverallocationBehaviorAMD
    VK_MEMORY_OVERALLOCATION_BEHAVIOR_DEFAULT_AMD = 0,
    VK_MEMORY_OVERALLOCATION_BEHAVIOR_ALLOWED_AMD = 1,
    VK_MEMORY_OVERALLOCATION_BEHAVIOR_DISALLOWED_AMD = 2;

struct VkDeviceMemoryOverallocationCreateInfoAMD {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_MEMORY_OVERALLOCATION_CREATE_INFO_AMD;
    const(void)* pNext;
    VkMemoryOverallocationBehaviorAMD overallocationBehavior;
}
