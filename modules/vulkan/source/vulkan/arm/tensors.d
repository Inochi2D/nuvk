/**
 * VK_ARM_tensors
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.tensors;

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

version (VK_VERSION_1_3):

struct VK_ARM_tensors {
    
    @VkProcName("vkCreateTensorARM")
    PFN_vkCreateTensorARM vkCreateTensorARM;
    
    @VkProcName("vkDestroyTensorARM")
    PFN_vkDestroyTensorARM vkDestroyTensorARM;
    
    @VkProcName("vkCreateTensorViewARM")
    PFN_vkCreateTensorViewARM vkCreateTensorViewARM;
    
    @VkProcName("vkDestroyTensorViewARM")
    PFN_vkDestroyTensorViewARM vkDestroyTensorViewARM;
    
    @VkProcName("vkGetTensorMemoryRequirementsARM")
    PFN_vkGetTensorMemoryRequirementsARM vkGetTensorMemoryRequirementsARM;
    
    @VkProcName("vkBindTensorMemoryARM")
    PFN_vkBindTensorMemoryARM vkBindTensorMemoryARM;
    
    @VkProcName("vkGetDeviceTensorMemoryRequirementsARM")
    PFN_vkGetDeviceTensorMemoryRequirementsARM vkGetDeviceTensorMemoryRequirementsARM;
    
    @VkProcName("vkCmdCopyTensorARM")
    PFN_vkCmdCopyTensorARM vkCmdCopyTensorARM;
    
    @VkProcName("vkGetPhysicalDeviceExternalTensorPropertiesARM")
    PFN_vkGetPhysicalDeviceExternalTensorPropertiesARM vkGetPhysicalDeviceExternalTensorPropertiesARM;
    
    @VkProcName("vkGetTensorOpaqueCaptureDescriptorDataARM")
    PFN_vkGetTensorOpaqueCaptureDescriptorDataARM vkGetTensorOpaqueCaptureDescriptorDataARM;
    
    @VkProcName("vkGetTensorViewOpaqueCaptureDescriptorDataARM")
    PFN_vkGetTensorViewOpaqueCaptureDescriptorDataARM vkGetTensorViewOpaqueCaptureDescriptorDataARM;
    
}

enum VK_ARM_TENSORS_SPEC_VERSION = 1;
enum VK_ARM_TENSORS_EXTENSION_NAME = "VK_ARM_tensors";

alias VkTensorARM = OpaqueHandle!("VkTensorARM");
alias VkTensorViewARM = OpaqueHandle!("VkTensorViewARM");

alias VkTensorCreateFlagsARM = VkFlags64;

enum VkTensorCreateFlagBitsARM : ulong {
    VK_TENSOR_CREATE_MUTABLE_FORMAT_BIT_ARM = 1,
    VK_TENSOR_CREATE_PROTECTED_BIT_ARM = 2,
    VK_TENSOR_CREATE_RESERVED_3_BIT_ARM = 8,
    VK_TENSOR_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM = 4,
}

enum VK_TENSOR_CREATE_MUTABLE_FORMAT_BIT_ARM = VkTensorCreateFlagBitsARM.VK_TENSOR_CREATE_MUTABLE_FORMAT_BIT_ARM;
enum VK_TENSOR_CREATE_PROTECTED_BIT_ARM = VkTensorCreateFlagBitsARM.VK_TENSOR_CREATE_PROTECTED_BIT_ARM;
enum VK_TENSOR_CREATE_RESERVED_3_BIT_ARM = VkTensorCreateFlagBitsARM.VK_TENSOR_CREATE_RESERVED_3_BIT_ARM;
enum VK_TENSOR_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM = VkTensorCreateFlagBitsARM.VK_TENSOR_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM;

alias VkTensorViewCreateFlagsARM = VkFlags64;

enum VkTensorViewCreateFlagBitsARM : ulong {
    VK_TENSOR_VIEW_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM = 1,
}

enum VK_TENSOR_VIEW_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM = VkTensorViewCreateFlagBitsARM.VK_TENSOR_VIEW_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_ARM;

alias VkTensorUsageFlagsARM = VkFlags64;

enum VkTensorUsageFlagBitsARM : ulong {
    VK_TENSOR_USAGE_SHADER_BIT_ARM = 2,
    VK_TENSOR_USAGE_TRANSFER_SRC_BIT_ARM = 4,
    VK_TENSOR_USAGE_TRANSFER_DST_BIT_ARM = 8,
    VK_TENSOR_USAGE_IMAGE_ALIASING_BIT_ARM = 16,
    VK_TENSOR_USAGE_DATA_GRAPH_BIT_ARM = 32,
}

enum VK_TENSOR_USAGE_SHADER_BIT_ARM = VkTensorUsageFlagBitsARM.VK_TENSOR_USAGE_SHADER_BIT_ARM;
enum VK_TENSOR_USAGE_TRANSFER_SRC_BIT_ARM = VkTensorUsageFlagBitsARM.VK_TENSOR_USAGE_TRANSFER_SRC_BIT_ARM;
enum VK_TENSOR_USAGE_TRANSFER_DST_BIT_ARM = VkTensorUsageFlagBitsARM.VK_TENSOR_USAGE_TRANSFER_DST_BIT_ARM;
enum VK_TENSOR_USAGE_IMAGE_ALIASING_BIT_ARM = VkTensorUsageFlagBitsARM.VK_TENSOR_USAGE_IMAGE_ALIASING_BIT_ARM;
enum VK_TENSOR_USAGE_DATA_GRAPH_BIT_ARM = VkTensorUsageFlagBitsARM.VK_TENSOR_USAGE_DATA_GRAPH_BIT_ARM;

struct VkTensorDescriptionARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_DESCRIPTION_ARM;
    const(void)* pNext;
    VkTensorTilingARM tiling;
    VkFormat format;
    uint dimensionCount;
    const(long)* pDimensions;
    const(long)* pStrides;
    VkFlags64 usage;
}

enum VkTensorTilingARM {
    VK_TENSOR_TILING_OPTIMAL_ARM = 0,
    VK_TENSOR_TILING_LINEAR_ARM = 1,
}

enum VK_TENSOR_TILING_OPTIMAL_ARM = VkTensorTilingARM.VK_TENSOR_TILING_OPTIMAL_ARM;
enum VK_TENSOR_TILING_LINEAR_ARM = VkTensorTilingARM.VK_TENSOR_TILING_LINEAR_ARM;

struct VkTensorCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_CREATE_INFO_ARM;
    const(void)* pNext;
    VkFlags64 flags;
    const(VkTensorDescriptionARM)* pDescription;
    VkSharingMode sharingMode;
    uint queueFamilyIndexCount;
    const(uint)* pQueueFamilyIndices;
}

struct VkTensorViewCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_VIEW_CREATE_INFO_ARM;
    const(void)* pNext;
    VkFlags64 flags;
    VkTensorARM tensor;
    VkFormat format;
}

struct VkTensorMemoryRequirementsInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_MEMORY_REQUIREMENTS_INFO_ARM;
    const(void)* pNext;
    VkTensorARM tensor;
}

struct VkBindTensorMemoryInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_TENSOR_MEMORY_INFO_ARM;
    const(void)* pNext;
    VkTensorARM tensor;
    VkDeviceMemory memory;
    VkDeviceSize memoryOffset;
}

struct VkWriteDescriptorSetTensorARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_TENSOR_ARM;
    const(void)* pNext;
    uint tensorViewCount;
    const(VkTensorViewARM)* pTensorViews;
}

struct VkTensorFormatPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_FORMAT_PROPERTIES_ARM;
    const(void)* pNext;
    VkFlags64 optimalTilingTensorFeatures;
    VkFlags64 linearTilingTensorFeatures;
}

struct VkPhysicalDeviceTensorPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TENSOR_PROPERTIES_ARM;
    void* pNext;
    uint maxTensorDimensionCount;
    ulong maxTensorElements;
    ulong maxPerDimensionTensorElements;
    long maxTensorStride;
    ulong maxTensorSize;
    uint maxTensorShaderAccessArrayLength;
    uint maxTensorShaderAccessSize;
    uint maxDescriptorSetStorageTensors;
    uint maxPerStageDescriptorSetStorageTensors;
    uint maxDescriptorSetUpdateAfterBindStorageTensors;
    uint maxPerStageDescriptorUpdateAfterBindStorageTensors;
    VkBool32 shaderStorageTensorArrayNonUniformIndexingNative;
    VkFlags shaderTensorSupportedStages;
}

struct VkTensorMemoryBarrierARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_MEMORY_BARRIER_ARM;
    const(void)* pNext;
    VkFlags64 srcStageMask;
    VkFlags64 srcAccessMask;
    VkFlags64 dstStageMask;
    VkFlags64 dstAccessMask;
    uint srcQueueFamilyIndex;
    uint dstQueueFamilyIndex;
    VkTensorARM tensor;
}

struct VkTensorDependencyInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_DEPENDENCY_INFO_ARM;
    const(void)* pNext;
    uint tensorMemoryBarrierCount;
    const(VkTensorMemoryBarrierARM)* pTensorMemoryBarriers;
}

struct VkPhysicalDeviceTensorFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TENSOR_FEATURES_ARM;
    void* pNext;
    VkBool32 tensorNonPacked;
    VkBool32 shaderTensorAccess;
    VkBool32 shaderStorageTensorArrayDynamicIndexing;
    VkBool32 shaderStorageTensorArrayNonUniformIndexing;
    VkBool32 descriptorBindingStorageTensorUpdateAfterBind;
    VkBool32 tensors;
}

struct VkDeviceTensorMemoryRequirementsARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_TENSOR_MEMORY_REQUIREMENTS_ARM;
    const(void)* pNext;
    const(VkTensorCreateInfoARM)* pCreateInfo;
}

struct VkCopyTensorInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_COPY_TENSOR_INFO_ARM;
    const(void)* pNext;
    VkTensorARM srcTensor;
    VkTensorARM dstTensor;
    uint regionCount;
    const(VkTensorCopyARM)* pRegions;
}

struct VkTensorCopyARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_COPY_ARM;
    const(void)* pNext;
    uint dimensionCount;
    const(ulong)* pSrcOffset;
    const(ulong)* pDstOffset;
    const(ulong)* pExtent;
}

struct VkMemoryDedicatedAllocateInfoTensorARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO_TENSOR_ARM;
    const(void)* pNext;
    VkTensorARM tensor;
}

struct VkPhysicalDeviceExternalTensorInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_TENSOR_INFO_ARM;
    const(void)* pNext;
    VkFlags64 flags;
    const(VkTensorDescriptionARM)* pDescription;
    VkExternalMemoryHandleTypeFlagBits handleType;
}

struct VkExternalTensorPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_TENSOR_PROPERTIES_ARM;
    const(void)* pNext;
    VkExternalMemoryProperties externalMemoryProperties;
}

struct VkExternalMemoryTensorCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_TENSOR_CREATE_INFO_ARM;
    const(void)* pNext;
    VkFlags handleTypes;
}

alias PFN_vkCreateTensorARM = VkResult function(
    VkDevice device,
    const(VkTensorCreateInfoARM)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkTensorARM* pTensor,
);

alias PFN_vkDestroyTensorARM = void function(
    VkDevice device,
    VkTensorARM tensor,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkCreateTensorViewARM = VkResult function(
    VkDevice device,
    const(VkTensorViewCreateInfoARM)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    VkTensorViewARM* pView,
);

alias PFN_vkDestroyTensorViewARM = void function(
    VkDevice device,
    VkTensorViewARM tensorView,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkGetTensorMemoryRequirementsARM = void function(
    VkDevice device,
    const(VkTensorMemoryRequirementsInfoARM)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkBindTensorMemoryARM = VkResult function(
    VkDevice device,
    uint bindInfoCount,
    const(VkBindTensorMemoryInfoARM)* pBindInfos,
);

alias PFN_vkGetDeviceTensorMemoryRequirementsARM = void function(
    VkDevice device,
    const(VkDeviceTensorMemoryRequirementsARM)* pInfo,
    VkMemoryRequirements2* pMemoryRequirements,
);

alias PFN_vkCmdCopyTensorARM = void function(
    VkCommandBuffer commandBuffer,
    const(VkCopyTensorInfoARM)* pCopyTensorInfo,
);

alias PFN_vkGetPhysicalDeviceExternalTensorPropertiesARM = void function(
    VkPhysicalDevice physicalDevice,
    const(VkPhysicalDeviceExternalTensorInfoARM)* pExternalTensorInfo,
    VkExternalTensorPropertiesARM* pExternalTensorProperties,
);

public import vulkan.ext.descriptor_buffer;

struct VkPhysicalDeviceDescriptorBufferTensorFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_TENSOR_FEATURES_ARM;
    void* pNext;
    VkBool32 descriptorBufferTensorDescriptors;
}

struct VkPhysicalDeviceDescriptorBufferTensorPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_TENSOR_PROPERTIES_ARM;
    void* pNext;
    size_t tensorCaptureReplayDescriptorDataSize;
    size_t tensorViewCaptureReplayDescriptorDataSize;
    size_t tensorDescriptorSize;
}

struct VkDescriptorGetTensorInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_GET_TENSOR_INFO_ARM;
    const(void)* pNext;
    VkTensorViewARM tensorView;
}

struct VkTensorCaptureDescriptorDataInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_CAPTURE_DESCRIPTOR_DATA_INFO_ARM;
    const(void)* pNext;
    VkTensorARM tensor;
}

struct VkTensorViewCaptureDescriptorDataInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_TENSOR_VIEW_CAPTURE_DESCRIPTOR_DATA_INFO_ARM;
    const(void)* pNext;
    VkTensorViewARM tensorView;
}

alias PFN_vkGetTensorOpaqueCaptureDescriptorDataARM = VkResult function(
    VkDevice device,
    const(VkTensorCaptureDescriptorDataInfoARM)* pInfo,
    void* pData,
);

alias PFN_vkGetTensorViewOpaqueCaptureDescriptorDataARM = VkResult function(
    VkDevice device,
    const(VkTensorViewCaptureDescriptorDataInfoARM)* pInfo,
    void* pData,
);

public import vulkan.ext.frame_boundary;

struct VkFrameBoundaryTensorsARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_FRAME_BOUNDARY_TENSORS_ARM;
    const(void)* pNext;
    uint tensorCount;
    const(VkTensorARM)* pTensors;
}
