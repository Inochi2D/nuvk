/**
 * VK_KHR_deferred_host_operations (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.deferred_host_operations;

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

struct VK_KHR_deferred_host_operations {
    @VkProcName("vkCreateDeferredOperationKHR")
    PFN_vkCreateDeferredOperationKHR vkCreateDeferredOperationKHR;
    
    @VkProcName("vkDestroyDeferredOperationKHR")
    PFN_vkDestroyDeferredOperationKHR vkDestroyDeferredOperationKHR;
    
    @VkProcName("vkGetDeferredOperationMaxConcurrencyKHR")
    PFN_vkGetDeferredOperationMaxConcurrencyKHR vkGetDeferredOperationMaxConcurrencyKHR;
    
    @VkProcName("vkGetDeferredOperationResultKHR")
    PFN_vkGetDeferredOperationResultKHR vkGetDeferredOperationResultKHR;
    
    @VkProcName("vkDeferredOperationJoinKHR")
    PFN_vkDeferredOperationJoinKHR vkDeferredOperationJoinKHR;
}

enum VK_KHR_DEFERRED_HOST_OPERATIONS_SPEC_VERSION = 4;
enum VK_KHR_DEFERRED_HOST_OPERATIONS_EXTENSION_NAME = "VK_KHR_deferred_host_operations";

alias VkDeferredOperationKHR = OpaqueHandle!("VkDeferredOperationKHR");

alias PFN_vkCreateDeferredOperationKHR = VkResult function(
    VkDevice device,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkDeferredOperationKHR pDeferredOperation,
);

alias PFN_vkDestroyDeferredOperationKHR = void function(
    VkDevice device,
    VkDeferredOperationKHR operation,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetDeferredOperationMaxConcurrencyKHR = uint function(
    VkDevice device,
    VkDeferredOperationKHR operation,
);

alias PFN_vkGetDeferredOperationResultKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR operation,
);

alias PFN_vkDeferredOperationJoinKHR = VkResult function(
    VkDevice device,
    VkDeferredOperationKHR operation,
);
