/**
 * VK_KHR_maintenance4 (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.maintenance4;

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

version (VK_VERSION_1_1):

struct VK_KHR_maintenance4 {
    
    @VkProcName("vkGetDeviceBufferMemoryRequirements")
    PFN_vkGetDeviceBufferMemoryRequirements vkGetDeviceBufferMemoryRequirements;
    
    @VkProcName("vkGetDeviceImageMemoryRequirements")
    PFN_vkGetDeviceImageMemoryRequirements vkGetDeviceImageMemoryRequirements;
    
    @VkProcName("vkGetDeviceImageSparseMemoryRequirements")
    PFN_vkGetDeviceImageSparseMemoryRequirements vkGetDeviceImageSparseMemoryRequirements;
}

enum VK_KHR_MAINTENANCE_4_SPEC_VERSION = 2;
enum VK_KHR_MAINTENANCE_4_EXTENSION_NAME = "VK_KHR_maintenance4";

alias VkPhysicalDeviceMaintenance4FeaturesKHR = VkPhysicalDeviceMaintenance4Features;

alias VkPhysicalDeviceMaintenance4PropertiesKHR = VkPhysicalDeviceMaintenance4Properties;

alias VkDeviceBufferMemoryRequirementsKHR = VkDeviceBufferMemoryRequirements;

alias VkDeviceImageMemoryRequirementsKHR = VkDeviceImageMemoryRequirements;

alias PFN_vkGetDeviceBufferMemoryRequirements = void function(
    VkDevice device,
    const(VkDeviceBufferMemoryRequirements)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkGetDeviceImageMemoryRequirements = void function(
    VkDevice device,
    const(VkDeviceImageMemoryRequirements)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkGetDeviceImageSparseMemoryRequirements = void function(
    VkDevice device,
    const(VkDeviceImageMemoryRequirements)* pInfo,
    uint* pSparseMemoryRequirementCount,
    VkSparseImageMemoryRequirements2* pSparseMemoryRequirements,
);
