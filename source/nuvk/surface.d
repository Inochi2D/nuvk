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
import nuvk.sync;
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
class NuvkSurface : VulkanObject!(VkSurfaceKHR, VK_OBJECT_TYPE_SURFACE_KHR) {
private:
@nogc:
    VK_KHR_surface surfaceFuncs_;
    NuvkInstance instance_;

public:

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
        surfaceFuncs_.vkDestroySurfaceKHR(instance_.handle, handle, null);
    }

    /**
        Constructs a new surface
    
        Params:
            instance =      The instance the surface is bound to.
            surface =       The surface handle.
    */
    this(NuvkInstance instance, VkSurfaceKHR surface) {
        this.instance_ = instance;
        this.instance_.loadProcs!VK_KHR_surface(surfaceFuncs_);
        super(surface);   
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
        VkResult result = surfaceFuncs_.vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice.handle, queueFamily, handle, &supported);
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
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice.handle, handle, &caps_);
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
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.handle, handle, &pCount, null);
        
        formats_ = nu_malloca!VkSurfaceFormatKHR(pCount);
        surfaceFuncs_.vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.handle, handle, &pCount, formats_.ptr);
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
        surfaceFuncs_.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.handle, handle, &pCount, null);
        
        modes_ = nu_malloca!VkPresentModeKHR(pCount);
        surfaceFuncs_.vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.handle, handle, &pCount, modes_.ptr);
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
class NuvkSwapchain : NuvkDeviceObject!(VkSwapchainKHR, VK_OBJECT_TYPE_SWAPCHAIN_KHR) {
private:
@nogc:
    VkSwapchainCreateInfoKHR createInfo_;
    NuvkSurface surface_;
    VK_KHR_swapchain swapFuncs_;

    int lastImageIdx;
    vector!NuvkImage images;
    vector!NuvkImageView views;
    weak_vector!VkSemaphore tmpSemaphores_;

    void getImages() {
        if (!handle)
            return;

        this.clearOldImages();

        uint pCount;
        VkImage[] images_;
        swapFuncs_.vkGetSwapchainImagesKHR(device.handle, handle, &pCount, null);

        images_ = nu_malloca!VkImage(pCount);
        swapFuncs_.vkGetSwapchainImagesKHR(device.handle, handle, &pCount, images_.ptr);

        auto imageInfo = VkImageCreateInfo(
            imageType: VK_IMAGE_TYPE_2D,
            format: createInfo_.imageFormat,
            extent: VkExtent3D(createInfo_.imageExtent.width, createInfo_.imageExtent.height, 1),
            mipLevels: 1,
            arrayLayers: createInfo_.imageArrayLayers,
            usage: createInfo_.imageUsage,
            sharingMode: createInfo_.imageSharingMode,
            initialLayout: VK_IMAGE_LAYOUT_UNDEFINED
        );

        auto viewInfo = VkImageViewCreateInfo(
            viewType: VK_IMAGE_VIEW_TYPE_2D,
            format: createInfo_.imageFormat,
            components: VkComponentMapping(VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A),
            subresourceRange: VkImageSubresourceRange(VK_IMAGE_ASPECT_COLOR_BIT, 0, VK_REMAINING_MIP_LEVELS, 0, VK_REMAINING_ARRAY_LAYERS),
        );

        foreach(image; images_) {
            images ~= nogc_new!NuvkImage(device, image, imageInfo);
            views ~= images[$-1].createView(viewInfo);
        }
    }

    void createSwapchain() {
        VkSwapchainKHR handle_ = handle;
        if (handle_)
            createInfo_.oldSwapchain = handle_;

        vkEnforce(swapFuncs_.vkCreateSwapchainKHR(device.handle, &createInfo_, null, &handle_));
        this.handle = handle_;
        this.getImages();
    }

    void clearOldImages() {
        images.clear();

        foreach(view; views)
            view.release();
        views.clear();
    }
public:

    /**
        The surface that this swapchain belongs to.
    */
    @property NuvkSurface surface() => surface_;

    /// Destructor
    ~this() {
        this.clearOldImages();
        swapFuncs_.vkDestroySwapchainKHR(device.handle, handle, null);
    }

    /**
        Constructs a swapchain.

        Params:
            device =        The device to construct a swapchain on.
            surface =       The surface to construct a swapchain from.
            createInfo =    Swapchain creation info.
    */
    this(NuvkDevice device, NuvkSurface surface, VkSwapchainCreateInfoKHR createInfo) {
        super(device, null);

        this.surface_ = surface;
        this.createInfo_ = createInfo;
        this.createInfo_.surface = surface.handle;
        device.loadProcs!VK_KHR_swapchain(swapFuncs_);

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
    NuvkImageView acquireNext(ulong timeout, NuvkSemaphore semaphore, NuvkFence fence) {
        uint pIdx;
        VkResult result = swapFuncs_.vkAcquireNextImageKHR(
            device.handle, 
            handle, 
            timeout, 
            semaphore ? semaphore.handle : null, 
            fence ? fence.handle : null, 
            &pIdx
        );

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
    NuvkImageView acquireNext(ulong timeout, NuvkFence fence) {
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
    NuvkImageView acquireNext(ulong timeout, NuvkSemaphore semaphore) {
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
    VkResult presentOn(NuvkQueue queue, NuvkSemaphore[] waitSemaphores = null) {
        VkSwapchainKHR handle_ = handle;
        if (!handle_)
            return VK_ERROR_OUT_OF_DATE_KHR;

        if (lastImageIdx < 0)
            return VK_ERROR_OUT_OF_DATE_KHR;

        tmpSemaphores_.clear();
        foreach(semaphore; waitSemaphores)
            tmpSemaphores_ ~= semaphore.handle;

        VkResult result;
        auto presentInfo = VkPresentInfoKHR(
            waitSemaphoreCount: cast(uint)waitSemaphores.length,
            pWaitSemaphores: tmpSemaphores_.ptr,
            swapchainCount: 1,
            pSwapchains: &handle_,
            pResults: &result,
            pImageIndices: cast(uint*)&lastImageIdx,
        );
        swapFuncs_.vkQueuePresentKHR(queue.handle, &presentInfo);
        return result;
    }
}