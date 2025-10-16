/**
 * VK_HUAWEI_invocation_mask (Device)
 * 
 * Author:
 *     Huawei
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.huawei.invocation_mask;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
}
public import vulkan.khr.ray_tracing_pipeline;

struct VK_HUAWEI_invocation_mask {
    
    @VkProcName("vkCmdBindInvocationMaskHUAWEI")
    PFN_vkCmdBindInvocationMaskHUAWEI vkCmdBindInvocationMaskHUAWEI;
}

enum VK_HUAWEI_INVOCATION_MASK_SPEC_VERSION = 1;
enum VK_HUAWEI_INVOCATION_MASK_EXTENSION_NAME = "VK_HUAWEI_invocation_mask";

struct VkPhysicalDeviceInvocationMaskFeaturesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INVOCATION_MASK_FEATURES_HUAWEI;
    void* pNext;
    VkBool32 invocationMask;
}

alias PFN_vkCmdBindInvocationMaskHUAWEI = void function(
    VkCommandBuffer commandBuffer,
    VkImageView imageView,
    VkImageLayout imageLayout,
);
