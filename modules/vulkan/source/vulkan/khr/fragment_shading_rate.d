/**
 * VK_KHR_fragment_shading_rate (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.fragment_shading_rate;

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

version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.create_renderpass2;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_KHR_fragment_shading_rate {
    
    @VkProcName("vkGetPhysicalDeviceFragmentShadingRatesKHR")
    PFN_vkGetPhysicalDeviceFragmentShadingRatesKHR vkGetPhysicalDeviceFragmentShadingRatesKHR;
    
    @VkProcName("vkCmdSetFragmentShadingRateKHR")
    PFN_vkCmdSetFragmentShadingRateKHR vkCmdSetFragmentShadingRateKHR;
}

enum VK_KHR_FRAGMENT_SHADING_RATE_SPEC_VERSION = 2;
enum VK_KHR_FRAGMENT_SHADING_RATE_EXTENSION_NAME = "VK_KHR_fragment_shading_rate";

enum VkFragmentShadingRateCombinerOpKHR {
    VK_FRAGMENT_SHADING_RATE_COMBINER_OP_KEEP_KHR = 0,
    VK_FRAGMENT_SHADING_RATE_COMBINER_OP_REPLACE_KHR = 1,
    VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MIN_KHR = 2,
    VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MAX_KHR = 3,
    VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MUL_KHR = 4,
}

enum VK_FRAGMENT_SHADING_RATE_COMBINER_OP_KEEP_KHR = VkFragmentShadingRateCombinerOpKHR.VK_FRAGMENT_SHADING_RATE_COMBINER_OP_KEEP_KHR;
enum VK_FRAGMENT_SHADING_RATE_COMBINER_OP_REPLACE_KHR = VkFragmentShadingRateCombinerOpKHR.VK_FRAGMENT_SHADING_RATE_COMBINER_OP_REPLACE_KHR;
enum VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MIN_KHR = VkFragmentShadingRateCombinerOpKHR.VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MIN_KHR;
enum VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MAX_KHR = VkFragmentShadingRateCombinerOpKHR.VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MAX_KHR;
enum VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MUL_KHR = VkFragmentShadingRateCombinerOpKHR.VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MUL_KHR;

struct VkFragmentShadingRateAttachmentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_FRAGMENT_SHADING_RATE_ATTACHMENT_INFO_KHR;
    const(void)* pNext;
    const(VkAttachmentReference2)* pFragmentShadingRateAttachment;
    VkExtent2D shadingRateAttachmentTexelSize;
}

struct VkPipelineFragmentShadingRateStateCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_FRAGMENT_SHADING_RATE_STATE_CREATE_INFO_KHR;
    const(void)* pNext;
    VkExtent2D fragmentSize;
    VkFragmentShadingRateCombinerOpKHR combinerOps;
}

struct VkPhysicalDeviceFragmentShadingRateFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_FEATURES_KHR;
    void* pNext;
    VkBool32 pipelineFragmentShadingRate;
    VkBool32 primitiveFragmentShadingRate;
    VkBool32 attachmentFragmentShadingRate;
}

struct VkPhysicalDeviceFragmentShadingRatePropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_PROPERTIES_KHR;
    void* pNext;
    VkExtent2D minFragmentShadingRateAttachmentTexelSize;
    VkExtent2D maxFragmentShadingRateAttachmentTexelSize;
    uint maxFragmentShadingRateAttachmentTexelSizeAspectRatio;
    VkBool32 primitiveFragmentShadingRateWithMultipleViewports;
    VkBool32 layeredShadingRateAttachments;
    VkBool32 fragmentShadingRateNonTrivialCombinerOps;
    VkExtent2D maxFragmentSize;
    uint maxFragmentSizeAspectRatio;
    uint maxFragmentShadingRateCoverageSamples;
    VkSampleCountFlagBits maxFragmentShadingRateRasterizationSamples;
    VkBool32 fragmentShadingRateWithShaderDepthStencilWrites;
    VkBool32 fragmentShadingRateWithSampleMask;
    VkBool32 fragmentShadingRateWithShaderSampleMask;
    VkBool32 fragmentShadingRateWithConservativeRasterization;
    VkBool32 fragmentShadingRateWithFragmentShaderInterlock;
    VkBool32 fragmentShadingRateWithCustomSampleLocations;
    VkBool32 fragmentShadingRateStrictMultiplyCombiner;
}

struct VkPhysicalDeviceFragmentShadingRateKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_KHR;
    void* pNext;
    VkFlags sampleCounts;
    VkExtent2D fragmentSize;
}

alias PFN_vkGetPhysicalDeviceFragmentShadingRatesKHR = VkResult function(
    VkPhysicalDevice physicalDevice,
    uint* pFragmentShadingRateCount,
    VkPhysicalDeviceFragmentShadingRateKHR* pFragmentShadingRates,
);

alias PFN_vkCmdSetFragmentShadingRateKHR = void function(
    VkCommandBuffer commandBuffer,
    const(VkExtent2D)* pFragmentSize,
    const(VkFragmentShadingRateCombinerOpKHR) combinerOps,
);

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
}

struct VkRenderingFragmentShadingRateAttachmentInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDERING_FRAGMENT_SHADING_RATE_ATTACHMENT_INFO_KHR;
    const(void)* pNext;
    VkImageView imageView;
    VkImageLayout imageLayout;
    VkExtent2D shadingRateAttachmentTexelSize;
}
