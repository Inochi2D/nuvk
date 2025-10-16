/**
 * VK_EXT_shader_object (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.shader_object;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.dynamic_rendering;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_EXT_shader_object {
    
    @VkProcName("vkCreateShadersEXT")
    PFN_vkCreateShadersEXT vkCreateShadersEXT;
    
    @VkProcName("vkDestroyShaderEXT")
    PFN_vkDestroyShaderEXT vkDestroyShaderEXT;
    
    @VkProcName("vkGetShaderBinaryDataEXT")
    PFN_vkGetShaderBinaryDataEXT vkGetShaderBinaryDataEXT;
    
    @VkProcName("vkCmdBindShadersEXT")
    PFN_vkCmdBindShadersEXT vkCmdBindShadersEXT;
    
    @VkProcName("vkCmdSetCullMode")
    PFN_vkCmdSetCullMode vkCmdSetCullMode;
    
    @VkProcName("vkCmdSetFrontFace")
    PFN_vkCmdSetFrontFace vkCmdSetFrontFace;
    
    @VkProcName("vkCmdSetPrimitiveTopology")
    PFN_vkCmdSetPrimitiveTopology vkCmdSetPrimitiveTopology;
    
    @VkProcName("vkCmdSetViewportWithCount")
    PFN_vkCmdSetViewportWithCount vkCmdSetViewportWithCount;
    
    @VkProcName("vkCmdSetScissorWithCount")
    PFN_vkCmdSetScissorWithCount vkCmdSetScissorWithCount;
    
    @VkProcName("vkCmdBindVertexBuffers2")
    PFN_vkCmdBindVertexBuffers2 vkCmdBindVertexBuffers2;
    
    @VkProcName("vkCmdSetDepthTestEnable")
    PFN_vkCmdSetDepthTestEnable vkCmdSetDepthTestEnable;
    
    @VkProcName("vkCmdSetDepthWriteEnable")
    PFN_vkCmdSetDepthWriteEnable vkCmdSetDepthWriteEnable;
    
    @VkProcName("vkCmdSetDepthCompareOp")
    PFN_vkCmdSetDepthCompareOp vkCmdSetDepthCompareOp;
    
    @VkProcName("vkCmdSetDepthBoundsTestEnable")
    PFN_vkCmdSetDepthBoundsTestEnable vkCmdSetDepthBoundsTestEnable;
    
    @VkProcName("vkCmdSetStencilTestEnable")
    PFN_vkCmdSetStencilTestEnable vkCmdSetStencilTestEnable;
    
    @VkProcName("vkCmdSetStencilOp")
    PFN_vkCmdSetStencilOp vkCmdSetStencilOp;
    
    @VkProcName("vkCmdSetVertexInputEXT")
    PFN_vkCmdSetVertexInputEXT vkCmdSetVertexInputEXT;
    
    @VkProcName("vkCmdSetPatchControlPointsEXT")
    PFN_vkCmdSetPatchControlPointsEXT vkCmdSetPatchControlPointsEXT;
    
    @VkProcName("vkCmdSetRasterizerDiscardEnable")
    PFN_vkCmdSetRasterizerDiscardEnable vkCmdSetRasterizerDiscardEnable;
    
    @VkProcName("vkCmdSetDepthBiasEnable")
    PFN_vkCmdSetDepthBiasEnable vkCmdSetDepthBiasEnable;
    
    @VkProcName("vkCmdSetLogicOpEXT")
    PFN_vkCmdSetLogicOpEXT vkCmdSetLogicOpEXT;
    
    @VkProcName("vkCmdSetPrimitiveRestartEnable")
    PFN_vkCmdSetPrimitiveRestartEnable vkCmdSetPrimitiveRestartEnable;
    
    @VkProcName("vkCmdSetTessellationDomainOriginEXT")
    PFN_vkCmdSetTessellationDomainOriginEXT vkCmdSetTessellationDomainOriginEXT;
    
    @VkProcName("vkCmdSetDepthClampEnableEXT")
    PFN_vkCmdSetDepthClampEnableEXT vkCmdSetDepthClampEnableEXT;
    
    @VkProcName("vkCmdSetPolygonModeEXT")
    PFN_vkCmdSetPolygonModeEXT vkCmdSetPolygonModeEXT;
    
    @VkProcName("vkCmdSetRasterizationSamplesEXT")
    PFN_vkCmdSetRasterizationSamplesEXT vkCmdSetRasterizationSamplesEXT;
    
    @VkProcName("vkCmdSetSampleMaskEXT")
    PFN_vkCmdSetSampleMaskEXT vkCmdSetSampleMaskEXT;
    
    @VkProcName("vkCmdSetAlphaToCoverageEnableEXT")
    PFN_vkCmdSetAlphaToCoverageEnableEXT vkCmdSetAlphaToCoverageEnableEXT;
    
    @VkProcName("vkCmdSetAlphaToOneEnableEXT")
    PFN_vkCmdSetAlphaToOneEnableEXT vkCmdSetAlphaToOneEnableEXT;
    
    @VkProcName("vkCmdSetLogicOpEnableEXT")
    PFN_vkCmdSetLogicOpEnableEXT vkCmdSetLogicOpEnableEXT;
    
    @VkProcName("vkCmdSetColorBlendEnableEXT")
    PFN_vkCmdSetColorBlendEnableEXT vkCmdSetColorBlendEnableEXT;
    
    @VkProcName("vkCmdSetColorBlendEquationEXT")
    PFN_vkCmdSetColorBlendEquationEXT vkCmdSetColorBlendEquationEXT;
    
    @VkProcName("vkCmdSetColorWriteMaskEXT")
    PFN_vkCmdSetColorWriteMaskEXT vkCmdSetColorWriteMaskEXT;
    
    @VkProcName("vkCmdSetRasterizationStreamEXT")
    PFN_vkCmdSetRasterizationStreamEXT vkCmdSetRasterizationStreamEXT;
    
    @VkProcName("vkCmdSetConservativeRasterizationModeEXT")
    PFN_vkCmdSetConservativeRasterizationModeEXT vkCmdSetConservativeRasterizationModeEXT;
    
    @VkProcName("vkCmdSetExtraPrimitiveOverestimationSizeEXT")
    PFN_vkCmdSetExtraPrimitiveOverestimationSizeEXT vkCmdSetExtraPrimitiveOverestimationSizeEXT;
    
    @VkProcName("vkCmdSetDepthClipEnableEXT")
    PFN_vkCmdSetDepthClipEnableEXT vkCmdSetDepthClipEnableEXT;
    
    @VkProcName("vkCmdSetSampleLocationsEnableEXT")
    PFN_vkCmdSetSampleLocationsEnableEXT vkCmdSetSampleLocationsEnableEXT;
    
    @VkProcName("vkCmdSetColorBlendAdvancedEXT")
    PFN_vkCmdSetColorBlendAdvancedEXT vkCmdSetColorBlendAdvancedEXT;
    
    @VkProcName("vkCmdSetProvokingVertexModeEXT")
    PFN_vkCmdSetProvokingVertexModeEXT vkCmdSetProvokingVertexModeEXT;
    
    @VkProcName("vkCmdSetLineRasterizationModeEXT")
    PFN_vkCmdSetLineRasterizationModeEXT vkCmdSetLineRasterizationModeEXT;
    
    @VkProcName("vkCmdSetLineStippleEnableEXT")
    PFN_vkCmdSetLineStippleEnableEXT vkCmdSetLineStippleEnableEXT;
    
    @VkProcName("vkCmdSetDepthClipNegativeOneToOneEXT")
    PFN_vkCmdSetDepthClipNegativeOneToOneEXT vkCmdSetDepthClipNegativeOneToOneEXT;
    
    
    
    @VkProcName("vkCmdSetViewportWScalingEnableNV")
    PFN_vkCmdSetViewportWScalingEnableNV vkCmdSetViewportWScalingEnableNV;
    
    @VkProcName("vkCmdSetViewportSwizzleNV")
    PFN_vkCmdSetViewportSwizzleNV vkCmdSetViewportSwizzleNV;
    
    @VkProcName("vkCmdSetCoverageToColorEnableNV")
    PFN_vkCmdSetCoverageToColorEnableNV vkCmdSetCoverageToColorEnableNV;
    
    @VkProcName("vkCmdSetCoverageToColorLocationNV")
    PFN_vkCmdSetCoverageToColorLocationNV vkCmdSetCoverageToColorLocationNV;
    
    @VkProcName("vkCmdSetCoverageModulationModeNV")
    PFN_vkCmdSetCoverageModulationModeNV vkCmdSetCoverageModulationModeNV;
    
    @VkProcName("vkCmdSetCoverageModulationTableEnableNV")
    PFN_vkCmdSetCoverageModulationTableEnableNV vkCmdSetCoverageModulationTableEnableNV;
    
    @VkProcName("vkCmdSetCoverageModulationTableNV")
    PFN_vkCmdSetCoverageModulationTableNV vkCmdSetCoverageModulationTableNV;
    
    @VkProcName("vkCmdSetShadingRateImageEnableNV")
    PFN_vkCmdSetShadingRateImageEnableNV vkCmdSetShadingRateImageEnableNV;
    
    @VkProcName("vkCmdSetRepresentativeFragmentTestEnableNV")
    PFN_vkCmdSetRepresentativeFragmentTestEnableNV vkCmdSetRepresentativeFragmentTestEnableNV;
    
    @VkProcName("vkCmdSetCoverageReductionModeNV")
    PFN_vkCmdSetCoverageReductionModeNV vkCmdSetCoverageReductionModeNV;
    
    @VkProcName("vkCmdSetDepthClampRangeEXT")
    PFN_vkCmdSetDepthClampRangeEXT vkCmdSetDepthClampRangeEXT;
}

enum VK_EXT_SHADER_OBJECT_SPEC_VERSION = 1;
enum VK_EXT_SHADER_OBJECT_EXTENSION_NAME = "VK_EXT_shader_object";

alias VkShaderEXT = OpaqueHandle!("VkShaderEXT");

enum VkShaderCreateFlagBitsEXT : uint {
    VK_SHADER_CREATE_LINK_STAGE_BIT_EXT = 1,
    VK_SHADER_CREATE_RESERVED_17_BIT_IMG = 131072,
    VK_SHADER_CREATE_RESERVED_10_BIT_KHR = 1024,
    VK_SHADER_CREATE_RESERVED_11_BIT_KHR = 2048,
    VK_SHADER_CREATE_RESERVED_16_BIT_KHR = 65536,
    VK_SHADER_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT_EXT = 2,
    VK_SHADER_CREATE_REQUIRE_FULL_SUBGROUPS_BIT_EXT = 4,
    VK_SHADER_CREATE_NO_TASK_SHADER_BIT_EXT = 8,
    VK_SHADER_CREATE_DISPATCH_BASE_BIT_EXT = 16,
    VK_SHADER_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_EXT = 32,
    VK_SHADER_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT = 64,
    VK_SHADER_CREATE_INDIRECT_BINDABLE_BIT_EXT = 128,
    VK_SHADER_CREATE_RESERVED_8_BIT_EXT = 256,
    VK_SHADER_CREATE_RESERVED_9_BIT_EXT = 512,
    VK_SHADER_CREATE_RESERVED_12_BIT_EXT = 4096,
    VK_SHADER_CREATE_RESERVED_13_BIT_EXT = 8192,
    VK_SHADER_CREATE_RESERVED_14_BIT_EXT = 16384,
    VK_SHADER_CREATE_RESERVED_15_BIT_EXT = 32768,
    VK_SHADER_CREATE_RESERVED_18_BIT_KHR = 262144,
}

enum VK_SHADER_CREATE_LINK_STAGE_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_LINK_STAGE_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_17_BIT_IMG = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_17_BIT_IMG;
enum VK_SHADER_CREATE_RESERVED_10_BIT_KHR = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_10_BIT_KHR;
enum VK_SHADER_CREATE_RESERVED_11_BIT_KHR = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_11_BIT_KHR;
enum VK_SHADER_CREATE_RESERVED_16_BIT_KHR = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_16_BIT_KHR;
enum VK_SHADER_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT_EXT;
enum VK_SHADER_CREATE_REQUIRE_FULL_SUBGROUPS_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_REQUIRE_FULL_SUBGROUPS_BIT_EXT;
enum VK_SHADER_CREATE_NO_TASK_SHADER_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_NO_TASK_SHADER_BIT_EXT;
enum VK_SHADER_CREATE_DISPATCH_BASE_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_DISPATCH_BASE_BIT_EXT;
enum VK_SHADER_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_EXT;
enum VK_SHADER_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT;
enum VK_SHADER_CREATE_INDIRECT_BINDABLE_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_INDIRECT_BINDABLE_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_8_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_8_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_9_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_9_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_12_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_12_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_13_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_13_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_14_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_14_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_15_BIT_EXT = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_15_BIT_EXT;
enum VK_SHADER_CREATE_RESERVED_18_BIT_KHR = VkShaderCreateFlagBitsEXT.VK_SHADER_CREATE_RESERVED_18_BIT_KHR;

alias VkShaderCreateFlagsEXT = VkFlags;

enum VkShaderCodeTypeEXT {
    VK_SHADER_CODE_TYPE_BINARY_EXT = 0,
    VK_SHADER_CODE_TYPE_SPIRV_EXT = 1,
}

enum VK_SHADER_CODE_TYPE_BINARY_EXT = VkShaderCodeTypeEXT.VK_SHADER_CODE_TYPE_BINARY_EXT;
enum VK_SHADER_CODE_TYPE_SPIRV_EXT = VkShaderCodeTypeEXT.VK_SHADER_CODE_TYPE_SPIRV_EXT;

struct VkPhysicalDeviceShaderObjectFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_OBJECT_FEATURES_EXT;
    void* pNext;
    VkBool32 shaderObject;
}

struct VkPhysicalDeviceShaderObjectPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_OBJECT_PROPERTIES_EXT;
    void* pNext;
    ubyte[VK_UUID_SIZE] shaderBinaryUUID;
    uint shaderBinaryVersion;
}

struct VkShaderCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SHADER_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    VkShaderStageFlagBits stage;
    VkFlags nextStage;
    VkShaderCodeTypeEXT codeType;
    size_t codeSize;
    const(void)* pCode;
    const(char)* pName;
    uint setLayoutCount;
    const(VkDescriptorSetLayout)* pSetLayouts;
    uint pushConstantRangeCount;
    const(VkPushConstantRange)* pPushConstantRanges;
    const(VkSpecializationInfo)* pSpecializationInfo;
}

alias VkShaderRequiredSubgroupSizeCreateInfoEXT = VkPipelineShaderStageRequiredSubgroupSizeCreateInfo;

struct VkVertexInputBindingDescription2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VERTEX_INPUT_BINDING_DESCRIPTION_2_EXT;
    void* pNext;
    uint binding;
    uint stride;
    VkVertexInputRate inputRate;
    uint divisor;
}

struct VkVertexInputAttributeDescription2EXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_VERTEX_INPUT_ATTRIBUTE_DESCRIPTION_2_EXT;
    void* pNext;
    uint location;
    uint binding;
    VkFormat format;
    uint offset;
}

struct VkColorBlendEquationEXT {
    VkBlendFactor srcColorBlendFactor;
    VkBlendFactor dstColorBlendFactor;
    VkBlendOp colorBlendOp;
    VkBlendFactor srcAlphaBlendFactor;
    VkBlendFactor dstAlphaBlendFactor;
    VkBlendOp alphaBlendOp;
}

struct VkColorBlendAdvancedEXT {
    VkBlendOp advancedBlendOp;
    VkBool32 srcPremultiplied;
    VkBool32 dstPremultiplied;
    VkBlendOverlapEXT blendOverlap;
    VkBool32 clampResults;
}

alias PFN_vkCreateShadersEXT = VkResult function(
    VkDevice device,
    uint createInfoCount,
    const(VkShaderCreateInfoEXT)* pCreateInfos,
    const(VkAllocationCallbacks)* pAllocator,
    VkShaderEXT* pShaders,
);

alias PFN_vkDestroyShaderEXT = void function(
    VkDevice device,
    VkShaderEXT shader,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetShaderBinaryDataEXT = VkResult function(
    VkDevice device,
    VkShaderEXT shader,
    size_t* pDataSize,
    void* pData,
);

alias PFN_vkCmdBindShadersEXT = void function(
    VkCommandBuffer commandBuffer,
    uint stageCount,
    const(VkShaderStageFlagBits)* pStages,
    const(VkShaderEXT)* pShaders,
);

alias PFN_vkCmdSetCullMode = void function(
    VkCommandBuffer commandBuffer,
    VkCullModeFlags cullMode,
);

alias PFN_vkCmdSetFrontFace = void function(
    VkCommandBuffer commandBuffer,
    VkFrontFace frontFace,
);

alias PFN_vkCmdSetPrimitiveTopology = void function(
    VkCommandBuffer commandBuffer,
    VkPrimitiveTopology primitiveTopology,
);

alias PFN_vkCmdSetViewportWithCount = void function(
    VkCommandBuffer commandBuffer,
    uint viewportCount,
    const(VkViewport)* pViewports,
);

alias PFN_vkCmdSetScissorWithCount = void function(
    VkCommandBuffer commandBuffer,
    uint scissorCount,
    const(VkRect2D)* pScissors,
);

alias PFN_vkCmdBindVertexBuffers2 = void function(
    VkCommandBuffer commandBuffer,
    uint firstBinding,
    uint bindingCount,
    const(VkBuffer)* pBuffers,
    const(VkDeviceSize)* pOffsets,
    const(VkDeviceSize)* pSizes,
    const(VkDeviceSize)* pStrides,
);

alias PFN_vkCmdSetDepthTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthTestEnable,
);

alias PFN_vkCmdSetDepthWriteEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthWriteEnable,
);

alias PFN_vkCmdSetDepthCompareOp = void function(
    VkCommandBuffer commandBuffer,
    VkCompareOp depthCompareOp,
);

alias PFN_vkCmdSetDepthBoundsTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthBoundsTestEnable,
);

alias PFN_vkCmdSetStencilTestEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 stencilTestEnable,
);

alias PFN_vkCmdSetStencilOp = void function(
    VkCommandBuffer commandBuffer,
    VkStencilFaceFlags faceMask,
    VkStencilOp failOp,
    VkStencilOp passOp,
    VkStencilOp depthFailOp,
    VkCompareOp compareOp,
);

alias PFN_vkCmdSetVertexInputEXT = void function(
    VkCommandBuffer commandBuffer,
    uint vertexBindingDescriptionCount,
    const(VkVertexInputBindingDescription2EXT)* pVertexBindingDescriptions,
    uint vertexAttributeDescriptionCount,
    const(VkVertexInputAttributeDescription2EXT)* pVertexAttributeDescriptions,
);

alias PFN_vkCmdSetPatchControlPointsEXT = void function(
    VkCommandBuffer commandBuffer,
    uint patchControlPoints,
);

alias PFN_vkCmdSetRasterizerDiscardEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 rasterizerDiscardEnable,
);

alias PFN_vkCmdSetDepthBiasEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthBiasEnable,
);

alias PFN_vkCmdSetLogicOpEXT = void function(
    VkCommandBuffer commandBuffer,
    VkLogicOp logicOp,
);

alias PFN_vkCmdSetPrimitiveRestartEnable = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 primitiveRestartEnable,
);

alias PFN_vkCmdSetTessellationDomainOriginEXT = void function(
    VkCommandBuffer commandBuffer,
    VkTessellationDomainOrigin domainOrigin,
);

alias PFN_vkCmdSetDepthClampEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthClampEnable,
);

alias PFN_vkCmdSetPolygonModeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkPolygonMode polygonMode,
);

alias PFN_vkCmdSetRasterizationSamplesEXT = void function(
    VkCommandBuffer commandBuffer,
    VkSampleCountFlagBits rasterizationSamples,
);

alias PFN_vkCmdSetSampleMaskEXT = void function(
    VkCommandBuffer commandBuffer,
    VkSampleCountFlagBits samples,
    const(VkSampleMask)* pSampleMask,
);

alias PFN_vkCmdSetAlphaToCoverageEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 alphaToCoverageEnable,
);

alias PFN_vkCmdSetAlphaToOneEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 alphaToOneEnable,
);

alias PFN_vkCmdSetLogicOpEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 logicOpEnable,
);

alias PFN_vkCmdSetColorBlendEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstAttachment,
    uint attachmentCount,
    const(VkBool32)* pColorBlendEnables,
);

alias PFN_vkCmdSetColorBlendEquationEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstAttachment,
    uint attachmentCount,
    const(VkColorBlendEquationEXT)* pColorBlendEquations,
);

alias PFN_vkCmdSetColorWriteMaskEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstAttachment,
    uint attachmentCount,
    const(VkColorComponentFlags)* pColorWriteMasks,
);

public import vulkan.ext.transform_feedback;

alias PFN_vkCmdSetRasterizationStreamEXT = void function(
    VkCommandBuffer commandBuffer,
    uint rasterizationStream,
);

public import vulkan.ext.conservative_rasterization;

alias PFN_vkCmdSetConservativeRasterizationModeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkConservativeRasterizationModeEXT conservativeRasterizationMode,
);

alias PFN_vkCmdSetExtraPrimitiveOverestimationSizeEXT = void function(
    VkCommandBuffer commandBuffer,
    float extraPrimitiveOverestimationSize,
);

public import vulkan.ext.depth_clip_enable;

alias PFN_vkCmdSetDepthClipEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 depthClipEnable,
);

public import vulkan.ext.sample_locations;

alias PFN_vkCmdSetSampleLocationsEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 sampleLocationsEnable,
);

public import vulkan.ext.blend_operation_advanced;

alias PFN_vkCmdSetColorBlendAdvancedEXT = void function(
    VkCommandBuffer commandBuffer,
    uint firstAttachment,
    uint attachmentCount,
    const(VkColorBlendAdvancedEXT)* pColorBlendAdvanced,
);

public import vulkan.ext.provoking_vertex;

alias PFN_vkCmdSetProvokingVertexModeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkProvokingVertexModeEXT provokingVertexMode,
);

public import vulkan.ext.line_rasterization;

alias PFN_vkCmdSetLineRasterizationModeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkLineRasterizationModeEXT lineRasterizationMode,
);

alias PFN_vkCmdSetLineStippleEnableEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 stippledLineEnable,
);

public import vulkan.ext.depth_clip_control;

alias PFN_vkCmdSetDepthClipNegativeOneToOneEXT = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 negativeOneToOne,
);

public import vulkan.nv.clip_space_w_scaling;

alias PFN_vkCmdSetViewportWScalingEnableNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 viewportWScalingEnable,
);

public import vulkan.nv.viewport_swizzle;

alias PFN_vkCmdSetViewportSwizzleNV = void function(
    VkCommandBuffer commandBuffer,
    uint firstViewport,
    uint viewportCount,
    const(VkViewportSwizzleNV)* pViewportSwizzles,
);

public import vulkan.nv.fragment_coverage_to_color;

alias PFN_vkCmdSetCoverageToColorEnableNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 coverageToColorEnable,
);

alias PFN_vkCmdSetCoverageToColorLocationNV = void function(
    VkCommandBuffer commandBuffer,
    uint coverageToColorLocation,
);

public import vulkan.nv.framebuffer_mixed_samples;

alias PFN_vkCmdSetCoverageModulationModeNV = void function(
    VkCommandBuffer commandBuffer,
    VkCoverageModulationModeNV coverageModulationMode,
);

alias PFN_vkCmdSetCoverageModulationTableEnableNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 coverageModulationTableEnable,
);

alias PFN_vkCmdSetCoverageModulationTableNV = void function(
    VkCommandBuffer commandBuffer,
    uint coverageModulationTableCount,
    const(float)* pCoverageModulationTable,
);

public import vulkan.nv.shading_rate_image;

alias PFN_vkCmdSetShadingRateImageEnableNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 shadingRateImageEnable,
);

public import vulkan.nv.representative_fragment_test;

alias PFN_vkCmdSetRepresentativeFragmentTestEnableNV = void function(
    VkCommandBuffer commandBuffer,
    VkBool32 representativeFragmentTestEnable,
);

public import vulkan.nv.coverage_reduction_mode;

alias PFN_vkCmdSetCoverageReductionModeNV = void function(
    VkCommandBuffer commandBuffer,
    VkCoverageReductionModeNV coverageReductionMode,
);

public import vulkan.ext.depth_clamp_control;

alias PFN_vkCmdSetDepthClampRangeEXT = void function(
    VkCommandBuffer commandBuffer,
    VkDepthClampModeEXT depthClampMode,
    const(VkDepthClampRangeEXT)* pDepthClampRange,
);
