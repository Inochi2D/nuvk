/**
 * VK_KHR_sampler_ycbcr_conversion (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.sampler_ycbcr_conversion;

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
    public import vulkan.khr.get_memory_requirements2;
    public import vulkan.khr.bind_memory2;
    public import vulkan.khr.maintenance1;
}

struct VK_KHR_sampler_ycbcr_conversion {
    
    @VkProcName("vkCreateSamplerYcbcrConversion")
    PFN_vkCreateSamplerYcbcrConversion vkCreateSamplerYcbcrConversion;
    
    @VkProcName("vkDestroySamplerYcbcrConversion")
    PFN_vkDestroySamplerYcbcrConversion vkDestroySamplerYcbcrConversion;
    
}

enum VK_KHR_SAMPLER_YCBCR_CONVERSION_SPEC_VERSION = 14;
enum VK_KHR_SAMPLER_YCBCR_CONVERSION_EXTENSION_NAME = "VK_KHR_sampler_ycbcr_conversion";

alias VkSamplerYcbcrConversionCreateInfoKHR = VkSamplerYcbcrConversionCreateInfo;

alias VkSamplerYcbcrConversionInfoKHR = VkSamplerYcbcrConversionInfo;

alias VkBindImagePlaneMemoryInfoKHR = VkBindImagePlaneMemoryInfo;

alias VkImagePlaneMemoryRequirementsInfoKHR = VkImagePlaneMemoryRequirementsInfo;

alias VkPhysicalDeviceSamplerYcbcrConversionFeaturesKHR = VkPhysicalDeviceSamplerYcbcrConversionFeatures;

alias VkSamplerYcbcrConversionImageFormatPropertiesKHR = VkSamplerYcbcrConversionImageFormatProperties;

alias VkSamplerYcbcrConversionKHR = VkSamplerYcbcrConversion;

alias VkSamplerYcbcrModelConversionKHR = VkSamplerYcbcrModelConversion;

alias VkSamplerYcbcrRangeKHR = VkSamplerYcbcrRange;

alias VkChromaLocationKHR = VkChromaLocation;

alias PFN_vkCreateSamplerYcbcrConversion = VkResult function(
    VkDevice device,
    const(VkSamplerYcbcrConversionCreateInfo)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkSamplerYcbcrConversion* pYcbcrConversion,
);

alias PFN_vkDestroySamplerYcbcrConversion = void function(
    VkDevice device,
    VkSamplerYcbcrConversion ycbcrConversion,
    const(VkAllocationCallbacks)* pAllocator,
);
