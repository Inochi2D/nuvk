/**
    GPU Surface
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.surface;
import nuvk.instance;
import nuvk.physicaldevice;
import nuvk.device;
import nuvk.image;
import nuvk.queue;
import vulkan.core;
import vulkan.khr_surface;
import vulkan.khr_swapchain;
import vulkan.nuvk.loader;
import nuvk.core;
import numem;
import nulib;

/**
    A Vulkan Surface
*/
final
class NuvkSurface : NuRefCounted {
private:
@nogc:
    VK_KHR_surface surfaceFuncs_;
    NuvkInstance instance_;
    VkSurfaceKHR handle_;

public:

    /**
        The handle of this surface.
    */
    @property VkSurfaceKHR handle() => handle_;

    /**
        Constructs a new surface
    
        Params:
            instance =      The instance the surface is bound to.
            surfacePtr =    The surface pointer.
    */
    static NuvkSurface fromSurface(NuvkInstance instance, void* surfacePtr) {
        return nogc_new!NuvkSurface(instance, cast(VkSurfaceKHR)surfacePtr);
    }

    /// Destructor
    ~this() {
        surfaceFuncs_.vkDestroySurfaceKHR(instance_.handle, handle_, null);
    }

    /**
        Constructs a new surface
    
        Params:
            instance =      The instance the surface is bound to.
            surface =       The surface handle.
    */
    this(NuvkInstance instance, VkSurfaceKHR surface) {
        this.handle_ = surface;
        this.instance_ = instance;
        instance_.handle.loadProcs!VK_KHR_surface(surfaceFuncs_);
    }

    /**
        Gets whether the given queue is supported by the surface.

        Params:
            physicalDevice =    The physical device to query.
            queueFamily =       The queue family index to query.
        
        Returns:
            $(D true) if the given queue family is supported,
            $(D false) otherwise.
    */
    bool isQueueSupported(NuvkPhysicalDevice physicalDevice, uint queueFamily) {
        if (!surfaceFuncs_.vkGetPhysicalDeviceSurfaceSupportKHR)
            return false;
        
        VkBool32 supported;
        VkResult result = surfaceFuncs_.vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, queueFamily, handle_, &supported);
        return result >= 0 && supported;
    }

    /**
        Gets the capabilities for the given physical device.

        Params:
            physicalDevice =    The physical device to query.
        
        Returns:
            A VkSurfaceCapabilitiesKHR struct.
    */
    VkSurfaceCapabilitiesKHR getCapabilitiesFor(NuvkPhysicalDevice physicalDevice) {
        VkSurfaceCapabilitiesKHR caps_;
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, handle_, &caps_);
        return caps_;
    }

    /**
        Gets the supported formats for the given physical device.

        Params:
            physicalDevice =    The physical device to query.
        
        Returns:
            A nogc array of VkSurfaceFormatKHRs.
    */
    VkSurfaceFormatKHR[] getSurfaceFormatsFor(NuvkPhysicalDevice physicalDevice) {
        VkSurfaceFormatKHR[] formats_;
        uint pCount;
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, handle_, &pCount, null);
        
        formats_ = nu_malloca!VkSurfaceFormatKHR(pCount);
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, handle_, &pCount, formats_.ptr);
        return formats_;
    }

    /**
        Gets the supported present modes for the given physical device.

        Params:
            physicalDevice =    The physical device to query.
        
        Returns:
            A nogc array of VkPresentModeKHRs.
    */
    VkPresentModeKHR[] getPresentModesFor(NuvkPhysicalDevice physicalDevice) {
        VkPresentModeKHR[] modes_;
        uint pCount;
        surfaceFuncs_.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, handle_, &pCount, null);
        
        modes_ = nu_malloca!VkPresentModeKHR(pCount);
        surfaceFuncs_.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, handle_, &pCount, modes_.ptr);
        return modes_;
    }

    /**
        Creates a swapchain.

        Params:
            device =        The device to construct a swapchain on.
            createInfo =    Swapchain creation info.
    */
    NuvkSwapchain createSwapchain(NuvkDevice device, VkSwapchainCreateInfoKHR createInfo) {
        return nogc_new!NuvkSwapchain(device, this, createInfo);
    }
}

/**
    A swapchain created from a surface.
*/
final
class NuvkSwapchain : NuRefCounted {
private:
@nogc:
    VkSwapchainCreateInfoKHR createInfo_;
    NuvkSurface surface_;
    NuvkDevice device_;
    VK_KHR_swapchain swapFuncs_;

    VkSwapchainKHR handle_;

    int lastImageIdx;
    vector!NuvkImage images;
    vector!NuvkImageView views;

    void getImages() {
        views.clear();
        images.clear();

        uint pCount;
        VkImage[] images_;
        swapFuncs_.vkGetSwapchainImagesKHR(device_.handle, handle_, &pCount, null);

        images_ = nu_malloca!VkImage(pCount);
        swapFuncs_.vkGetSwapchainImagesKHR(device_.handle, handle_, &pCount, images_.ptr);

        foreach(image; images_) {
            images ~= nogc_new!NuvkImage(device_, image);
            views ~= images[$-1].createView(VkImageViewCreateInfo(
                viewType: VK_IMAGE_VIEW_TYPE_2D,
                format: createInfo_.imageFormat,
                components: VkComponentMapping(VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A),
                subresourceRange: VkImageSubresourceRange(VK_IMAGE_ASPECT_COLOR_BIT, 1, 1, 1, 1)
            ));
        }
    }

    void createSwapchain() {
        if (handle_) {
            createInfo_.oldSwapchain = handle_;
        }

        swapFuncs_.vkCreateSwapchainKHR(device_.handle, &createInfo_, null, &handle_);
        this.getImages();
    }
public:

    /**
        The handle of this swapchain.
    */
    @property VkSwapchainKHR handle() => handle_;

    /**
        The surface that this swapchain belongs to.
    */
    @property NuvkSurface surface() => surface_;

    /**
        The device that this swapchain belongs to.
    */
    @property NuvkDevice device() => device_;

    /// Destructor
    ~this() {
        swapFuncs_.vkDestroySwapchainKHR(device_.handle, handle_, null);
    }

    /**
        Constructs a swapchain.

        Params:
            device =        The device to construct a swapchain on.
            surface =       The surface to construct a swapchain from.
            createInfo =    Swapchain creation info.
    */
    this(NuvkDevice device, NuvkSurface surface, VkSwapchainCreateInfoKHR createInfo) {
        this.createInfo_ = createInfo;
        this.surface_ = surface;
        this.device_ = device;
        device_.handle.loadProcs!VK_KHR_swapchain(swapFuncs_);

        this.createInfo_.surface = surface.handle;
        this.createSwapchain();
    }

    /**
        Resizes the images of the swapchain.

        This first takes place during the next swapchain invalidation.
    */
    void resize(uint width, uint height) {
        createInfo_.imageExtent = VkExtent2D(width, height);
    }

    /**
        Acquires a new image from the swapchain.

        Params:
            timeout =   Timeout in nanoseconds to wait for an image.
            semaphore = Semaphore to signal
            fence =     Fence to signal
        
        Note:
            If the swapchain is outdated, it will automatically be
            recreated.

        Returns:
            An image view describing the image acquired,
            or $(D null) on failure.
    */
    NuvkImageView acquireNext(ulong timeout, VkSemaphore semaphore, VkFence fence) {
        uint pIdx;
        VkResult result = swapFuncs_.vkAcquireNextImageKHR(device_.handle, handle_, timeout, semaphore, fence, &pIdx);

        // Success
        if (result >= 0) {
            lastImageIdx = pIdx;
            return views[pIdx];
        }

        // Out of date, retry.
        if (result == VK_ERROR_OUT_OF_DATE_KHR) {
            lastImageIdx = -1;
            this.createSwapchain();
            return acquireNext(timeout, semaphore, fence);
        }

        return null;
    }

    /**
        Acquires a new image from the swapchain.

        Params:
            timeout =   Timeout in nanoseconds to wait for an image.
            fence =     Fence to signal
        
        Note:
            If the swapchain is outdated, it will automatically be
            recreated.

        Returns:
            An image view describing the image acquired,
            or $(D null) on failure.
    */
    NuvkImageView acquireNext(ulong timeout, VkFence fence) {
        return this.acquireNext(timeout, null, fence);
    }    

    /**
        Acquires a new image from the swapchain.

        Params:
            timeout =   Timeout in nanoseconds to wait for an image.
            semaphore = Semaphore to signal
        
        Note:
            If the swapchain is outdated, it will automatically be
            recreated.

        Returns:
            An image view describing the image acquired,
            or $(D null) on failure.
    */
    NuvkImageView acquireNext(ulong timeout, VkSemaphore semaphore) {
        return this.acquireNext(timeout, semaphore, null);
    }

    /**
        Presents this surface on the specified queue.

        Params:
            queue =             The queue to enqueue the presentation request on.
            waitSemaphores =    The semaphores to await before presentation.

        Returns:
            A positive VkResult on success, a negative
            VkResult otherwise.
    */
    VkResult presentOn(NuvkQueue queue, VkSemaphore[] waitSemaphores = null) {
        if (lastImageIdx < 0)
            return VK_ERROR_OUT_OF_DATE_KHR;

        VkResult result;
        auto presentInfo = VkPresentInfoKHR(
            waitSemaphoreCount: cast(uint)waitSemaphores.length,
            pWaitSemaphores: waitSemaphores.ptr,
            swapchainCount: 1,
            pSwapchains: &handle_,
            pResults: &result,
            pImageIndices: cast(uint*)&lastImageIdx,
        );
        swapFuncs_.vkQueuePresentKHR(queue.handle, &presentInfo);
        return result;
    }
}