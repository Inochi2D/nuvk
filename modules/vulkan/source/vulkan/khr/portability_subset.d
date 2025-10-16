/**
 * VK_KHR_portability_subset
 * 
 * Author:
 *     Khronos
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.portability_subset;

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

enum VK_KHR_PORTABILITY_SUBSET_SPEC_VERSION = 1;
enum VK_KHR_PORTABILITY_SUBSET_EXTENSION_NAME = "VK_KHR_portability_subset";

struct VkPhysicalDevicePortabilitySubsetFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_FEATURES_KHR;
    void* pNext;
    VkBool32 constantAlphaColorBlendFactors;
    VkBool32 events;
    VkBool32 imageViewFormatReinterpretation;
    VkBool32 imageViewFormatSwizzle;
    VkBool32 imageView2DOn3DImage;
    VkBool32 multisampleArrayImage;
    VkBool32 mutableComparisonSamplers;
    VkBool32 pointPolygons;
    VkBool32 samplerMipLodBias;
    VkBool32 separateStencilMaskRef;
    VkBool32 shaderSampleRateInterpolationFunctions;
    VkBool32 tessellationIsolines;
    VkBool32 tessellationPointMode;
    VkBool32 triangleFans;
    VkBool32 vertexAttributeAccessBeyondStride;
}

struct VkPhysicalDevicePortabilitySubsetPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_PROPERTIES_KHR;
    void* pNext;
    uint minVertexInputBindingStrideAlignment;
}
