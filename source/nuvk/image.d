/**
    GPU Images and Views
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.image;
import nuvk.device;
import vulkan.core;
import nuvk.core;
import numem;

/**
    A Vulkan Image
*/
final
class NuvkImage : NuvkDeviceObject!(VkImage, VK_OBJECT_TYPE_IMAGE) {
private:
@nogc:
    VkDeviceMemory memory_;
    VkImageCreateInfo createInfo_;
    VkMemoryRequirements memRequirements_;

public:

    /**
        Size of the image in bytes.
    */
    @property ulong size() => memRequirements_.size;

    /**
        Alignment of the image in bytes.
    */
    @property ulong alignment() => memRequirements_.alignment;

    /**
        The type of the image.
    */
    final @property VkImageType imageType() => createInfo_.imageType;

    /**
        The format of the image.
    */
    final @property VkFormat format() => createInfo_.format;

    /**
        Width of the image in pixels.
    */
    @property uint width() => createInfo_.extent.width;

    /**
        Height of the image in pixels.
    */
    @property uint height() => createInfo_.extent.height;

    /**
        Depth of the image in pixels.
    */
    @property uint depth() => createInfo_.extent.depth;

    /**
        Mipmapping levels of the image.
    */
    @property uint levels() => createInfo_.mipLevels;

    /**
        Array layers of the image.
    */
    @property uint layers() => createInfo_.arrayLayers;

    /**
        Sharing mode of the image.
    */
    @property VkSharingMode sharingMode() => createInfo_.sharingMode;

    /// Destructor
    ~this() {
        if (handle)
            vkDestroyImage(device.handle, handle, null);
        
        if (memory_)
            vkFreeMemory(device.handle, memory_, null);
    }

    /**
        Constructs a new Vulkan Image
    */
    this(NuvkDevice device, VkImageCreateInfo createInfo) {
        this.createInfo_ = createInfo;

        VkImage image_;
        int reqPropId = device.selectMemoryTypeFor(VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT);
        if (reqPropId >= 0) {
            vkEnforce(vkCreateImage(device.handle, &createInfo_, null, &image_));
            vkGetImageMemoryRequirements(device.handle, image_, &memRequirements_);
            
            auto allocInfo = VkMemoryAllocateInfo(
                allocationSize: memRequirements_.size,
                memoryTypeIndex: reqPropId
            );
            vkEnforce(vkAllocateMemory(device.handle, &allocInfo, null, &memory_));
            vkEnforce(vkBindImageMemory(device.handle, image_, memory_, 0));
        }
        super(device, image_);
    }

    /**
        Constructs a new Vulkan Image

        Params:
            device      = The device which owns the image view
            ptr         = The pre-existing vulkan handle to use.
            imageInfo   = Information about the image.
    */
    this(NuvkDevice device, VkImage ptr, VkImageCreateInfo imageInfo) {
        this.createInfo_ = imageInfo;
        vkGetImageMemoryRequirements(device.handle, ptr, &memRequirements_);
        super(device, ptr);
    }

    /**
        Creates an image view from the image.

        Params:
            createInfo = Creation information.

        Returns:
            A new image view.
    */
    NuvkImageView createView(VkImageViewCreateInfo createInfo) {
        return nogc_new!NuvkImageView(device, this, createInfo);
    }
}

/**
    A Vulkan Image View
*/
final
class NuvkImageView : NuvkDeviceObject!(VkImageView, VK_OBJECT_TYPE_IMAGE_VIEW) {
private:
@nogc:
    NuvkImage image_;
    VkImageViewCreateInfo createInfo_;

public:

    /**
        The image this is a view of.
    */
    final @property NuvkImage image() => image_;

    /**
        The type of the image.
    */
    final @property VkImageType imageType() => image_.imageType;

    /**
        The format of the view.
    */
    final @property VkFormat format() => createInfo_.format;

    /**
        Width of the image in pixels.
    */
    @property uint width() => image_.width;

    /**
        Height of the image in pixels.
    */
    @property uint height() => image_.height;

    /**
        Depth of the image in pixels.
    */
    @property uint depth() => image_.depth;

    /**
        Mipmapping levels of the image.
    */
    @property uint levels() => image_.levels;

    /**
        Array layers of the image.
    */
    @property uint layers() => image_.layers;

    /**
        Sharing mode of the image.
    */
    @property VkSharingMode sharingMode() => image_.sharingMode;

    /// Destructor
    ~this() {
        if (handle) {
            vkDestroyImageView(device.handle, handle, null);
            image_.release();
        }
    }

    /**
        Constructs a new Vulkan Image View

        Params:
            device      = The device which owns the image view
            image       = The image this is a view of.
            createInfo  = Creation information for the image.
    */
    this(NuvkDevice device, NuvkImage image, VkImageViewCreateInfo createInfo) {
        this.createInfo_ = createInfo;
        this.createInfo_.image = image.handle;

        VkImageView imageView_;
        vkEnforce(vkCreateImageView(device.handle, &createInfo_, null, &imageView_));

        this.image_ = image.retained();
        super(device, imageView_);
    }

    /**
        Constructs a new Vulkan Image View

        Params:
            device      = The device which owns the image view
            image       = The image this is a view of.
            ptr         = The pre-existing vulkan handle to use.
    */
    this(NuvkDevice device, NuvkImage image, VkImageView ptr) {
        this.image_ = image.retained();
        super(device, ptr);
    }
}