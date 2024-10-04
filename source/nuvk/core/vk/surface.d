/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.surface;
import nuvk.core.vk;
import nuvk.core;
import numem.all;

import inmath;

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

/**
    A surface that can be rendered to
*/
class NuvkVkSurface : NuvkSurface {
@nogc:
private:
    struct NuvkVkSurfaceCapability {
    @nogc:
        VkSurfaceCapabilitiesKHR surfaceCaps;
        vector!VkSurfaceFormatKHR surfaceFormats;
        vector!VkPresentModeKHR presentModes;
    }

    VkSurfaceKHR surface;
    NuvkVkSurfaceCapability capability;

    void enumerateCapabilities() {
        VkPhysicalDevice physicalDevice = cast(VkPhysicalDevice)this.getOwner().getDeviceInfo().getHandle();
        
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

        this.updateSurfaceCapabilities();
    }

    void updateSurfaceCapabilities() {
        VkPhysicalDevice physicalDevice = cast(VkPhysicalDevice)this.getOwner().getDeviceInfo().getHandle();

        // Capabilities
        enforce(
            vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &capability.surfaceCaps) == VK_SUCCESS,
            nstring("Failed getting surface capabilties")
        );
    }

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
        return nogc_new!NuvkVkSwapchain(this.getOwner(), this);
    }

    /**
        Gets whether it is possible to use the specified texture format.
    */
    override
    bool isFormatValid(NuvkTextureFormat textureFormat) {
        return findSurfaceFormat(textureFormat) != -1;
    }
    
    /**
        Gets whether it is possible to use the specified presentation mode.
    */
    override
    bool isPresentModeValid(NuvkPresentMode presentMode) {
        return findPresentationMode(presentMode) != -1;
    }

public:
    this(NuvkDevice device, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat, VkSurfaceKHR surface) {
        super(device, presentMode, textureFormat);
        this.surface = surface;
        this.setHandle(surface);

        this.enumerateCapabilities();
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
}

/**
    A swapchain containing images that can be rendered to.
*/
class NuvkVkSwapchain : NuvkSwapchain {
@nogc:
private:
    // Synchronization
    uint currentImageIndex = 0;

    // Swapchain
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;
    vector!NuvkTexture textures;
    vector!NuvkTextureView views;


    void createSwapchain(NuvkVkSurface surface, bool forceRecreate=false) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        // Destroy swapchain if it already exists
        if (swapchain != VK_NULL_HANDLE || forceRecreate) {
            if (swapchain != VK_NULL_HANDLE) {
                this.getOwner().awaitAll();
                vkDestroySwapchainKHR(device, swapchain, null);

                swapchain = VK_NULL_HANDLE;
                this.setHandle(swapchain);
            }

            this.textures.clear();
            this.views.clear();

            this.currentImageIndex = 0;            
            this.resetSyncObjects();
        }

        vec2u surfaceSize = surface.getSize();
        VkSurfaceFormatKHR surfaceFormat = surface.getVkSurfaceFormat();
        VkPresentModeKHR presentMode = surface.getVkPresentMode();
        VkSurfaceCapabilitiesKHR surfaceCaps = surface.getCapabilities();


        // Swapchain creation
        {

            // Minimized?
            if (surfaceCaps.maxImageExtent.width == 0 || surfaceCaps.maxImageExtent.height == 0) {
                return;
            }

            VkSwapchainCreateInfoKHR swapchainCreateInfo;
            swapchainCreateInfo.minImageCount = surfaceCaps.minImageCount+1;
            swapchainCreateInfo.imageFormat = surfaceFormat.format;
            swapchainCreateInfo.imageColorSpace = surfaceFormat.colorSpace;
            swapchainCreateInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT;
            swapchainCreateInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
            swapchainCreateInfo.imageExtent = VkExtent2D(
                clamp(surfaceSize.x, surfaceCaps.minImageExtent.width, surfaceCaps.maxImageExtent.width),
                clamp(surfaceSize.y, surfaceCaps.minImageExtent.height, surfaceCaps.maxImageExtent.height),
            );
            swapchainCreateInfo.imageArrayLayers = 1;
            swapchainCreateInfo.preTransform = surfaceCaps.currentTransform;
            swapchainCreateInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
            swapchainCreateInfo.presentMode = presentMode;
            swapchainCreateInfo.clipped = VK_FALSE;
            swapchainCreateInfo.surface = cast(VkSurfaceKHR)surface.getHandle();

            enforce(
                vkCreateSwapchainKHR(device, &swapchainCreateInfo, null, &swapchain) == VK_SUCCESS,
                nstring("Failed to create swapchain")
            );

            this.setHandle(swapchain);
        }

        // NuvkTexture creation
        {
            weak_vector!VkImage swapchainImages;
            uint swapchainImageCount;
            vkGetSwapchainImagesKHR(device, swapchain, &swapchainImageCount, null);

            swapchainImages = weak_vector!VkImage(swapchainImageCount);
            enforce(
                vkGetSwapchainImagesKHR(device, swapchain, &swapchainImageCount, swapchainImages.data()) == VK_SUCCESS,
                nstring("Failed to create swapchain images.")
            );

            this.textures.resize(swapchainImageCount);
            this.views.resize(swapchainImageCount);

            foreach(i; 0..swapchainImageCount) {
                NuvkTextureViewDescriptor viewDescriptor;
                viewDescriptor.type = NuvkTextureType.texture2d;
                viewDescriptor.format = surfaceFormat.format.toNuvkTextureFormat();
                viewDescriptor.arraySlices = NuvkRange!int(0, 1);
                viewDescriptor.mipLevels = NuvkRange!int(0, 1);

                this.textures[i] = nogc_new!NuvkVkTexture(this.getOwner(), swapchainImages[i], surfaceFormat.format, surfaceSize);
                this.views[i] = this.textures[i].createTextureView(viewDescriptor);
            }
        }
    }

protected:

    override
    void update(bool forceRecreate=false) {
        NuvkVkSurface surface = cast(NuvkVkSurface)this.getSurface();
        surface.enumerateCapabilities();
        this.createSwapchain(surface);
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkVkSurface surface) {
        super(device, surface);
        this.createSwapchain(surface);
    }

    /**
        Gets the next texture in the swapchain
    */
    override
    NuvkTextureView getNext() {
        
        // Window is minimized or something, we got no images.
        if (swapchain == VK_NULL_HANDLE) 
            return null;

        auto frameAvailableFence = this.getFrameAvailableFence();
        auto frameAvailableFencePtr = cast(VkFence)this.getFrameAvailableFence().getHandle();
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkResult status = vkAcquireNextImageKHR(device, swapchain, ulong.max, VK_NULL_HANDLE, frameAvailableFencePtr, &currentImageIndex);
        if (status == VK_ERROR_OUT_OF_DATE_KHR) {
            this.update(true);
            return this.getNext();
        }

        if (status == VK_SUCCESS) {
            frameAvailableFence.await(ulong.max);
            frameAvailableFence.reset();
            return this.views[currentImageIndex];
        }
        
        return null;
    }

    final
    NuvkTextureView getCurrent() {
        return this.views[currentImageIndex];
    }

    /**
        Gets the index of the current image.
    */
    final
    uint getCurrentImageIndex() {
        return currentImageIndex;
    }
}