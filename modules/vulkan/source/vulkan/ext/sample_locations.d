/**
 * VK_EXT_sample_locations
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.sample_locations;

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

struct VK_EXT_sample_locations {
    
    @VkProcName("vkCmdSetSampleLocationsEXT")
    PFN_vkCmdSetSampleLocationsEXT vkCmdSetSampleLocationsEXT;
    
    @VkProcName("vkGetPhysicalDeviceMultisamplePropertiesEXT")
    PFN_vkGetPhysicalDeviceMultisamplePropertiesEXT vkGetPhysicalDeviceMultisamplePropertiesEXT;
}

enum VK_EXT_SAMPLE_LOCATIONS_SPEC_VERSION = 1;
enum VK_EXT_SAMPLE_LOCATIONS_EXTENSION_NAME = "VK_EXT_sample_locations";

struct VkSampleLocationEXT {
    float x;
    float y;
}

struct VkSampleLocationsInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLE_LOCATIONS_INFO_EXT;
    const(void)* pNext;
    VkSampleCountFlagBits sampleLocationsPerPixel;
    VkExtent2D sampleLocationGridSize;
    uint sampleLocationsCount;
    const(VkSampleLocationEXT)* pSampleLocations;
}

struct VkAttachmentSampleLocationsEXT {
    uint attachmentIndex;
    VkSampleLocationsInfoEXT sampleLocationsInfo;
}

struct VkSubpassSampleLocationsEXT {
    uint subpassIndex;
    VkSampleLocationsInfoEXT sampleLocationsInfo;
}

struct VkRenderPassSampleLocationsBeginInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_SAMPLE_LOCATIONS_BEGIN_INFO_EXT;
    const(void)* pNext;
    uint attachmentInitialSampleLocationsCount;
    const(VkAttachmentSampleLocationsEXT)* pAttachmentInitialSampleLocations;
    uint postSubpassSampleLocationsCount;
    const(VkSubpassSampleLocationsEXT)* pPostSubpassSampleLocations;
}

struct VkPipelineSampleLocationsStateCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PIPELINE_SAMPLE_LOCATIONS_STATE_CREATE_INFO_EXT;
    const(void)* pNext;
    VkBool32 sampleLocationsEnable;
    VkSampleLocationsInfoEXT sampleLocationsInfo;
}

struct VkPhysicalDeviceSampleLocationsPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLE_LOCATIONS_PROPERTIES_EXT;
    void* pNext;
    VkFlags sampleLocationSampleCounts;
    VkExtent2D maxSampleLocationGridSize;
    float sampleLocationCoordinateRange;
    uint sampleLocationSubPixelBits;
    VkBool32 variableSampleLocations;
}

struct VkMultisamplePropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_MULTISAMPLE_PROPERTIES_EXT;
    void* pNext;
    VkExtent2D maxSampleLocationGridSize;
}

alias PFN_vkCmdSetSampleLocationsEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkSampleLocationsInfoEXT)* pSampleLocationsInfo,
);

alias PFN_vkGetPhysicalDeviceMultisamplePropertiesEXT = void function(
    VkPhysicalDevice physicalDevice,
    VkSampleCountFlagBits samples,
    VkMultisamplePropertiesEXT* pMultisampleProperties,
);
