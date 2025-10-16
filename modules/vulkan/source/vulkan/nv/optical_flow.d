/**
 * VK_NV_optical_flow (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.optical_flow;

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

version (VK_VERSION_1_3) {} else {
    public import vulkan.khr.synchronization2;
    public import vulkan.khr.format_feature_flags2;
    version (VK_VERSION_1_1) {} else {
        public import vulkan.khr.get_physical_device_properties2;
    }
}

struct VK_NV_optical_flow {
    
    @VkProcName("vkGetPhysicalDeviceOpticalFlowImageFormatsNV")
    PFN_vkGetPhysicalDeviceOpticalFlowImageFormatsNV vkGetPhysicalDeviceOpticalFlowImageFormatsNV;
    
    @VkProcName("vkCreateOpticalFlowSessionNV")
    PFN_vkCreateOpticalFlowSessionNV vkCreateOpticalFlowSessionNV;
    
    @VkProcName("vkDestroyOpticalFlowSessionNV")
    PFN_vkDestroyOpticalFlowSessionNV vkDestroyOpticalFlowSessionNV;
    
    @VkProcName("vkBindOpticalFlowSessionImageNV")
    PFN_vkBindOpticalFlowSessionImageNV vkBindOpticalFlowSessionImageNV;
    
    @VkProcName("vkCmdOpticalFlowExecuteNV")
    PFN_vkCmdOpticalFlowExecuteNV vkCmdOpticalFlowExecuteNV;
}

enum VK_NV_OPTICAL_FLOW_SPEC_VERSION = 1;
enum VK_NV_OPTICAL_FLOW_EXTENSION_NAME = "VK_NV_optical_flow";

struct VkPhysicalDeviceOpticalFlowFeaturesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPTICAL_FLOW_FEATURES_NV;
    void* pNext;
    VkBool32 opticalFlow;
}

struct VkPhysicalDeviceOpticalFlowPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPTICAL_FLOW_PROPERTIES_NV;
    void* pNext;
    VkFlags supportedOutputGridSizes;
    VkFlags supportedHintGridSizes;
    VkBool32 hintSupported;
    VkBool32 costSupported;
    VkBool32 bidirectionalFlowSupported;
    VkBool32 globalFlowSupported;
    uint minWidth;
    uint minHeight;
    uint maxWidth;
    uint maxHeight;
    uint maxNumRegionsOfInterest;
}

enum VkOpticalFlowUsageFlagBitsNV : uint {
    VK_OPTICAL_FLOW_USAGE_UNKNOWN_NV = 0,
    VK_OPTICAL_FLOW_USAGE_INPUT_BIT_NV = 1,
    VK_OPTICAL_FLOW_USAGE_OUTPUT_BIT_NV = 2,
    VK_OPTICAL_FLOW_USAGE_HINT_BIT_NV = 4,
    VK_OPTICAL_FLOW_USAGE_COST_BIT_NV = 8,
    VK_OPTICAL_FLOW_USAGE_GLOBAL_FLOW_BIT_NV = 16,
}

enum VK_OPTICAL_FLOW_USAGE_UNKNOWN_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_UNKNOWN_NV;
enum VK_OPTICAL_FLOW_USAGE_INPUT_BIT_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_INPUT_BIT_NV;
enum VK_OPTICAL_FLOW_USAGE_OUTPUT_BIT_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_OUTPUT_BIT_NV;
enum VK_OPTICAL_FLOW_USAGE_HINT_BIT_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_HINT_BIT_NV;
enum VK_OPTICAL_FLOW_USAGE_COST_BIT_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_COST_BIT_NV;
enum VK_OPTICAL_FLOW_USAGE_GLOBAL_FLOW_BIT_NV = VkOpticalFlowUsageFlagBitsNV.VK_OPTICAL_FLOW_USAGE_GLOBAL_FLOW_BIT_NV;

alias VkOpticalFlowUsageFlagsNV = VkFlags;

struct VkOpticalFlowImageFormatInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPTICAL_FLOW_IMAGE_FORMAT_INFO_NV;
    const(void)* pNext;
    VkFlags usage;
}

struct VkOpticalFlowImageFormatPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPTICAL_FLOW_IMAGE_FORMAT_PROPERTIES_NV;
    const(void)* pNext;
    VkFormat format;
}

enum VkOpticalFlowGridSizeFlagBitsNV : uint {
    VK_OPTICAL_FLOW_GRID_SIZE_UNKNOWN_NV = 0,
    VK_OPTICAL_FLOW_GRID_SIZE_1X1_BIT_NV = 1,
    VK_OPTICAL_FLOW_GRID_SIZE_2X2_BIT_NV = 2,
    VK_OPTICAL_FLOW_GRID_SIZE_4X4_BIT_NV = 4,
    VK_OPTICAL_FLOW_GRID_SIZE_8X8_BIT_NV = 8,
}

enum VK_OPTICAL_FLOW_GRID_SIZE_UNKNOWN_NV = VkOpticalFlowGridSizeFlagBitsNV.VK_OPTICAL_FLOW_GRID_SIZE_UNKNOWN_NV;
enum VK_OPTICAL_FLOW_GRID_SIZE_1X1_BIT_NV = VkOpticalFlowGridSizeFlagBitsNV.VK_OPTICAL_FLOW_GRID_SIZE_1X1_BIT_NV;
enum VK_OPTICAL_FLOW_GRID_SIZE_2X2_BIT_NV = VkOpticalFlowGridSizeFlagBitsNV.VK_OPTICAL_FLOW_GRID_SIZE_2X2_BIT_NV;
enum VK_OPTICAL_FLOW_GRID_SIZE_4X4_BIT_NV = VkOpticalFlowGridSizeFlagBitsNV.VK_OPTICAL_FLOW_GRID_SIZE_4X4_BIT_NV;
enum VK_OPTICAL_FLOW_GRID_SIZE_8X8_BIT_NV = VkOpticalFlowGridSizeFlagBitsNV.VK_OPTICAL_FLOW_GRID_SIZE_8X8_BIT_NV;

alias VkOpticalFlowGridSizeFlagsNV = VkFlags;

enum VkOpticalFlowPerformanceLevelNV {
    VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_UNKNOWN_NV = 0,
    VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_SLOW_NV = 1,
    VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_MEDIUM_NV = 2,
    VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_FAST_NV = 3,
}

enum VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_UNKNOWN_NV = VkOpticalFlowPerformanceLevelNV.VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_UNKNOWN_NV;
enum VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_SLOW_NV = VkOpticalFlowPerformanceLevelNV.VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_SLOW_NV;
enum VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_MEDIUM_NV = VkOpticalFlowPerformanceLevelNV.VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_MEDIUM_NV;
enum VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_FAST_NV = VkOpticalFlowPerformanceLevelNV.VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_FAST_NV;

enum VkOpticalFlowSessionBindingPointNV {
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_UNKNOWN_NV = 0,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_INPUT_NV = 1,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_REFERENCE_NV = 2,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_HINT_NV = 3,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_FLOW_VECTOR_NV = 4,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_FLOW_VECTOR_NV = 5,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_COST_NV = 6,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_COST_NV = 7,
    VK_OPTICAL_FLOW_SESSION_BINDING_POINT_GLOBAL_FLOW_NV = 8,
}

enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_UNKNOWN_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_UNKNOWN_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_INPUT_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_INPUT_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_REFERENCE_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_REFERENCE_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_HINT_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_HINT_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_FLOW_VECTOR_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_FLOW_VECTOR_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_FLOW_VECTOR_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_FLOW_VECTOR_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_COST_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_COST_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_COST_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_COST_NV;
enum VK_OPTICAL_FLOW_SESSION_BINDING_POINT_GLOBAL_FLOW_NV = VkOpticalFlowSessionBindingPointNV.VK_OPTICAL_FLOW_SESSION_BINDING_POINT_GLOBAL_FLOW_NV;

enum VkOpticalFlowSessionCreateFlagBitsNV : uint {
    VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_HINT_BIT_NV = 1,
    VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_COST_BIT_NV = 2,
    VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_GLOBAL_FLOW_BIT_NV = 4,
    VK_OPTICAL_FLOW_SESSION_CREATE_ALLOW_REGIONS_BIT_NV = 8,
    VK_OPTICAL_FLOW_SESSION_CREATE_BOTH_DIRECTIONS_BIT_NV = 16,
}

enum VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_HINT_BIT_NV = VkOpticalFlowSessionCreateFlagBitsNV.VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_HINT_BIT_NV;
enum VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_COST_BIT_NV = VkOpticalFlowSessionCreateFlagBitsNV.VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_COST_BIT_NV;
enum VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_GLOBAL_FLOW_BIT_NV = VkOpticalFlowSessionCreateFlagBitsNV.VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_GLOBAL_FLOW_BIT_NV;
enum VK_OPTICAL_FLOW_SESSION_CREATE_ALLOW_REGIONS_BIT_NV = VkOpticalFlowSessionCreateFlagBitsNV.VK_OPTICAL_FLOW_SESSION_CREATE_ALLOW_REGIONS_BIT_NV;
enum VK_OPTICAL_FLOW_SESSION_CREATE_BOTH_DIRECTIONS_BIT_NV = VkOpticalFlowSessionCreateFlagBitsNV.VK_OPTICAL_FLOW_SESSION_CREATE_BOTH_DIRECTIONS_BIT_NV;

alias VkOpticalFlowSessionCreateFlagsNV = VkFlags;

enum VkOpticalFlowExecuteFlagBitsNV : uint {
    VK_OPTICAL_FLOW_EXECUTE_DISABLE_TEMPORAL_HINTS_BIT_NV = 1,
}

enum VK_OPTICAL_FLOW_EXECUTE_DISABLE_TEMPORAL_HINTS_BIT_NV = VkOpticalFlowExecuteFlagBitsNV.VK_OPTICAL_FLOW_EXECUTE_DISABLE_TEMPORAL_HINTS_BIT_NV;

alias VkOpticalFlowExecuteFlagsNV = VkFlags;

alias VkOpticalFlowSessionNV = OpaqueHandle!("VkOpticalFlowSessionNV");

struct VkOpticalFlowSessionCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_INFO_NV;
    void* pNext;
    uint width;
    uint height;
    VkFormat imageFormat;
    VkFormat flowVectorFormat;
    VkFormat costFormat;
    VkFlags outputGridSize;
    VkFlags hintGridSize;
    VkOpticalFlowPerformanceLevelNV performanceLevel;
    VkFlags flags;
}

struct VkOpticalFlowSessionCreatePrivateDataInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_PRIVATE_DATA_INFO_NV;
    void* pNext;
    uint id;
    uint size;
    const(void)* pPrivateData;
}

struct VkOpticalFlowExecuteInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPTICAL_FLOW_EXECUTE_INFO_NV;
    void* pNext;
    VkFlags flags;
    uint regionCount;
    const(VkRect2D)* pRegions;
}

alias PFN_vkGetPhysicalDeviceOpticalFlowImageFormatsNV = VkResult function(
    VkPhysicalDevice physicalDevice,
    const(VkOpticalFlowImageFormatInfoNV)* pOpticalFlowImageFormatInfo,
    uint* pFormatCount,
    VkOpticalFlowImageFormatPropertiesNV* pImageFormatProperties,
);

alias PFN_vkCreateOpticalFlowSessionNV = VkResult function(
    VkDevice device,
    const(VkOpticalFlowSessionCreateInfoNV)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkOpticalFlowSessionNV* pSession,
);

alias PFN_vkDestroyOpticalFlowSessionNV = void function(
    VkDevice device,
    VkOpticalFlowSessionNV session,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkBindOpticalFlowSessionImageNV = VkResult function(
    VkDevice device,
    VkOpticalFlowSessionNV session,
    VkOpticalFlowSessionBindingPointNV bindingPoint,
    VkImageView view,
    VkImageLayout layout,
);

alias PFN_vkCmdOpticalFlowExecuteNV = void function(
    VkCommandBuffer commandBuffer,
    VkOpticalFlowSessionNV session,
    const(VkOpticalFlowExecuteInfoNV)* pExecuteInfo,
);
