/**
 * VK_KHR_get_memory_requirements2 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.get_memory_requirements2;

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

struct VK_KHR_get_memory_requirements2 {
    
    @VkProcName("vkGetImageMemoryRequirements2")
    PFN_vkGetImageMemoryRequirements2 vkGetImageMemoryRequirements2;
    
    @VkProcName("vkGetBufferMemoryRequirements2")
    PFN_vkGetBufferMemoryRequirements2 vkGetBufferMemoryRequirements2;
    
    @VkProcName("vkGetImageSparseMemoryRequirements2")
    PFN_vkGetImageSparseMemoryRequirements2 vkGetImageSparseMemoryRequirements2;
}

enum VK_KHR_GET_MEMORY_REQUIREMENTS_2_SPEC_VERSION = 1;
enum VK_KHR_GET_MEMORY_REQUIREMENTS_2_EXTENSION_NAME = "VK_KHR_get_memory_requirements2";

alias VkBufferMemoryRequirementsInfo2KHR = VkBufferMemoryRequirementsInfo2;

alias VkImageMemoryRequirementsInfo2KHR = VkImageMemoryRequirementsInfo2;

alias VkImageSparseMemoryRequirementsInfo2KHR = VkImageSparseMemoryRequirementsInfo2;

alias VkMemoryRequirements2KHR = VkMemoryRequirements2;

alias VkSparseImageMemoryRequirements2KHR = VkSparseImageMemoryRequirements2;

alias PFN_vkGetImageMemoryRequirements2 = void function(
    VkDevice device,
    const(VkImageMemoryRequirementsInfo2)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkGetBufferMemoryRequirements2 = void function(
    VkDevice device,
    const(VkBufferMemoryRequirementsInfo2)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkGetImageSparseMemoryRequirements2 = void function(
    VkDevice device,
    const(VkImageSparseMemoryRequirementsInfo2)* pInfo,
    uint* pSparseMemoryRequirementCount,
    VkSparseImageMemoryRequirements2* pSparseMemoryRequirements,
);
