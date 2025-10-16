/**
 * VK_QCOM_tile_shading (Device)
 * 
 * Author:
 *     Qualcomm Technologies, Inc.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.qcom.tile_shading;

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

public import vulkan.qcom.tile_properties;
public import vulkan.khr.get_physical_device_properties2;

struct VK_QCOM_tile_shading {
    
    @VkProcName("vkCmdDispatchTileQCOM")
    PFN_vkCmdDispatchTileQCOM vkCmdDispatchTileQCOM;
    
    @VkProcName("vkCmdBeginPerTileExecutionQCOM")
    PFN_vkCmdBeginPerTileExecutionQCOM vkCmdBeginPerTileExecutionQCOM;
    
    @VkProcName("vkCmdEndPerTileExecutionQCOM")
    PFN_vkCmdEndPerTileExecutionQCOM vkCmdEndPerTileExecutionQCOM;
}

enum VK_QCOM_TILE_SHADING_SPEC_VERSION = 2;
enum VK_QCOM_TILE_SHADING_EXTENSION_NAME = "VK_QCOM_tile_shading";

struct VkPhysicalDeviceTileShadingFeaturesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_SHADING_FEATURES_QCOM;
    void* pNext;
    VkBool32 tileShading;
    VkBool32 tileShadingFragmentStage;
    VkBool32 tileShadingColorAttachments;
    VkBool32 tileShadingDepthAttachments;
    VkBool32 tileShadingStencilAttachments;
    VkBool32 tileShadingInputAttachments;
    VkBool32 tileShadingSampledAttachments;
    VkBool32 tileShadingPerTileDraw;
    VkBool32 tileShadingPerTileDispatch;
    VkBool32 tileShadingDispatchTile;
    VkBool32 tileShadingApron;
    VkBool32 tileShadingAnisotropicApron;
    VkBool32 tileShadingAtomicOps;
    VkBool32 tileShadingImageProcessing;
}

struct VkPhysicalDeviceTileShadingPropertiesQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_SHADING_PROPERTIES_QCOM;
    void* pNext;
    uint maxApronSize;
    VkBool32 preferNonCoherent;
    VkExtent2D tileGranularity;
    VkExtent2D maxTileShadingRate;
}

struct VkRenderPassTileShadingCreateInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_RENDER_PASS_TILE_SHADING_CREATE_INFO_QCOM;
    const(void)* pNext;
    VkFlags flags;
    VkExtent2D tileApronSize;
}

struct VkPerTileBeginInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PER_TILE_BEGIN_INFO_QCOM;
    const(void)* pNext;
}

struct VkPerTileEndInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PER_TILE_END_INFO_QCOM;
    const(void)* pNext;
}

struct VkDispatchTileInfoQCOM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPATCH_TILE_INFO_QCOM;
    const(void)* pNext;
}

alias VkTileShadingRenderPassFlagsQCOM = VkFlags;

enum VkTileShadingRenderPassFlagBitsQCOM : uint {
    VK_TILE_SHADING_RENDER_PASS_ENABLE_BIT_QCOM = 1,
    VK_TILE_SHADING_RENDER_PASS_PER_TILE_EXECUTION_BIT_QCOM = 2,
}

enum VK_TILE_SHADING_RENDER_PASS_ENABLE_BIT_QCOM = VkTileShadingRenderPassFlagBitsQCOM.VK_TILE_SHADING_RENDER_PASS_ENABLE_BIT_QCOM;
enum VK_TILE_SHADING_RENDER_PASS_PER_TILE_EXECUTION_BIT_QCOM = VkTileShadingRenderPassFlagBitsQCOM.VK_TILE_SHADING_RENDER_PASS_PER_TILE_EXECUTION_BIT_QCOM;

alias PFN_vkCmdDispatchTileQCOM = void function(
    VkCommandBuffer commandBuffer,
    const(VkDispatchTileInfoQCOM)* pDispatchTileInfo,
);

alias PFN_vkCmdBeginPerTileExecutionQCOM = void function(
    VkCommandBuffer commandBuffer,
    const(VkPerTileBeginInfoQCOM)* pPerTileBeginInfo,
);

alias PFN_vkCmdEndPerTileExecutionQCOM = void function(
    VkCommandBuffer commandBuffer,
    const(VkPerTileEndInfoQCOM)* pPerTileEndInfo,
);
