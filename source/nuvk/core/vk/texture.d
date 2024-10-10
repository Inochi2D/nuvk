/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.texture;
import nuvk.core.vk;
import nuvk.core;

import numem.all;
import inmath;

/**
    Converts a vulkan image format to a nuvk texture format 
*/
NuvkTextureFormat toNuvkTextureFormat(VkFormat format) @nogc {
    switch(format) {
        default:
            return NuvkTextureFormat.undefined;
            
        case VK_FORMAT_UNDEFINED:
            return NuvkTextureFormat.undefined;

        case VK_FORMAT_R8_UNORM:
            return NuvkTextureFormat.a8Unorm;

        case VK_FORMAT_R8_SRGB:
            return NuvkTextureFormat.a8UnormSRGB;

        case VK_FORMAT_R8G8_UNORM:
            return NuvkTextureFormat.rg8Unorm;

        case VK_FORMAT_R8G8_SRGB:
            return NuvkTextureFormat.rg8UnormSRGB;

        case VK_FORMAT_R8G8B8A8_UNORM:
            return NuvkTextureFormat.rgba8Unorm;

        case VK_FORMAT_R8G8B8A8_SRGB:
            return NuvkTextureFormat.rgba8UnormSRGB;

        case VK_FORMAT_B8G8R8A8_UNORM:
            return NuvkTextureFormat.bgra8Unorm;

        case VK_FORMAT_B8G8R8A8_SRGB:
            return NuvkTextureFormat.bgra8UnormSRGB;

        case VK_FORMAT_R32G32B32A32_SFLOAT:
            return NuvkTextureFormat.rgba32Float;

        case VK_FORMAT_D24_UNORM_S8_UINT:
            return NuvkTextureFormat.depthStencil;
    }
}

/**
    Converts a nuvk texture format to a vulkan image format
*/
VkFormat toVkImageFormat(NuvkTextureFormat format) @nogc {
    final switch(format) {
        case NuvkTextureFormat.undefined:
            return VK_FORMAT_UNDEFINED;

        case NuvkTextureFormat.a8Unorm:
            return VK_FORMAT_R8_UNORM;

        case NuvkTextureFormat.a8UnormSRGB:
            return VK_FORMAT_R8_SRGB;

        case NuvkTextureFormat.rg8Unorm:
            return VK_FORMAT_R8G8_UNORM;

        case NuvkTextureFormat.rg8UnormSRGB:
            return VK_FORMAT_R8G8_SRGB;

        case NuvkTextureFormat.rgba8Unorm:
            return VK_FORMAT_R8G8B8A8_UNORM;

        case NuvkTextureFormat.rgba8UnormSRGB:
            return VK_FORMAT_R8G8B8A8_SRGB;

        case NuvkTextureFormat.bgra8Unorm:
            return VK_FORMAT_B8G8R8A8_UNORM;

        case NuvkTextureFormat.bgra8UnormSRGB:
            return VK_FORMAT_B8G8R8A8_SRGB;

        case NuvkTextureFormat.rgba32Float:
            return VK_FORMAT_R32G32B32A32_SFLOAT;

        case NuvkTextureFormat.depthStencil:
            return VK_FORMAT_D24_UNORM_S8_UINT;
    }
}

/**
    Converts a nuvk texture type to a vulkan image type
*/
VkImageType toVkImageType(NuvkTextureType type) @nogc {
    final switch(type) {
        
        case NuvkTextureType.texture1d:
            return VK_IMAGE_TYPE_1D;
        
        case NuvkTextureType.texture2d:
        case NuvkTextureType.texture2dMultisampled:
            return VK_IMAGE_TYPE_2D;
        
        case NuvkTextureType.texture3d:
            return VK_IMAGE_TYPE_3D;
    }
}

/**
    Converts a nuvk texture type to a vulkan image view type
*/
VkImageViewType toVkImageViewType(NuvkTextureType type) @nogc {
    final switch(type) {
        
        case NuvkTextureType.texture1d:
            return VK_IMAGE_VIEW_TYPE_1D;
        
        case NuvkTextureType.texture2d:
        case NuvkTextureType.texture2dMultisampled:
            return VK_IMAGE_VIEW_TYPE_2D;
        
        case NuvkTextureType.texture3d:
            return VK_IMAGE_VIEW_TYPE_3D;
    }
}

/**
    Converts a nuvk texture tiling flag to a vulkan image tiling flag
*/
VkImageTiling toVkImageTiling(NuvkTextureTiling tiling) @nogc {
    final switch(tiling) {
        case NuvkTextureTiling.linear:
            return VK_IMAGE_TILING_LINEAR; 
        case NuvkTextureTiling.optimal:
            return VK_IMAGE_TILING_OPTIMAL; 
    }
}

/**
    Gets the correct sample count flag for the type
*/
VkSampleCountFlagBits toVkSampleCount(NuvkTextureType type, int samples) @nogc {

    // Only multisampled Texture2Ds can be multisampled
    if (type != NuvkTextureType.texture2dMultisampled) 
        return VK_SAMPLE_COUNT_1_BIT;
    
    // Sample counts
    switch(samples) {
        default: 
            return VK_SAMPLE_COUNT_1_BIT;
        
        case 2:
            return VK_SAMPLE_COUNT_2_BIT;
        
        case 4:
            return VK_SAMPLE_COUNT_4_BIT;
        
        case 8:
            return VK_SAMPLE_COUNT_8_BIT;
        
        case 16:
            return VK_SAMPLE_COUNT_8_BIT;
    }
}

/**
    Converts a texture format into its vulkan aspect
*/
VkImageAspectFlagBits toVkAspectFlags(NuvkTextureFormat format) @nogc {
    if (format == NuvkTextureFormat.depthStencil)
        return VK_IMAGE_ASPECT_DEPTH_BIT | VK_IMAGE_ASPECT_STENCIL_BIT;
    return VK_IMAGE_ASPECT_COLOR_BIT;
}

/**
    Converts a sampler addressing mode into its vulkan counterpart
*/
VkSamplerAddressMode toVkAddressMode(NuvkSamplerAddressMode addressMode) @nogc {
    final switch(addressMode) {
        case NuvkSamplerAddressMode.clampToEdge:
            return VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;

        case NuvkSamplerAddressMode.mirrorClampToEdge:
            return VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE;
        
        case NuvkSamplerAddressMode.repeat:
            return VK_SAMPLER_ADDRESS_MODE_REPEAT;

        case NuvkSamplerAddressMode.mirrorRepeat:
            return VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT;

        case NuvkSamplerAddressMode.clampToBorderColor:
            return VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER;
    }
}

/**
    Converts a filter into its vulkan filter
*/
VkFilter toVkFilter(NuvkSamplerTextureFilter filter) @nogc {
    final switch(filter) {
        case NuvkSamplerTextureFilter.linear:
            return VK_FILTER_LINEAR;
        case NuvkSamplerTextureFilter.nearest:
            return VK_FILTER_NEAREST;
    }
}

/**
    Converts a filter into its vulkan filter
*/
VkSamplerMipmapMode toVkMimpmapMode(NuvkSamplerMipmapFilter filter) @nogc {
    final switch(filter) {
        case NuvkSamplerMipmapFilter.nearest:
        case NuvkSamplerMipmapFilter.notMipmapped:
            return VK_SAMPLER_MIPMAP_MODE_NEAREST;
        case NuvkSamplerMipmapFilter.linear:
            return VK_SAMPLER_MIPMAP_MODE_LINEAR;
    }
}

VkCompareOp toVkCompareOp(NuvkSamplerCompareOp compOp) @nogc {
    final switch(compOp) {

        case NuvkSamplerCompareOp.never:
            return VK_COMPARE_OP_NEVER;

        case NuvkSamplerCompareOp.less:
            return VK_COMPARE_OP_LESS;

        case NuvkSamplerCompareOp.equal:
            return VK_COMPARE_OP_EQUAL;

        case NuvkSamplerCompareOp.lessEqual:
            return VK_COMPARE_OP_LESS_OR_EQUAL;

        case NuvkSamplerCompareOp.greater:
            return VK_COMPARE_OP_GREATER;

        case NuvkSamplerCompareOp.greaterEqual:
            return VK_COMPARE_OP_GREATER_OR_EQUAL;

        case NuvkSamplerCompareOp.notEqual:
            return VK_COMPARE_OP_NOT_EQUAL;

        case NuvkSamplerCompareOp.always:
            return VK_COMPARE_OP_ALWAYS;
    }
}

/**
    Converts a Nuvk texture layout to a vulkan one.
*/
VkImageLayout toVkImageLayout(NuvkTextureLayout layout) @nogc {
    final switch(layout) {
        case NuvkTextureLayout.undefined:
            return VK_IMAGE_LAYOUT_UNDEFINED;

        case NuvkTextureLayout.general:
            return VK_IMAGE_LAYOUT_GENERAL;

        case NuvkTextureLayout.attachment:
            return VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL;

        case NuvkTextureLayout.presentation:
            return VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;

        case NuvkTextureLayout.transferSrc:
            return VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;

        case NuvkTextureLayout.transferDst:
            return VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    }
}

/**
    A texture
*/
class NuvkTextureVk : NuvkTexture {
@nogc:
private:
    bool isUserOwned;
    VkImage image;
    VkDeviceMemory deviceMemory;
    ulong allocatedSize;
    ulong alignment;

    void createTexture(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto deviceInfo = cast(NuvkDeviceVkInfo)this.getOwner().getDeviceInfo();
        auto physicalDevice = cast(VkPhysicalDevice)this.getOwner().getDeviceInfo().getHandle();
        NuvkTextureDescriptor descriptor = this.getDescriptor();
        VkMemoryRequirements memoryRequirements;
        int memoryIndex;
        import core.stdc.stdio : printf;


        VkImageCreateInfo imageCreateInfo;
        VkImageFormatProperties imageProperties;
        
        // Fill out image info
        {
            imageCreateInfo.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
            imageCreateInfo.format = descriptor.format.toVkImageFormat();
            imageCreateInfo.imageType = descriptor.type.toVkImageType();
            imageCreateInfo.tiling = descriptor.tiling.toVkImageTiling();
            imageCreateInfo.samples = descriptor.type.toVkSampleCount(descriptor.samples);
            imageCreateInfo.usage = VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT;
            imageCreateInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
            imageCreateInfo.extent.width = descriptor.extents.width;
            imageCreateInfo.extent.height = descriptor.extents.height;
            imageCreateInfo.extent.depth = descriptor.extents.depth;
            imageCreateInfo.mipLevels = descriptor.mipLevels;
            imageCreateInfo.arrayLayers = descriptor.arrayLayers;
        }
        
        // Get maximums
        {
            nuvkEnforce(
                vkGetPhysicalDeviceImageFormatProperties(physicalDevice, imageCreateInfo.format, imageCreateInfo.imageType, imageCreateInfo.tiling, imageCreateInfo.usage, imageCreateInfo.flags, &imageProperties) == VK_SUCCESS,
                "Texture format not supported!"
            );
        }

        // Create texture
        {
            VkExternalMemoryImageCreateInfo imageExternalInfo;

            // Handle types needs to be specified when sharing here.
            if (processSharing == NuvkProcessSharing.processShared) {
                imageExternalInfo.handleTypes = NuvkVkMemorySharingFlagBit;
                imageCreateInfo.pNext = &imageExternalInfo;
            }

            nuvkEnforce(
                vkCreateImage(device, &imageCreateInfo, null, &image) == VK_SUCCESS,
                "Failed creating Vulkan texture!"
            );
        }

        // Find memory layout
        {
            vkGetImageMemoryRequirements(device, image, &memoryRequirements);

            memoryIndex = deviceInfo.getMatchingMemoryIndex(memoryRequirements.memoryTypeBits, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT);
            nuvkEnforce(
                memoryIndex >= 0, 
                "Failed finding suitable memory for the requested buffer"
            );

            allocatedSize = memoryRequirements.size;
            alignment = memoryRequirements.alignment;
        }

        // Allocate memory
        {
            if (processSharing == NuvkProcessSharing.processShared) {

                VkExportMemoryAllocateInfo exportInfo;
                exportInfo.handleTypes = NuvkVkMemorySharingFlagBit;

                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;
                allocInfo.pNext = &exportInfo;

                nuvkEnforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    "Failed allocating memory for buffer!"
                );

                vkBindImageMemory(device, image, deviceMemory, 0);
                this.setSharedHandle(nuvkGetSharedHandleVk(device, deviceMemory));
            
            } else {

                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;

                nuvkEnforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    "Failed allocating memory for buffer!"
                );

                vkBindImageMemory(device, image, deviceMemory, 0);
            }
        }

        this.setHandle(image);
    }

protected:

    /**
        Override this function to close shared handles.

        Do not call this yourself.
    */
    override
    void onShareHandleClose(ulong handle) {
        nuvkCloseSharedHandleVk(handle);
    }

public:
    /**
        Destructor
    */
    ~this() {
        if (isUserOwned) {
            auto device = cast(VkDevice)this.getOwner().getHandle();
            
            if (image != VK_NULL_HANDLE)
                vkDestroyImage(device, image, null);

            if (deviceMemory != VK_NULL_HANDLE)
                vkFreeMemory(device, deviceMemory, null);
        }
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureDescriptor descriptor, NuvkProcessSharing processSharing) {
        super(device, descriptor, processSharing);
        this.isUserOwned = true;
        this.createTexture(processSharing);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureFormat format, NuvkProcessSharing processSharing) {
        super(device, format, processSharing);
        this.isUserOwned = true;
        this.createTexture(processSharing);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, VkImage image, VkFormat format, vec2u size) {

        // Descriptor
        NuvkTextureDescriptor descriptor;
        descriptor.format = format.toNuvkTextureFormat();
        descriptor.extents.width = size.x;
        descriptor.extents.height = size.y;

        super(device, descriptor, NuvkProcessSharing.processLocal);

        this.isUserOwned = false;
        this.image = image;
        this.setHandle(this.image);
    }

    /**
        Creates a texture view
    */
    override
    NuvkTextureView createTextureView(NuvkTextureViewDescriptor descriptor) {
        return nogc_new!NuvkTextureVkView(this.getOwner(), this, descriptor);
    }

    /**
        Gets the allocated size on the GPU, in bytes.
    */
    override
    ulong getAllocatedSize() {
        return allocatedSize;
    }

    /**
        Gets the allocated size on the GPU, in bytes.
    */
    override
    ulong getAlignment() {
        return alignment;
    }

    /**
        Sets the reported layout of the texture based on vulkan layout.

        This should not be called by the end user, as this does NOT
        do layout transitions by itself.
    */
    final
    void setLayoutFromVk(VkImageLayout layout) {
        switch(layout) {
            default:
                this.setTextureLayout(NuvkTextureLayout.undefined);
                return;

            case VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL:
            case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL:
                this.setTextureLayout(NuvkTextureLayout.attachment);
                return;
                
            case VK_IMAGE_LAYOUT_GENERAL:
                this.setTextureLayout(NuvkTextureLayout.general);
                return;

            case VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL:
                this.setTextureLayout(NuvkTextureLayout.transferSrc);
                return;

            case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL:
                this.setTextureLayout(NuvkTextureLayout.transferDst);
                return;

            case VK_IMAGE_LAYOUT_PRESENT_SRC_KHR:
                this.setTextureLayout(NuvkTextureLayout.presentation);
                return;
        }
    }
}

/**
    A texture view.

    Texture views are used to reinterpret the data stored in a NuvkTexture
*/
class NuvkTextureVkView : NuvkTextureView {
@nogc:
private:
    VkImageView imageView;

    void createTextureView(NuvkTexture texture) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        NuvkTextureViewDescriptor descriptor = this.getDescriptor();

        VkImageViewCreateInfo imageViewCreateInfo;
        imageViewCreateInfo.image = cast(VkImage)texture.getHandle();
        imageViewCreateInfo.viewType = descriptor.type.toVkImageViewType();
        imageViewCreateInfo.format = descriptor.format.toVkImageFormat();
        
        // Aspect
        imageViewCreateInfo.subresourceRange.aspectMask = 
            descriptor.format.toVkAspectFlags();

        // Mip levels
        imageViewCreateInfo.subresourceRange.baseMipLevel = 
            descriptor.mipLevels.start;
        imageViewCreateInfo.subresourceRange.levelCount = 
            descriptor.mipLevels.getLength();
        
        // Array slices
        imageViewCreateInfo.subresourceRange.baseArrayLayer = 
            descriptor.arraySlices.start;
        imageViewCreateInfo.subresourceRange.layerCount = 
            descriptor.arraySlices.getLength();

        nuvkEnforce(
            vkCreateImageView(device, &imageViewCreateInfo, null, &imageView) == VK_SUCCESS,
            "Failed to create Vulkan image view!"
        );

        this.setHandle(imageView);
    }

public:
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        
        if (imageView != VK_NULL_HANDLE)
            vkDestroyImageView(device, imageView, null);
    }
    
    this(NuvkDevice device, NuvkTexture texture, NuvkTextureViewDescriptor descriptor) {
        super(device, texture, descriptor);
        this.createTextureView(texture);
    }
}

/**
    A texture view.

    Texture views are used to reinterpret the data stored in a NuvkTexture
*/
class NuvkVkSampler : NuvkSampler {
@nogc:
private:
    VkSampler sampler;

    void createSampler() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        NuvkSamplerDescriptor samplerDescriptor = this.getDescriptor();

        VkSamplerCreateInfo samplerCreateInfo;

        // Custom border color
        VkSamplerCustomBorderColorCreateInfoEXT customBorderColor;
        customBorderColor.format = VK_FORMAT_UNDEFINED;
        customBorderColor.customBorderColor.float32 = samplerDescriptor.borderColor.colorData;
        samplerCreateInfo.pNext = &customBorderColor;

        // Sampler create info
        samplerCreateInfo.addressModeU = samplerDescriptor.addressModeU.toVkAddressMode();
        samplerCreateInfo.addressModeV = samplerDescriptor.addressModeV.toVkAddressMode();
        samplerCreateInfo.addressModeW = samplerDescriptor.addressModeW.toVkAddressMode();
        samplerCreateInfo.anisotropyEnable = samplerDescriptor.maxAnisotropy > 0 ? VK_TRUE : VK_FALSE;
        samplerCreateInfo.maxAnisotropy = samplerDescriptor.maxAnisotropy;
        samplerCreateInfo.borderColor = VK_BORDER_COLOR_FLOAT_CUSTOM_EXT;

        if (samplerDescriptor.mipFilter == NuvkSamplerMipmapFilter.notMipmapped) {
            samplerCreateInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_NEAREST;

            samplerCreateInfo.minFilter = samplerDescriptor.minFilter.toVkFilter();
            samplerCreateInfo.magFilter = samplerDescriptor.magFilter.toVkFilter();
            samplerCreateInfo.minLod = 0;
            samplerCreateInfo.maxLod = 0.25;
        } else {
            samplerCreateInfo.minFilter = samplerDescriptor.minFilter.toVkFilter();
            samplerCreateInfo.magFilter = samplerDescriptor.magFilter.toVkFilter();
            samplerCreateInfo.mipmapMode = samplerDescriptor.mipFilter.toVkMimpmapMode();
            samplerCreateInfo.minLod = samplerDescriptor.lodClamp.start;
            samplerCreateInfo.maxLod = samplerDescriptor.lodClamp.end;
        }

        samplerCreateInfo.unnormalizedCoordinates = samplerDescriptor.normalizeCoordinates ? VK_FALSE : VK_TRUE;
        samplerCreateInfo.compareEnable = VK_TRUE;
        samplerCreateInfo.compareOp = samplerDescriptor.compareOp.toVkCompareOp();
        
        nuvkEnforce(
            vkCreateSampler(device, &samplerCreateInfo, null, &sampler) == VK_SUCCESS,
            "Failed creating sampler"
        );
    }

public:
    ~this() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        if (sampler != VK_NULL_HANDLE)
            vkDestroySampler(device, sampler, null);
    }

    this(NuvkDevice device, NuvkSamplerDescriptor descriptor) {
        super(device, descriptor);
        this.createSampler();
    }
}