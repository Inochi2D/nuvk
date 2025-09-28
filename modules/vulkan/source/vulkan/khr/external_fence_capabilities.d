/**
    VK_KHR_external_fence_capabilities
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.external_fence_capabilities;
import vulkan.khr.external_memory;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_FENCE_CAPABILITIES_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_FENCE_CAPABILITIES_EXTENSION_NAME = "VK_KHR_external_fence_capabilities";

alias VkExternalFenceHandleTypeFlagsKHR = VkExternalFenceHandleTypeFlags;
alias VkExternalFenceFeatureFlagsKHR = VkExternalFenceFeatureFlags;
alias VkPhysicalDeviceExternalFenceInfoKHR = VkPhysicalDeviceExternalFenceInfo;
alias VkExternalFencePropertiesKHR = VkExternalFenceProperties;

alias PFN_vkGetPhysicalDeviceExternalFencePropertiesKHR = void function(VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceExternalFenceInfo)* pExternalFenceInfo, VkExternalFenceProperties* pExternalFenceProperties);
