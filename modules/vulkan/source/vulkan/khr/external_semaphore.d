/**
    VK_KHR_external_semaphore
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.external_semaphore;
import vulkan.khr.external_memory;
import vulkan.core;

extern (System) @nogc nothrow:

enum uint VK_KHR_EXTERNAL_SEMAPHORE_SPEC_VERSION = 1;
enum string VK_KHR_EXTERNAL_SEMAPHORE_EXTENSION_NAME = "VK_KHR_external_semaphore";

alias VkSemaphoreImportFlagsKHR = VkSemaphoreImportFlags;
alias VkExportSemaphoreCreateInfoKHR = VkExportSemaphoreCreateInfo;