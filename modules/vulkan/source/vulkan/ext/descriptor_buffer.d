/**
 * VK_EXT_descriptor_buffer (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.descriptor_buffer;

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
    version (VK_VERSION_1_2) {} else {
        public import vulkan.ext.descriptor_indexing;
        public import vulkan.khr.buffer_device_address;
        version (VK_VERSION_1_1) {} else {
            public import vulkan.khr.get_physical_device_properties2;
        }
    }
}

struct VK_EXT_descriptor_buffer {
    
    @VkProcName("vkGetDescriptorSetLayoutSizeEXT")
    PFN_vkGetDescriptorSetLayoutSizeEXT vkGetDescriptorSetLayoutSizeEXT;
    
    @VkProcName("vkGetDescriptorSetLayoutBindingOffsetEXT")
    PFN_vkGetDescriptorSetLayoutBindingOffsetEXT vkGetDescriptorSetLayoutBindingOffsetEXT;
    
    @VkProcName("vkGetDescriptorEXT")
    PFN_vkGetDescriptorEXT vkGetDescriptorEXT;
    
    @VkProcName("vkCmdBindDescriptorBuffersEXT")
    PFN_vkCmdBindDescriptorBuffersEXT vkCmdBindDescriptorBuffersEXT;
    
    @VkProcName("vkCmdSetDescriptorBufferOffsetsEXT")
    PFN_vkCmdSetDescriptorBufferOffsetsEXT vkCmdSetDescriptorBufferOffsetsEXT;
    
    @VkProcName("vkCmdBindDescriptorBufferEmbeddedSamplersEXT")
    PFN_vkCmdBindDescriptorBufferEmbeddedSamplersEXT vkCmdBindDescriptorBufferEmbeddedSamplersEXT;
    
    @VkProcName("vkGetBufferOpaqueCaptureDescriptorDataEXT")
    PFN_vkGetBufferOpaqueCaptureDescriptorDataEXT vkGetBufferOpaqueCaptureDescriptorDataEXT;
    
    @VkProcName("vkGetImageOpaqueCaptureDescriptorDataEXT")
    PFN_vkGetImageOpaqueCaptureDescriptorDataEXT vkGetImageOpaqueCaptureDescriptorDataEXT;
    
    @VkProcName("vkGetImageViewOpaqueCaptureDescriptorDataEXT")
    PFN_vkGetImageViewOpaqueCaptureDescriptorDataEXT vkGetImageViewOpaqueCaptureDescriptorDataEXT;
    
    @VkProcName("vkGetSamplerOpaqueCaptureDescriptorDataEXT")
    PFN_vkGetSamplerOpaqueCaptureDescriptorDataEXT vkGetSamplerOpaqueCaptureDescriptorDataEXT;
    @VkProcName("vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT")
    PFN_vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT;
}

enum VK_EXT_DESCRIPTOR_BUFFER_SPEC_VERSION = 1;
enum VK_EXT_DESCRIPTOR_BUFFER_EXTENSION_NAME = "VK_EXT_descriptor_buffer";

struct VkPhysicalDeviceDescriptorBufferPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_PROPERTIES_EXT;
    void* pNext;
    VkBool32 combinedImageSamplerDescriptorSingleArray;
    VkBool32 bufferlessPushDescriptors;
    VkBool32 allowSamplerImageViewPostSubmitCreation;
    VkDeviceSize descriptorBufferOffsetAlignment;
    uint maxDescriptorBufferBindings;
    uint maxResourceDescriptorBufferBindings;
    uint maxSamplerDescriptorBufferBindings;
    uint maxEmbeddedImmutableSamplerBindings;
    uint maxEmbeddedImmutableSamplers;
    size_t bufferCaptureReplayDescriptorDataSize;
    size_t imageCaptureReplayDescriptorDataSize;
    size_t imageViewCaptureReplayDescriptorDataSize;
    size_t samplerCaptureReplayDescriptorDataSize;
    size_t accelerationStructureCaptureReplayDescriptorDataSize;
    size_t samplerDescriptorSize;
    size_t combinedImageSamplerDescriptorSize;
    size_t sampledImageDescriptorSize;
    size_t storageImageDescriptorSize;
    size_t uniformTexelBufferDescriptorSize;
    size_t robustUniformTexelBufferDescriptorSize;
    size_t storageTexelBufferDescriptorSize;
    size_t robustStorageTexelBufferDescriptorSize;
    size_t uniformBufferDescriptorSize;
    size_t robustUniformBufferDescriptorSize;
    size_t storageBufferDescriptorSize;
    size_t robustStorageBufferDescriptorSize;
    size_t inputAttachmentDescriptorSize;
    size_t accelerationStructureDescriptorSize;
    VkDeviceSize maxSamplerDescriptorBufferRange;
    VkDeviceSize maxResourceDescriptorBufferRange;
    VkDeviceSize samplerDescriptorBufferAddressSpaceSize;
    VkDeviceSize resourceDescriptorBufferAddressSpaceSize;
    VkDeviceSize descriptorBufferAddressSpaceSize;
}

struct VkPhysicalDeviceDescriptorBufferDensityMapPropertiesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_DENSITY_MAP_PROPERTIES_EXT;
    void* pNext;
    size_t combinedImageSamplerDensityMapDescriptorSize;
}

struct VkPhysicalDeviceDescriptorBufferFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_FEATURES_EXT;
    void* pNext;
    VkBool32 descriptorBuffer;
    VkBool32 descriptorBufferCaptureReplay;
    VkBool32 descriptorBufferImageLayoutIgnored;
    VkBool32 descriptorBufferPushDescriptors;
}

struct VkDescriptorAddressInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_ADDRESS_INFO_EXT;
    void* pNext;
    VkDeviceAddress address;
    VkDeviceSize range;
    VkFormat format;
}

struct VkDescriptorBufferBindingInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_BUFFER_BINDING_INFO_EXT;
    const(void)* pNext;
    VkDeviceAddress address;
    VkFlags usage;
}

struct VkDescriptorBufferBindingPushDescriptorBufferHandleEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_BUFFER_BINDING_PUSH_DESCRIPTOR_BUFFER_HANDLE_EXT;
    const(void)* pNext;
    VkBuffer buffer;
}

union VkDescriptorDataEXT {
    const(VkSampler)* pSampler;
    const(VkDescriptorImageInfo)* pCombinedImageSampler;
    const(VkDescriptorImageInfo)* pInputAttachmentImage;
    const(VkDescriptorImageInfo)* pSampledImage;
    const(VkDescriptorImageInfo)* pStorageImage;
    const(VkDescriptorAddressInfoEXT)* pUniformTexelBuffer;
    const(VkDescriptorAddressInfoEXT)* pStorageTexelBuffer;
    const(VkDescriptorAddressInfoEXT)* pUniformBuffer;
    const(VkDescriptorAddressInfoEXT)* pStorageBuffer;
    VkDeviceAddress accelerationStructure;
}

struct VkDescriptorGetInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DESCRIPTOR_GET_INFO_EXT;
    const(void)* pNext;
    VkDescriptorType type;
    VkDescriptorDataEXT data;
}

struct VkBufferCaptureDescriptorDataInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_BUFFER_CAPTURE_DESCRIPTOR_DATA_INFO_EXT;
    const(void)* pNext;
    VkBuffer buffer;
}

struct VkImageCaptureDescriptorDataInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_CAPTURE_DESCRIPTOR_DATA_INFO_EXT;
    const(void)* pNext;
    VkImage image;
}

struct VkImageViewCaptureDescriptorDataInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CAPTURE_DESCRIPTOR_DATA_INFO_EXT;
    const(void)* pNext;
    VkImageView imageView;
}

struct VkSamplerCaptureDescriptorDataInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_SAMPLER_CAPTURE_DESCRIPTOR_DATA_INFO_EXT;
    const(void)* pNext;
    VkSampler sampler;
}

struct VkOpaqueCaptureDescriptorDataCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_OPAQUE_CAPTURE_DESCRIPTOR_DATA_CREATE_INFO_EXT;
    const(void)* pNext;
    const(void)* opaqueCaptureDescriptorData;
}

alias PFN_vkGetDescriptorSetLayoutSizeEXT = void function(
    VkDevice device,
    VkDescriptorSetLayout layout,
    VkDeviceSize* pLayoutSizeInBytes,
);

alias PFN_vkGetDescriptorSetLayoutBindingOffsetEXT = void function(
    VkDevice device,
    VkDescriptorSetLayout layout,
    uint binding,
    VkDeviceSize* pOffset,
);

alias PFN_vkGetDescriptorEXT = void function(
    VkDevice device,
    const(VkDescriptorGetInfoEXT)* pDescriptorInfo,
    size_t dataSize,
    void* pDescriptor,
);

alias PFN_vkCmdBindDescriptorBuffersEXT = void function(
    VkCommandBuffer commandBuffer,
    uint bufferCount,
    const(VkDescriptorBufferBindingInfoEXT)* pBindingInfos,
);

alias PFN_vkCmdSetDescriptorBufferOffsetsEXT = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineBindPoint pipelineBindPoint,
    VkPipelineLayout layout,
    uint firstSet,
    uint setCount,
    const(uint)* pBufferIndices,
    const(VkDeviceSize)* pOffsets,
);

alias PFN_vkCmdBindDescriptorBufferEmbeddedSamplersEXT = void function(
    VkCommandBuffer commandBuffer,
    VkPipelineBindPoint pipelineBindPoint,
    VkPipelineLayout layout,
    uint set,
);

alias PFN_vkGetBufferOpaqueCaptureDescriptorDataEXT = VkResult function(
    VkDevice device,
    const(VkBufferCaptureDescriptorDataInfoEXT)* pInfo,
    void* pData,
);

alias PFN_vkGetImageOpaqueCaptureDescriptorDataEXT = VkResult function(
    VkDevice device,
    const(VkImageCaptureDescriptorDataInfoEXT)* pInfo,
    void* pData,
);

alias PFN_vkGetImageViewOpaqueCaptureDescriptorDataEXT = VkResult function(
    VkDevice device,
    const(VkImageViewCaptureDescriptorDataInfoEXT)* pInfo,
    void* pData,
);

alias PFN_vkGetSamplerOpaqueCaptureDescriptorDataEXT = VkResult function(
    VkDevice device,
    const(VkSamplerCaptureDescriptorDataInfoEXT)* pInfo,
    void* pData,
);

public import vulkan.khr.acceleration_structure;
public import vulkan.nv.ray_tracing;

struct VkAccelerationStructureCaptureDescriptorDataInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CAPTURE_DESCRIPTOR_DATA_INFO_EXT;
    const(void)* pNext;
    VkAccelerationStructureKHR accelerationStructure;
    VkAccelerationStructureNV accelerationStructureNV;
}

alias PFN_vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT = VkResult function(
    VkDevice device,
    const(VkAccelerationStructureCaptureDescriptorDataInfoEXT)* pInfo,
    void* pData,
);
