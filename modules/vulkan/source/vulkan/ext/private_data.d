/**
 * VK_EXT_private_data (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.private_data;

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

struct VK_EXT_private_data {
    
    @VkProcName("vkCreatePrivateDataSlot")
    PFN_vkCreatePrivateDataSlot vkCreatePrivateDataSlot;
    
    @VkProcName("vkDestroyPrivateDataSlot")
    PFN_vkDestroyPrivateDataSlot vkDestroyPrivateDataSlot;
    
    @VkProcName("vkSetPrivateData")
    PFN_vkSetPrivateData vkSetPrivateData;
    
    @VkProcName("vkGetPrivateData")
    PFN_vkGetPrivateData vkGetPrivateData;
}

enum VK_EXT_PRIVATE_DATA_SPEC_VERSION = 1;
enum VK_EXT_PRIVATE_DATA_EXTENSION_NAME = "VK_EXT_private_data";

alias VkPhysicalDevicePrivateDataFeaturesEXT = VkPhysicalDevicePrivateDataFeatures;

alias VkDevicePrivateDataCreateInfoEXT = VkDevicePrivateDataCreateInfo;

alias VkPrivateDataSlotCreateInfoEXT = VkPrivateDataSlotCreateInfo;

alias VkPrivateDataSlotEXT = VkPrivateDataSlot;

alias VkPrivateDataSlotCreateFlagsEXT = VkPrivateDataSlotCreateFlags;

alias PFN_vkCreatePrivateDataSlot = VkResult function(
    VkDevice device,
    const(VkPrivateDataSlotCreateInfo)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkPrivateDataSlot pPrivateDataSlot,
);

alias PFN_vkDestroyPrivateDataSlot = void function(
    VkDevice device,
    VkPrivateDataSlot privateDataSlot,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkSetPrivateData = VkResult function(
    VkDevice device,
    VkObjectType objectType,
    ulong objectHandle,
    VkPrivateDataSlot privateDataSlot,
    ulong data,
);

alias PFN_vkGetPrivateData = void function(
    VkDevice device,
    VkObjectType objectType,
    ulong objectHandle,
    VkPrivateDataSlot privateDataSlot,
    ulong* pData,
);
