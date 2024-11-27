/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.internal.vulkan.surface;
import nuvk.context;
static if (NuvkHasVulkan):


import nuvk.internal.vulkan;
import nuvk;
import numem.all;
import inmath;

/**
    A surface that can be rendered to
*/
class NuvkSurfaceVk : NuvkSurface {
@nogc:
private:
    NuvkSurfaceVkCapability capability;

    ptrdiff_t findSurfaceFormat(NuvkTextureFormat format_) {
        VkFormat fmt = format_.toVkImageFormat();

        foreach(i, ref VkSurfaceFormatKHR supportedFormat; capability.surfaceFormats) {
            if (supportedFormat.format == fmt && supportedFormat.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
                return i;
            }
        }

        return -1;
    }

    ptrdiff_t findPresentationMode(NuvkPresentMode presentMode) {
        VkPresentModeKHR pmode = presentMode.toVkPresentMode();

        foreach(i, ref VkPresentModeKHR supportedMode; capability.presentModes) {
            if (supportedMode == pmode) {
                return i;
            }
        }

        return -1;
    }
protected:

    /**
        Creates a swapchain that can be rendered with
    */
    override
    NuvkSwapchain onCreateSwapchain() {
        return nogc_new!NuvkSwapchainVk(this);
    }
    
    /**
        Called when the surface is requested to re-enumerate.
    */
    override
    void onRequestReenumerate() {
        VkPhysicalDevice physicalDevice = this.getOwner().getDeviceInfo().getHandle!VkPhysicalDevice();
        VkSurfaceKHR surface = this.getHandle!VkSurfaceKHR();
        
        // Surface formats and present modes
        {
            uint formatCount;
            uint presentModeCount;

            // Surface formats
            vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &formatCount, null);
            if (formatCount > 0) {
                capability.surfaceFormats.resize(formatCount);
                vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &formatCount, capability.surfaceFormats.data());
            }
            
            // Present modes
            vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModeCount, null);
            if (presentModeCount > 0) {
                capability.presentModes.resize(presentModeCount);
                vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModeCount, capability.presentModes.data());
            }
        }

        // Capabilities
        nuvkEnforce(
            vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &capability.surfaceCaps) == VK_SUCCESS,
            "Failed getting surface capabilties"
        );

        this.setMinExtents(vec2u(
            capability.surfaceCaps.minImageExtent.width,
            capability.surfaceCaps.minImageExtent.height,
        ));

        this.setMaxExtents(vec2u(
            capability.surfaceCaps.maxImageExtent.width,
            capability.surfaceCaps.maxImageExtent.height,
        ));

        this.setMinimumInFlight(capability.surfaceCaps.minImageCount);
        this.setMaximumInFlight(capability.surfaceCaps.maxImageCount);
    }

public:
    this(NuvkDevice device, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat, VkSurfaceKHR surface) {
        super(device, presentMode, textureFormat, cast(NuvkHandle)surface);
    }

    /**
        Gets the capabilities of the surface.
    */
    final
    VkSurfaceCapabilitiesKHR getCapabilities() {
        return capability.surfaceCaps;
    }

    /**
        Gets the formats supported by this surface
    */
    final
    VkSurfaceFormatKHR[] getSurfaceFormats() {
        return capability.surfaceFormats[];
    }

    /**
        Gets the formats supported by this surface
    */
    final
    VkPresentModeKHR[] getSurfacePresentModes() {
        return capability.presentModes[];
    }

    /**
        Gets the vulkan surface format
    */
    final
    VkSurfaceFormatKHR getVkSurfaceFormat() {
        ptrdiff_t idx = findSurfaceFormat(this.getFormat());
        return capability.surfaceFormats[idx];
    }

    /**
        Gets the vulkan presentation mode
    */
    final
    VkPresentModeKHR getVkPresentMode() {
        ptrdiff_t idx = findPresentationMode(this.getPresentationMode());
        return capability.presentModes[idx];
    }

    /**
        Gets the vulkan alpha composition flags.
    */
    final
    VkCompositeAlphaFlagBitsKHR getVkAlphaFlags() {
        return this.getCompositeMode().toVkAlphaFlags();
    }

    /**
        Gets whether it is possible to use the specified texture format.
    */
    override
    bool isFormatSupported(NuvkTextureFormat textureFormat) {
        return findSurfaceFormat(textureFormat) != -1;
    }
    
    /**
        Gets whether it is possible to use the specified presentation mode.
    */
    override
    bool isPresentationModeSupported(NuvkPresentMode presentMode) {
        return findPresentationMode(presentMode) != -1;
    }

    /**
        Gets whether it is possible to use the specified composite mode.
    */
    override
    bool isCompositeModeSupported(NuvkSurfaceCompositeMode compositeMode) {
        auto alphaFlags = compositeMode.toVkAlphaFlags();
        return (alphaFlags & capability.surfaceCaps.supportedCompositeAlpha) > 0;
    }
}

/**
    A swapchain containing images that can be rendered to.
*/
class NuvkSwapchainVk : NuvkSwapchain {
@nogc:
private:
    // Synchronization
    uint currentImageIndex = 0;

    // Swapchain
    vector!NuvkTexture textures;
    vector!NuvkTextureView views;

protected:

    /**
        Gets the next texture in the swapchain
    */
    override
    NuvkTextureView onGetNext(ulong timeout) {
        auto swapchain = this.getHandle!VkSwapchainKHR();
        
        // Window is minimized or something, we got no images.
        if (swapchain == VK_NULL_HANDLE) 
            return null;

        auto frameAvailableFence = this.getFrameAvailableFence();
        auto frameAvailableFencePtr = cast(VkFence)this.getFrameAvailableFence().getHandle();
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkResult status = vkAcquireNextImageKHR(device, swapchain, timeout, VK_NULL_HANDLE, frameAvailableFencePtr, &currentImageIndex);
        if (status == VK_ERROR_OUT_OF_DATE_KHR) {
            this.recreate();
            return this.getNext(timeout);
        }

        if (status == VK_SUCCESS) {
            frameAvailableFence.await(ulong.max);
            frameAvailableFence.reset();
            return this.views[currentImageIndex];
        }
        
        return null;
    }

    void resetState() {
        this.textures.clear();
        this.views.clear();

        this.currentImageIndex = 0;            
        this.resetSyncObjects();
    }

    bool createSwapchain() {
        auto device = this.getOwner().getHandle!VkDevice();
        auto surface = cast(NuvkSurfaceVk)this.getSurface();

        vec2u surfaceSize = surface.getSize();
        VkSurfaceFormatKHR surfaceFormat = surface.getVkSurfaceFormat();
        VkPresentModeKHR presentMode = surface.getVkPresentMode();
        VkCompositeAlphaFlagBitsKHR alphaFlags = surface.getVkAlphaFlags();
        VkSurfaceCapabilitiesKHR surfaceCaps = surface.getCapabilities();

        // Swapchain creation
        VkSwapchainKHR swapchain;

        VkSwapchainCreateInfoKHR swapchainCreateInfo;
        swapchainCreateInfo.minImageCount = surface.getFramesInFlight();
        swapchainCreateInfo.imageFormat = surfaceFormat.format;
        swapchainCreateInfo.imageColorSpace = surfaceFormat.colorSpace;
        swapchainCreateInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT;
        swapchainCreateInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
        swapchainCreateInfo.imageExtent = VkExtent2D(surfaceSize.x, surfaceSize.y);
        swapchainCreateInfo.imageArrayLayers = 1;
        swapchainCreateInfo.preTransform = surfaceCaps.currentTransform;
        swapchainCreateInfo.compositeAlpha = alphaFlags;
        swapchainCreateInfo.presentMode = presentMode;
        swapchainCreateInfo.clipped = VK_FALSE;
        swapchainCreateInfo.surface = surface.getHandle!VkSurfaceKHR();

        if (vkCreateSwapchainKHR(device, &swapchainCreateInfo, null, &swapchain) == VK_SUCCESS) {
            this.setHandle(swapchain);
            return true;
        }

        return false;
    }

    uint getSwapchainImageCount() {
        auto device = this.getOwner().getHandle!VkDevice();
        auto swapchain = this.getHandle!VkSwapchainKHR();

        uint swapchainImageCount;
        vkGetSwapchainImagesKHR(device, swapchain, &swapchainImageCount, null);
        return swapchainImageCount;
    }

    bool recreateImageList() {
        auto device = this.getOwner().getHandle!VkDevice();
        auto swapchain = this.getHandle!VkSwapchainKHR();
        auto surface = cast(NuvkSurfaceVk)this.getSurface();

        uint swapchainImageCount = this.getSwapchainImageCount();
        if (swapchainImageCount == 0)
            return false;

        weak_vector!VkImage swapchainImages = weak_vector!VkImage(swapchainImageCount);
        if (vkGetSwapchainImagesKHR(device, swapchain, &swapchainImageCount, swapchainImages.ptr) != VK_SUCCESS)
            return false;

        // Success, recreate the image list.
        this.setAllocatedFrameCount(swapchainImageCount);
        this.textures.resize(swapchainImageCount);
        this.views.resize(swapchainImageCount);

        vec2u surfaceSize = surface.getSize();
        VkSurfaceFormatKHR surfaceFormat = surface.getVkSurfaceFormat();
        foreach(i; 0..swapchainImageCount) {
            NuvkTextureViewDescriptor viewDescriptor;
            viewDescriptor.type = NuvkTextureType.texture2d;
            viewDescriptor.format = surfaceFormat.format.toNuvkTextureFormat();
            viewDescriptor.arraySlices = NuvkRange!int(0, 1);
            viewDescriptor.mipLevels = NuvkRange!int(0, 1);

            this.textures[i] = nogc_new!NuvkTextureVk(this.getOwner(), swapchainImages[i], surfaceFormat.format, surfaceSize);
            this.views[i] = this.textures[i].createTextureView(viewDescriptor);
        }

        return true;
    }

    override
    void onRecreate() {
        auto device = this.getOwner();
        auto deviceHandle = device.getHandle!VkDevice();
        auto swapchain = this.getHandle!VkSwapchainKHR();
        auto surface = cast(NuvkSurfaceVk)this.getSurface();

        // Destroy swapchain if it already exists
        if (swapchain) {
            device.awaitAll();
            vkDestroySwapchainKHR(deviceHandle, swapchain, null);

            this.setHandle(null);
            swapchain = null;
        }

        this.resetState();

        if (!surface.isRenderCapable())
            return;
        
        if (this.createSwapchain()) {
            this.recreateImageList();
        }
    }

public:

    /**
        Constructor
    */
    this(NuvkSurfaceVk surface) {
        super(surface);
    }

    /**
        Gets the current texture.
    */
    override
    NuvkTextureView getCurrent() {
        return this.views[currentImageIndex];
    }

    /**
        Gets the index of the current texture.
    */
    final
    uint getCurrentImageIndex() {
        return currentImageIndex;
    }
}

/**
    Gets the Vulkan Alpha flags for the specified surface composite mode.
*/
VkCompositeAlphaFlagBitsKHR toVkAlphaFlags(NuvkSurfaceCompositeMode compositeMode) @nogc nothrow {
    final switch(compositeMode) {
        case NuvkSurfaceCompositeMode.opaque:
            return VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
        case NuvkSurfaceCompositeMode.preMultiplied:
            return VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR;
        case NuvkSurfaceCompositeMode.postMultiplied:
            return VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR;
    }
}

/**
    Gets the Vulkan presentation mode for the specified nuvk present mode.
*/
VkPresentModeKHR toVkPresentMode(NuvkPresentMode presentMode) @nogc {
    final switch(presentMode) {
        case NuvkPresentMode.immediate:
            return VK_PRESENT_MODE_IMMEDIATE_KHR;

        case NuvkPresentMode.vsync:
            return VK_PRESENT_MODE_FIFO_KHR;

        case NuvkPresentMode.tripleBuffered:
            return VK_PRESENT_MODE_MAILBOX_KHR;
    }
}

private {
    struct NuvkSurfaceVkCapability {
    @nogc:
        VkSurfaceCapabilitiesKHR surfaceCaps;
        vector!VkSurfaceFormatKHR surfaceFormats;
        vector!VkPresentModeKHR presentModes;
    }
}