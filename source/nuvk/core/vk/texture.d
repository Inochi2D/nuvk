module nuvk.core.vk.texture;
import nuvk.core.vk;
import nuvk.core;

import numem.all;

/**
    Converts a nuvk texture format to a vulkan image format
*/
VkFormat toVkImageFormat(NuvkTextureFormat format) @nogc {
    final switch(format) {

        case NuvkTextureFormat.a8Unorm:
            return VK_FORMAT_R8_UNORM;

        case NuvkTextureFormat.a8UnormSRGB:
            return VK_FORMAT_R8_SRGB;

        case NuvkTextureFormat.rg8Unorm:
            return VK_FORMAT_R8G8_UNORM;

        case NuvkTextureFormat.rg8UnormSRGB:
            return VK_FORMAT_R8G8_SRGB;

        case NuvkTextureFormat.rgba8Unorm:
            return VK_FORMAT_R8G8B8_UNORM;

        case NuvkTextureFormat.rgba8UnormSRGB:
            return VK_FORMAT_R8G8B8_SRGB;

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
    A texture
*/
class NuvkVkTexture : NuvkTexture {
@nogc:
private:
    VkImage image;
    VkDeviceMemory deviceMemory;

    void createTexture(NuvkProcessSharing processSharing) {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        auto deviceInfo = cast(NuvkVkDeviceInfo)this.getOwner().getDeviceInfo();
        NuvkTextureDescriptor descriptor = this.getDescriptor();
        VkMemoryRequirements memoryRequirements;
        int memoryIndex;
        VkFlags flags;

        // Create texture
        {
            VkImageCreateInfo imageCreateInfo;
            imageCreateInfo.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
            imageCreateInfo.imageType = descriptor.type.toVkImageType();
            imageCreateInfo.tiling = descriptor.tiling.toVkImageTiling();
            imageCreateInfo.samples = descriptor.type.toVkSampleCount(descriptor.samples);
            imageCreateInfo.usage = VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT;
            imageCreateInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
            imageCreateInfo.flags = flags;
            imageCreateInfo.extent.width = descriptor.extents.width;
            imageCreateInfo.extent.height = descriptor.extents.height;
            imageCreateInfo.extent.depth = descriptor.extents.depth;
            imageCreateInfo.mipLevels = descriptor.mipLevels;
            imageCreateInfo.arrayLayers = descriptor.arrayLayers;

            enforce(
                vkCreateImage(device, &imageCreateInfo, null, &image) == VK_SUCCESS,
                nstring("Failed creating Vulkan texture!")
            );
        }

        // Find memory layout
        {
            vkGetImageMemoryRequirements(device, image, &memoryRequirements);

            memoryIndex = deviceInfo.getMatchingMemoryIndex(memoryRequirements.memoryTypeBits, flags);
            enforce(
                memoryIndex >= 0, 
                nstring("Failed finding suitable memory for the requested buffer")
            );
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

                enforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    nstring("Failed allocating memory for buffer!")
                );

                vkBindImageMemory(device, image, deviceMemory, 0);
                this.setSharedHandle(nuvkVkGetSharedHandle(device, deviceMemory));
            
            } else {

                VkMemoryAllocateInfo allocInfo;
                allocInfo.allocationSize = memoryRequirements.size;
                allocInfo.memoryTypeIndex = memoryIndex;

                enforce(
                    vkAllocateMemory(device, &allocInfo, null, &deviceMemory) == VK_SUCCESS,
                    nstring("Failed allocating memory for buffer!")
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
        nuvkVkCloseSharedHandle(handle);
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureDescriptor descriptor, NuvkDeviceSharing deviceSharing, NuvkProcessSharing processSharing) {
        super(device, descriptor, deviceSharing, processSharing);
        this.createTexture(processSharing);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureFormat format, NuvkDeviceSharing deviceSharing, NuvkProcessSharing processSharing) {
        super(device, format, deviceSharing, processSharing);
        this.createTexture(processSharing);
    }

    /**
        Creates a texture view
    */
    override
    NuvkTextureView createTextureView(NuvkTextureViewDescriptor descriptor) {
        return nogc_new!NuvkVkTextureView(this.getOwner(), this, descriptor);
    }
}

/**
    A texture view.

    Texture views are used to reinterpret the data stored in a NuvkTexture
*/
class NuvkVkTextureView : NuvkTextureView {
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

        enforce(
            vkCreateImageView(device, &imageViewCreateInfo, null, &imageView),
            nstring("Failed to create Vulkan image view!")
        );

        this.setHandle(imageView);
    }

public:
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
    }

public:
    this(NuvkDevice device, NuvkSamplerDescriptor descriptor) {
        super(device, descriptor);
        this.createSampler();
    }
}