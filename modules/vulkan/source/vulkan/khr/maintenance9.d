/**
 * VK_KHR_maintenance9
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance9;

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

enum VK_KHR_MAINTENANCE_9_SPEC_VERSION = 1;
enum VK_KHR_MAINTENANCE_9_EXTENSION_NAME = "VK_KHR_maintenance9";

struct VkPhysicalDeviceMaintenance9FeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_9_FEATURES_KHR;
    void* pNext;
    VkBool32 maintenance9;
}

struct VkPhysicalDeviceMaintenance9PropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_9_PROPERTIES_KHR;
    void* pNext;
    VkBool32 image2DViewOf3DSparse;
    VkDefaultVertexAttributeValueKHR defaultVertexAttributeValue;
}

struct VkQueueFamilyOwnershipTransferPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_OWNERSHIP_TRANSFER_PROPERTIES_KHR;
    void* pNext;
    uint optimalImageTransferToQueueFamilies;
}

enum VkDefaultVertexAttributeValueKHR {
    VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ZERO_KHR = 0,
    VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ONE_KHR = 1,
}

enum VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ZERO_KHR = VkDefaultVertexAttributeValueKHR.VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ZERO_KHR;
enum VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ONE_KHR = VkDefaultVertexAttributeValueKHR.VK_DEFAULT_VERTEX_ATTRIBUTE_VALUE_ZERO_ZERO_ZERO_ONE_KHR;
