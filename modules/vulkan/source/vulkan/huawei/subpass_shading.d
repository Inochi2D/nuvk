/**
 * VK_HUAWEI_subpass_shading (Device)
 * 
 * Author:
 *     Huawei Technologies Co. Ltd.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.huawei.subpass_shading;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
    version (VK_VERSION_1_2) {} else {
        public import vulkan.khr.create_renderpass2;
    }
}

struct VK_HUAWEI_subpass_shading {
    
    @VkProcName("vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI")
    PFN_vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI;
    
    @VkProcName("vkCmdSubpassShadingHUAWEI")
    PFN_vkCmdSubpassShadingHUAWEI vkCmdSubpassShadingHUAWEI;
}

enum VK_HUAWEI_SUBPASS_SHADING_SPEC_VERSION = 3;
enum VK_HUAWEI_SUBPASS_SHADING_EXTENSION_NAME = "VK_HUAWEI_subpass_shading";

struct VkSubpassShadingPipelineCreateInfoHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_SUBPASS_SHADING_PIPELINE_CREATE_INFO_HUAWEI;
    void* pNext;
    VkRenderPass renderPass;
    uint subpass;
}

struct VkPhysicalDeviceSubpassShadingFeaturesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBPASS_SHADING_FEATURES_HUAWEI;
    void* pNext;
    VkBool32 subpassShading;
}

struct VkPhysicalDeviceSubpassShadingPropertiesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBPASS_SHADING_PROPERTIES_HUAWEI;
    void* pNext;
    uint maxSubpassShadingWorkgroupSizeAspectRatio;
}

alias PFN_vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI = VkResult function(
    VkDevice device,
    VkRenderPass renderpass,
    VkExtent2D* pMaxWorkgroupSize,
);

alias PFN_vkCmdSubpassShadingHUAWEI = void function(
    VkCommandBuffer commandBuffer,
);
