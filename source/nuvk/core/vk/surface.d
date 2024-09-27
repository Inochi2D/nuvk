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
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;

    void createSwapchain(NuvkVkSurface surface) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        // Destroy swapchain if it already exists
        if (swapchain != VK_NULL_HANDLE) {
            vkDestroySwapchainKHR(device, swapchain, null);
        }

        VkSurfaceFormatKHR surfaceFormat = surface.getVkSurfaceFormat();
        VkPresentModeKHR presentMode = surface.getVkPresentMode();
        VkSurfaceCapabilitiesKHR surfaceCaps = surface.getCapabilities();

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
            clamp(surfaceCaps.currentExtent.width, surfaceCaps.minImageExtent.width, surfaceCaps.maxImageExtent.width),
            clamp(surfaceCaps.currentExtent.height, surfaceCaps.minImageExtent.height, surfaceCaps.maxImageExtent.height),
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
    }

protected:

    override
    void update() {
        NuvkVkSurface surface = cast(NuvkVkSurface)this.getSurface();
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
        Whether the swapchain is outdated.
    */
    override
    bool isSwapchainOutdated() {
        auto device = cast(VkDevice)this.getOwner().getHandle();
        return vkGetSwapchainStatusKHR(device, swapchain) == VK_ERROR_OUT_OF_DATE_KHR;
    }

    /**
        Gets the next texture in the swapchain
    */
    override
    NuvkTexture getNext() {
        return null;
    }
}