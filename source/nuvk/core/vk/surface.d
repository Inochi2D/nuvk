/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.surface;
import nuvk.core.vk;
import nuvk.core;
import numem.all;

/**
    A surface that can be rendered to
*/
class NuvkVkSurface : NuvkSurface {
@nogc:
private:
    struct NuvkVkSurfaceCapability {
    @nogc:
        VkSurfaceCapabilitiesKHR surfaceCaps;
        weak_vector!VkSurfaceFormatKHR surfaceFormats;
        weak_vector!VkPresentModeKHR presentModes;
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
    }

    void updateSurfaceCapabilities() {
        VkPhysicalDevice physicalDevice = cast(VkPhysicalDevice)this.getOwner().getDeviceInfo().getHandle();

        // Capabilities
        enforce(
            vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &capability.surfaceCaps) == VK_SUCCESS,
            nstring("Failed getting surface capabilties")
        );
    }
protected:

    /**
        Creates a swapchain that can be rendered with
    */
    override
    NuvkSwapchain onCreateSwapchain() {
        return nogc_new!NuvkVkSwapchain(this.getOwner(), this);
    }

public:
    this(NuvkDevice device, VkSurfaceKHR surface) {
        super(device);
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
        Updates the surface
    */
    override
    void update() {
        // Needed so that the swapchain knows our current size.
        this.updateSurfaceCapabilities();
        this.updateSwapchains();
    }
}

/**
    A swapchain containing images that can be rendered to.
*/
class NuvkVkSwapchain : NuvkSwapchain {
@nogc:
private:
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;

    // Chooses surface format
    VkSurfaceFormatKHR chooseSurfaceFormat(VkSurfaceFormatKHR[] formats) {
        foreach(ref VkSurfaceFormatKHR format; formats) {
            if (format.format == VK_FORMAT_B8G8R8A8_SRGB && format.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
                return format;
            }
        }

        // Just choose whatever
        return formats[0];
    }

    // Chooses present mode
    VkPresentModeKHR choosePresentMode(VkPresentModeKHR[] presentModes) {
        return VK_PRESENT_MODE_FIFO_KHR;
    }

    void createSwapchain(NuvkVkSurface surface) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        // Destroy swapchain if it already exists
        if (swapchain != VK_NULL_HANDLE) {
            vkDestroySwapchainKHR(device, swapchain, null);
        }

        VkSurfaceFormatKHR surfaceFormat = chooseSurfaceFormat(surface.getSurfaceFormats());
        VkPresentModeKHR presentMode = choosePresentMode(surface.getSurfacePresentModes());
        VkSurfaceCapabilitiesKHR surfaceCaps = surface.getCapabilities();

        // Minimized?
        if (surfaceCaps.maxImageExtent.width == 0 || surfaceCaps.maxImageExtent.height == 0) {
            return;
        }

        VkSwapchainCreateInfoKHR swapchainCreateInfo;
        swapchainCreateInfo.minImageCount = surfaceCaps.minImageCount;
        swapchainCreateInfo.imageFormat = surfaceFormat.format;
        swapchainCreateInfo.imageColorSpace = surfaceFormat.colorSpace;
        swapchainCreateInfo.imageExtent = surfaceCaps.currentExtent;
        swapchainCreateInfo.imageArrayLayers = 1;
        swapchainCreateInfo.imageUsage = surfaceCaps.supportedUsageFlags;
        swapchainCreateInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
        swapchainCreateInfo.preTransform = surfaceCaps.currentTransform;
        swapchainCreateInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
        swapchainCreateInfo.presentMode = presentMode;
        swapchainCreateInfo.clipped = VK_FALSE;

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
}