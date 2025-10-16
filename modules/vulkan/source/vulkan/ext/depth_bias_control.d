/**
 * VK_EXT_depth_bias_control
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.depth_bias_control;

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

struct VK_EXT_depth_bias_control {
    
    @VkProcName("vkCmdSetDepthBias2EXT")
    PFN_vkCmdSetDepthBias2EXT vkCmdSetDepthBias2EXT;
}

enum VK_EXT_DEPTH_BIAS_CONTROL_SPEC_VERSION = 1;
enum VK_EXT_DEPTH_BIAS_CONTROL_EXTENSION_NAME = "VK_EXT_depth_bias_control";

struct VkPhysicalDeviceDepthBiasControlFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_BIAS_CONTROL_FEATURES_EXT;
    void* pNext;
    VkBool32 depthBiasControl;
    VkBool32 leastRepresentableValueForceUnormRepresentation;
    VkBool32 floatRepresentation;
    VkBool32 depthBiasExact;
}

struct VkDepthBiasInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEPTH_BIAS_INFO_EXT;
    const(void)* pNext;
    float depthBiasConstantFactor;
    float depthBiasClamp;
    float depthBiasSlopeFactor;
}

enum VkDepthBiasRepresentationEXT {
    VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORMAT_EXT = 0,
    VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORCE_UNORM_EXT = 1,
    VK_DEPTH_BIAS_REPRESENTATION_FLOAT_EXT = 2,
}

enum VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORMAT_EXT = VkDepthBiasRepresentationEXT.VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORMAT_EXT;
enum VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORCE_UNORM_EXT = VkDepthBiasRepresentationEXT.VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORCE_UNORM_EXT;
enum VK_DEPTH_BIAS_REPRESENTATION_FLOAT_EXT = VkDepthBiasRepresentationEXT.VK_DEPTH_BIAS_REPRESENTATION_FLOAT_EXT;

struct VkDepthBiasRepresentationInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEPTH_BIAS_REPRESENTATION_INFO_EXT;
    const(void)* pNext;
    VkDepthBiasRepresentationEXT depthBiasRepresentation;
    VkBool32 depthBiasExact;
}

alias PFN_vkCmdSetDepthBias2EXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkDepthBiasInfoEXT)* pDepthBiasInfo,
);
