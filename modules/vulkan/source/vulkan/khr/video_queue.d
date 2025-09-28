/**
    VK_KHR_video_queue
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr.video_queue;
import vulkan.core;

import numem.core.types : OpaqueHandle;

extern (System) @nogc nothrow:

enum uint VK_KHR_VIDEO_QUEUE_SPEC_VERSION = 8;
enum string VK_KHR_VIDEO_QUEUE_EXTENSION_NAME = "VK_KHR_video_queue";

alias VkVideoSessionKHR = OpaqueHandle!("VkVideoSessionKHR");
alias VkVideoSessionParametersKHR = OpaqueHandle!("VkVideoSessionParametersKHR");

alias VkQueryResultStatusKHR = uint;
enum VkQueryResultStatusKHR VK_QUERY_RESULT_STATUS_ERROR_KHR = -1,
    VK_QUERY_RESULT_STATUS_NOT_READY_KHR = 0,
    VK_QUERY_RESULT_STATUS_COMPLETE_KHR = 1,
    VK_QUERY_RESULT_STATUS_INSUFFICIENT_BITSTREAM_BUFFER_RANGE_KHR = -1000299000;

alias VkVideoCodecOperationFlagsKHR = VkFlags;
enum VkVideoCodecOperationFlagsKHR VK_VIDEO_CODEC_OPERATION_NONE_KHR = 0,
    VK_VIDEO_CODEC_OPERATION_ENCODE_H264_BIT_KHR = 0x00010000,
    VK_VIDEO_CODEC_OPERATION_ENCODE_H265_BIT_KHR = 0x00020000,
    VK_VIDEO_CODEC_OPERATION_DECODE_H264_BIT_KHR = 0x00000001,
    VK_VIDEO_CODEC_OPERATION_DECODE_H265_BIT_KHR = 0x00000002,
    VK_VIDEO_CODEC_OPERATION_DECODE_AV1_BIT_KHR = 0x00000004,
    VK_VIDEO_CODEC_OPERATION_ENCODE_AV1_BIT_KHR = 0x00040000,
    VK_VIDEO_CODEC_OPERATION_DECODE_VP9_BIT_KHR = 0x00000008;

alias VkVideoChromaSubsamplingFlagsKHR = VkFlags;
enum VkVideoChromaSubsamplingFlagsKHR VK_VIDEO_CHROMA_SUBSAMPLING_INVALID_KHR = 0,
    VK_VIDEO_CHROMA_SUBSAMPLING_MONOCHROME_BIT_KHR = 0x00000001,
    VK_VIDEO_CHROMA_SUBSAMPLING_420_BIT_KHR = 0x00000002,
    VK_VIDEO_CHROMA_SUBSAMPLING_422_BIT_KHR = 0x00000004,
    VK_VIDEO_CHROMA_SUBSAMPLING_444_BIT_KHR = 0x00000008;

alias VkVideoComponentBitDepthFlagsKHR = VkFlags;
enum VkVideoComponentBitDepthFlagsKHR VK_VIDEO_COMPONENT_BIT_DEPTH_INVALID_KHR = 0,
    VK_VIDEO_COMPONENT_BIT_DEPTH_8_BIT_KHR = 0x00000001,
    VK_VIDEO_COMPONENT_BIT_DEPTH_10_BIT_KHR = 0x00000004,
    VK_VIDEO_COMPONENT_BIT_DEPTH_12_BIT_KHR = 0x00000010;

alias VkVideoCapabilityFlagsKHR = VkFlags;
enum VkVideoCapabilityFlagsKHR VK_VIDEO_CAPABILITY_PROTECTED_CONTENT_BIT_KHR = 0x00000001,
    VK_VIDEO_CAPABILITY_SEPARATE_REFERENCE_IMAGES_BIT_KHR = 0x00000002;

alias VkVideoSessionCreateFlagsKHR = VkFlags;
enum VkVideoSessionCreateFlagsKHR VK_VIDEO_SESSION_CREATE_PROTECTED_CONTENT_BIT_KHR = 0x00000001,
    VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_PARAMETER_OPTIMIZATIONS_BIT_KHR = 0x00000002,
    VK_VIDEO_SESSION_CREATE_INLINE_QUERIES_BIT_KHR = 0x00000004,
    VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_QUANTIZATION_DELTA_MAP_BIT_KHR = 0x00000008,
    VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_EMPHASIS_MAP_BIT_KHR = 0x00000010,
    VK_VIDEO_SESSION_CREATE_INLINE_SESSION_PARAMETERS_BIT_KHR = 0x00000020;

alias VkVideoEndCodingFlagsKHR = VkFlags;
alias VkVideoBeginCodingFlagsKHR = VkFlags;
alias VkVideoSessionParametersCreateFlagsKHR = VkFlags;
enum VkVideoSessionParametersCreateFlagsKHR VK_VIDEO_SESSION_PARAMETERS_CREATE_QUANTIZATION_MAP_COMPATIBLE_BIT_KHR = 0x00000001;

alias VkVideoCodingControlFlagsKHR = VkFlags;
enum VkVideoCodingControlFlagsKHR VK_VIDEO_CODING_CONTROL_RESET_BIT_KHR = 0x00000001,
    VK_VIDEO_CODING_CONTROL_ENCODE_RATE_CONTROL_BIT_KHR = 0x00000002,
    VK_VIDEO_CODING_CONTROL_ENCODE_QUALITY_LEVEL_BIT_KHR = 0x00000004;

struct VkQueueFamilyQueryResultStatusPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_QUERY_RESULT_STATUS_PROPERTIES_KHR;
    void* pNext;
    VkBool32 queryResultStatusSupport;
}

struct VkQueueFamilyVideoPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_QUEUE_FAMILY_VIDEO_PROPERTIES_KHR;
    void* pNext;
    VkVideoCodecOperationFlagsKHR videoCodecOperations;
}

struct VkVideoProfileInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_PROFILE_INFO_KHR;
    const(void)* pNext;
    VkVideoCodecOperationFlagsKHR videoCodecOperation;
    VkVideoChromaSubsamplingFlagsKHR chromaSubsampling;
    VkVideoComponentBitDepthFlagsKHR lumaBitDepth;
    VkVideoComponentBitDepthFlagsKHR chromaBitDepth;
}

struct VkVideoProfileListInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_PROFILE_LIST_INFO_KHR;
    const(void)* pNext;
    uint profileCount;
    const(VkVideoProfileInfoKHR)* pProfiles;
}

struct VkVideoCapabilitiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_CAPABILITIES_KHR;
    void* pNext;
    VkVideoCapabilityFlagsKHR flags;
    VkDeviceSize minBitstreamBufferOffsetAlignment;
    VkDeviceSize minBitstreamBufferSizeAlignment;
    VkExtent2D pictureAccessGranularity;
    VkExtent2D minCodedExtent;
    VkExtent2D maxCodedExtent;
    uint maxDpbSlots;
    uint maxActiveReferencePictures;
    VkExtensionProperties stdHeaderVersion;
}

struct VkPhysicalDeviceVideoFormatInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_FORMAT_INFO_KHR;
    const(void)* pNext;
    VkImageUsageFlags imageUsage;
}

struct VkVideoFormatPropertiesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_FORMAT_PROPERTIES_KHR;
    void* pNext;
    VkFormat format;
    VkComponentMapping componentMapping;
    VkImageCreateFlags imageCreateFlags;
    VkImageType imageType;
    VkImageTiling imageTiling;
    VkImageUsageFlags imageUsageFlags;
}

struct VkVideoPictureResourceInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_PICTURE_RESOURCE_INFO_KHR;
    const(void)* pNext;
    VkOffset2D codedOffset;
    VkExtent2D codedExtent;
    uint baseArrayLayer;
    VkImageView imageViewBinding;
}

struct VkVideoReferenceSlotInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_REFERENCE_SLOT_INFO_KHR;
    const(void)* pNext;
    int slotIndex;
    const(VkVideoPictureResourceInfoKHR)* pPictureResource;
}

struct VkVideoSessionMemoryRequirementsKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_MEMORY_REQUIREMENTS_KHR;
    void* pNext;
    uint memoryBindIndex;
    VkMemoryRequirements memoryRequirements;
}

struct VkBindVideoSessionMemoryInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_BIND_VIDEO_SESSION_MEMORY_INFO_KHR;
    const(void)* pNext;
    uint memoryBindIndex;
    VkDeviceMemory memory;
    VkDeviceSize memoryOffset;
    VkDeviceSize memorySize;
}

struct VkVideoSessionCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_CREATE_INFO_KHR;
    const(void)* pNext;
    uint queueFamilyIndex;
    VkVideoSessionCreateFlagsKHR flags;
    const(VkVideoProfileInfoKHR)* pVideoProfile;
    VkFormat pictureFormat;
    VkExtent2D maxCodedExtent;
    VkFormat referencePictureFormat;
    uint maxDpbSlots;
    uint maxActiveReferencePictures;
    const(VkExtensionProperties)* pStdHeaderVersion;
}

struct VkVideoSessionParametersCreateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_CREATE_INFO_KHR;
    const(void)* pNext;
    VkVideoSessionParametersCreateFlagsKHR flags;
    VkVideoSessionParametersKHR videoSessionParametersTemplate;
    VkVideoSessionKHR videoSession;
}

struct VkVideoSessionParametersUpdateInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_UPDATE_INFO_KHR;
    const(void)* pNext;
    uint updateSequenceCount;
}

struct VkVideoBeginCodingInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_BEGIN_CODING_INFO_KHR;
    const(void)* pNext;
    VkVideoBeginCodingFlagsKHR flags;
    VkVideoSessionKHR videoSession;
    VkVideoSessionParametersKHR videoSessionParameters;
    uint referenceSlotCount;
    const(VkVideoReferenceSlotInfoKHR)* pReferenceSlots;
}

struct VkVideoEndCodingInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_END_CODING_INFO_KHR;
    const(void)* pNext;
    VkVideoEndCodingFlagsKHR flags;
}

struct VkVideoCodingControlInfoKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_VIDEO_CODING_CONTROL_INFO_KHR;
    const(void)* pNext;
    VkVideoCodingControlFlagsKHR flags;
}

alias PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR = VkResult function(VkPhysicalDevice physicalDevice, const(
        VkVideoProfileInfoKHR)* pVideoProfile, VkVideoCapabilitiesKHR* pCapabilities);
alias PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR = VkResult function(
    VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceVideoFormatInfoKHR)* pVideoFormatInfo, uint* pVideoFormatPropertyCount, VkVideoFormatPropertiesKHR* pVideoFormatProperties);
alias PFN_vkCreateVideoSessionKHR = VkResult function(VkDevice device, const(VkVideoSessionCreateInfoKHR)* pCreateInfo, const(
        VkAllocationCallbacks)* pAllocator, VkVideoSessionKHR* pVideoSession);
alias PFN_vkDestroyVideoSessionKHR = void function(VkDevice device, VkVideoSessionKHR videoSession, const(
        VkAllocationCallbacks)* pAllocator);
alias PFN_vkGetVideoSessionMemoryRequirementsKHR = VkResult function(VkDevice device, VkVideoSessionKHR videoSession, uint* pMemoryRequirementsCount, VkVideoSessionMemoryRequirementsKHR* pMemoryRequirements);
alias PFN_vkBindVideoSessionMemoryKHR = VkResult function(VkDevice device, VkVideoSessionKHR videoSession, uint bindSessionMemoryInfoCount, const(
        VkBindVideoSessionMemoryInfoKHR)* pBindSessionMemoryInfos);
alias PFN_vkCreateVideoSessionParametersKHR = VkResult function(VkDevice device, const(VkVideoSessionParametersCreateInfoKHR)* pCreateInfo, const(
        VkAllocationCallbacks)* pAllocator, VkVideoSessionParametersKHR* pVideoSessionParameters);
alias PFN_vkUpdateVideoSessionParametersKHR = VkResult function(VkDevice device, VkVideoSessionParametersKHR videoSessionParameters, const(
        VkVideoSessionParametersUpdateInfoKHR)* pUpdateInfo);
alias PFN_vkDestroyVideoSessionParametersKHR = void function(VkDevice device, VkVideoSessionParametersKHR videoSessionParameters, const(
        VkAllocationCallbacks)* pAllocator);
alias PFN_vkCmdBeginVideoCodingKHR = void function(VkCommandBuffer commandBuffer, const(
        VkVideoBeginCodingInfoKHR)* pBeginInfo);
alias PFN_vkCmdEndVideoCodingKHR = void function(VkCommandBuffer commandBuffer, const(
        VkVideoEndCodingInfoKHR)* pEndCodingInfo);
alias PFN_vkCmdControlVideoCodingKHR = void function(VkCommandBuffer commandBuffer, const(
        VkVideoCodingControlInfoKHR)* pCodingControlInfo);
