/**
    VK_KHR_external_fence
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.external_fence;
import vulkan.khr.external_memory;
import vulkan.core;

extern (System) @nogc nothrow:

enum VK_KHR_EXTERNAL_FENCE_SPEC_VERSION = 1;
enum VK_KHR_EXTERNAL_FENCE_EXTENSION_NAME = "VK_KHR_external_fence";

alias VkFenceImportFlagsKHR = VkFenceImportFlags;
alias VkExportFenceCreateInfoKHR = VkExportFenceCreateInfo;