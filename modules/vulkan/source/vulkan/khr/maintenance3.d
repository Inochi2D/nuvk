/**
 * VK_KHR_maintenance3
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance3;

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

struct VK_KHR_maintenance3 {
    
    @VkProcName("vkGetDescriptorSetLayoutSupport")
    PFN_vkGetDescriptorSetLayoutSupport vkGetDescriptorSetLayoutSupport;
}

enum VK_KHR_MAINTENANCE_3_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_3_EXTENSION_NAME = "VK_KHR_maintenance3";
deprecated("aliased")
enum VK_KHR_MAINTENANCE3_SPEC_VERSION = VK_KHR_MAINTENANCE_3_SPEC_VERSION;
deprecated("aliased")
enum VK_KHR_MAINTENANCE3_EXTENSION_NAME = VK_KHR_MAINTENANCE_3_EXTENSION_NAME;

alias VkPhysicalDeviceMaintenance3PropertiesKHR = VkPhysicalDeviceMaintenance3Properties;

alias VkDescriptorSetLayoutSupportKHR = VkDescriptorSetLayoutSupport;

alias PFN_vkGetDescriptorSetLayoutSupport = void function(
    VkDevice device,
    const(VkDescriptorSetLayoutCreateInfo)* pCreateInfo,
    VkDescriptorSetLayoutSupport* pSupport,
);
