/**
 * VK_AMD_shader_info
 * 
 * Author:
 *     Advanced Micro Devices, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.amd.shader_info;

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

struct VK_AMD_shader_info {
    
    @VkProcName("vkGetShaderInfoAMD")
    PFN_vkGetShaderInfoAMD vkGetShaderInfoAMD;
}

enum VK_AMD_SHADER_INFO_SPEC_VERSION = 1;
enum VK_AMD_SHADER_INFO_EXTENSION_NAME = "VK_AMD_shader_info";

enum VkShaderInfoTypeAMD {
    VK_SHADER_INFO_TYPE_STATISTICS_AMD = 0,
    VK_SHADER_INFO_TYPE_BINARY_AMD = 1,
    VK_SHADER_INFO_TYPE_DISASSEMBLY_AMD = 2,
}

enum VK_SHADER_INFO_TYPE_STATISTICS_AMD = VkShaderInfoTypeAMD.VK_SHADER_INFO_TYPE_STATISTICS_AMD;
enum VK_SHADER_INFO_TYPE_BINARY_AMD = VkShaderInfoTypeAMD.VK_SHADER_INFO_TYPE_BINARY_AMD;
enum VK_SHADER_INFO_TYPE_DISASSEMBLY_AMD = VkShaderInfoTypeAMD.VK_SHADER_INFO_TYPE_DISASSEMBLY_AMD;

struct VkShaderResourceUsageAMD {
    uint numUsedVgprs;
    uint numUsedSgprs;
    uint ldsSizePerLocalWorkGroup;
    size_t ldsUsageSizeInBytes;
    size_t scratchMemUsageInBytes;
}

struct VkShaderStatisticsInfoAMD {
    VkFlags shaderStageMask;
    VkShaderResourceUsageAMD resourceUsage;
    uint numPhysicalVgprs;
    uint numPhysicalSgprs;
    uint numAvailableVgprs;
    uint numAvailableSgprs;
    uint computeWorkGroupSize;
}

alias PFN_vkGetShaderInfoAMD = VkResult function(
    VkDevice device,
    VkPipeline pipeline,
    VkShaderStageFlagBits shaderStage,
    VkShaderInfoTypeAMD infoType,
    size_t* pInfoSize,
    void* pInfo,
);
