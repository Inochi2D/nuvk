/**
 * VK_NVX_binary_import (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nvx.binary_import;

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

struct VK_NVX_binary_import {
    
    @VkProcName("vkCreateCuModuleNVX")
    PFN_vkCreateCuModuleNVX vkCreateCuModuleNVX;
    
    @VkProcName("vkCreateCuFunctionNVX")
    PFN_vkCreateCuFunctionNVX vkCreateCuFunctionNVX;
    
    @VkProcName("vkDestroyCuModuleNVX")
    PFN_vkDestroyCuModuleNVX vkDestroyCuModuleNVX;
    
    @VkProcName("vkDestroyCuFunctionNVX")
    PFN_vkDestroyCuFunctionNVX vkDestroyCuFunctionNVX;
    
    @VkProcName("vkCmdCuLaunchKernelNVX")
    PFN_vkCmdCuLaunchKernelNVX vkCmdCuLaunchKernelNVX;
    
}

enum VK_NVX_BINARY_IMPORT_SPEC_VERSION = 2;
enum VK_NVX_BINARY_IMPORT_EXTENSION_NAME = "VK_NVX_binary_import";

alias VkCuModuleNVX = OpaqueHandle!("VkCuModuleNVX");
alias VkCuFunctionNVX = OpaqueHandle!("VkCuFunctionNVX");

struct VkCuModuleCreateInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_CU_MODULE_CREATE_INFO_NVX;
    const(void)* pNext;
    size_t dataSize;
    const(void)* pData;
}

struct VkCuModuleTexturingModeCreateInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_CU_MODULE_TEXTURING_MODE_CREATE_INFO_NVX;
    const(void)* pNext;
    VkBool32 use64bitTexturing;
}

struct VkCuFunctionCreateInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_CU_FUNCTION_CREATE_INFO_NVX;
    const(void)* pNext;
    VkCuModuleNVX module_;
    const(char)* pName;
}

struct VkCuLaunchInfoNVX {
    VkStructureType sType = VK_STRUCTURE_TYPE_CU_LAUNCH_INFO_NVX;
    const(void)* pNext;
    VkCuFunctionNVX function_;
    uint gridDimX;
    uint gridDimY;
    uint gridDimZ;
    uint blockDimX;
    uint blockDimY;
    uint blockDimZ;
    uint sharedMemBytes;
    size_t paramCount;
    const(const(void)*)* pParams;
    size_t extraCount;
    const(const(void)*)* pExtras;
}

alias PFN_vkCreateCuModuleNVX = VkResult function(
    VkDevice device,
    const(VkCuModuleCreateInfoNVX)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkCuModuleNVX* pModule,
);

alias PFN_vkCreateCuFunctionNVX = VkResult function(
    VkDevice device,
    const(VkCuFunctionCreateInfoNVX)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkCuFunctionNVX* pFunction,
);

alias PFN_vkDestroyCuModuleNVX = void function(
    VkDevice device,
    VkCuModuleNVX module_,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkDestroyCuFunctionNVX = void function(
    VkDevice device,
    VkCuFunctionNVX function_,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCmdCuLaunchKernelNVX = void function(
    VkCommandBuffer commandBuffer,
    const(VkCuLaunchInfoNVX)* pLaunchInfo,
);
