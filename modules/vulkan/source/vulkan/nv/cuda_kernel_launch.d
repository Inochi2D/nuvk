/**
 * VK_NV_cuda_kernel_launch (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Platform:
 *     Enable declarations for beta/provisional extensions
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.cuda_kernel_launch;

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

struct VK_NV_cuda_kernel_launch {
    
    @VkProcName("vkCreateCudaModuleNV")
    PFN_vkCreateCudaModuleNV vkCreateCudaModuleNV;
    
    @VkProcName("vkGetCudaModuleCacheNV")
    PFN_vkGetCudaModuleCacheNV vkGetCudaModuleCacheNV;
    
    @VkProcName("vkCreateCudaFunctionNV")
    PFN_vkCreateCudaFunctionNV vkCreateCudaFunctionNV;
    
    @VkProcName("vkDestroyCudaModuleNV")
    PFN_vkDestroyCudaModuleNV vkDestroyCudaModuleNV;
    
    @VkProcName("vkDestroyCudaFunctionNV")
    PFN_vkDestroyCudaFunctionNV vkDestroyCudaFunctionNV;
    
    @VkProcName("vkCmdCudaLaunchKernelNV")
    PFN_vkCmdCudaLaunchKernelNV vkCmdCudaLaunchKernelNV;
    
}

enum VK_NV_CUDA_KERNEL_LAUNCH_SPEC_VERSION = 2;
enum VK_NV_CUDA_KERNEL_LAUNCH_EXTENSION_NAME = "VK_NV_cuda_kernel_launch";

alias VkCudaModuleNV = OpaqueHandle!("VkCudaModuleNV");
alias VkCudaFunctionNV = OpaqueHandle!("VkCudaFunctionNV");

struct VkCudaModuleCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CUDA_MODULE_CREATE_INFO_NV;
    const(void)* pNext;
    size_t dataSize;
    const(void)* pData;
}

struct VkCudaFunctionCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CUDA_FUNCTION_CREATE_INFO_NV;
    const(void)* pNext;
    VkCudaModuleNV module_;
    const(char)* pName;
}

struct VkCudaLaunchInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_CUDA_LAUNCH_INFO_NV;
    const(void)* pNext;
    VkCudaFunctionNV function_;
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

struct VkPhysicalDeviceCudaKernelLaunchFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUDA_KERNEL_LAUNCH_FEATURES_NV;
    void* pNext;
    VkBool32 cudaKernelLaunchFeatures;
}

struct VkPhysicalDeviceCudaKernelLaunchPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUDA_KERNEL_LAUNCH_PROPERTIES_NV;
    void* pNext;
    uint computeCapabilityMinor;
    uint computeCapabilityMajor;
}

alias PFN_vkCreateCudaModuleNV = VkResult function(
    VkDevice device,
    const(VkCudaModuleCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkCudaModuleNV* pModule,
);

alias PFN_vkGetCudaModuleCacheNV = VkResult function(
    VkDevice device,
    VkCudaModuleNV module_,
    size_t* pCacheSize,
    void* pCacheData,
);

alias PFN_vkCreateCudaFunctionNV = VkResult function(
    VkDevice device,
    const(VkCudaFunctionCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkCudaFunctionNV* pFunction,
);

alias PFN_vkDestroyCudaModuleNV = void function(
    VkDevice device,
    VkCudaModuleNV module_,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkDestroyCudaFunctionNV = void function(
    VkDevice device,
    VkCudaFunctionNV function_,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCmdCudaLaunchKernelNV = void function(
    VkCommandBuffer commandBuffer,
    const(VkCudaLaunchInfoNV)* pLaunchInfo,
);
