/**
 * VK_EXT_extended_dynamic_state3 (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.extended_dynamic_state3;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

struct VK_EXT_extended_dynamic_state3 {
    
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
    @VkProcName("vkCmdSetTessellationDomainOriginEXT")
    PFN_vkCmdSetTessellationDomainOriginEXT vkCmdSetTessellationDomainOriginEXT;
    
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
    
    
    
    
    
}

enum VK_EXT_EXTENDED_DYNAMIC_STATE_3_SPEC_VERSION = 2;
enum VK_EXT_EXTENDED_DYNAMIC_STATE_3_EXTENSION_NAME = "VK_EXT_extended_dynamic_state3";

struct VkPhysicalDeviceExtendedDynamicState3FeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_3_FEATURES_EXT;
    void* pNext;
    VkBool32 extendedDynamicState3TessellationDomainOrigin;
    VkBool32 extendedDynamicState3DepthClampEnable;
    VkBool32 extendedDynamicState3PolygonMode;
    VkBool32 extendedDynamicState3RasterizationSamples;
    VkBool32 extendedDynamicState3SampleMask;
    VkBool32 extendedDynamicState3AlphaToCoverageEnable;
    VkBool32 extendedDynamicState3AlphaToOneEnable;
    VkBool32 extendedDynamicState3LogicOpEnable;
    VkBool32 extendedDynamicState3ColorBlendEnable;
    VkBool32 extendedDynamicState3ColorBlendEquation;
    VkBool32 extendedDynamicState3ColorWriteMask;
    VkBool32 extendedDynamicState3RasterizationStream;
    VkBool32 extendedDynamicState3ConservativeRasterizationMode;
    VkBool32 extendedDynamicState3ExtraPrimitiveOverestimationSize;
    VkBool32 extendedDynamicState3DepthClipEnable;
    VkBool32 extendedDynamicState3SampleLocationsEnable;
    VkBool32 extendedDynamicState3ColorBlendAdvanced;
    VkBool32 extendedDynamicState3ProvokingVertexMode;
    VkBool32 extendedDynamicState3LineRasterizationMode;
    VkBool32 extendedDynamicState3LineStippleEnable;
    VkBool32 extendedDynamicState3DepthClipNegativeOneToOne;
    VkBool32 extendedDynamicState3ViewportWScalingEnable;
    VkBool32 extendedDynamicState3ViewportSwizzle;
    VkBool32 extendedDynamicState3CoverageToColorEnable;
    VkBool32 extendedDynamicState3CoverageToColorLocation;
    VkBool32 extendedDynamicState3CoverageModulationMode;
    VkBool32 extendedDynamicState3CoverageModulationTableEnable;
    VkBool32 extendedDynamicState3CoverageModulationTable;
    VkBool32 extendedDynamicState3CoverageReductionMode;
    VkBool32 extendedDynamicState3RepresentativeFragmentTestEnable;
    VkBool32 extendedDynamicState3ShadingRateImageEnable;
}

struct VkPhysicalDeviceExtendedDynamicState3PropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_3_PROPERTIES_EXT;
    void* pNext;
    VkBool32 dynamicPrimitiveTopologyUnrestricted;
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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.maintenance2;
}

alias PFN_vkCmdSetTessellationDomainOriginEXT = void function(
    VkCommandBuffer commandBuffer,
    VkTessellationDomainOrigin domainOrigin,
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
