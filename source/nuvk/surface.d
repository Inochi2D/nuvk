/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.surface;
import nuvk;
import numem.all;

import inmath;

/**
    A surface that can be rendered to
*/
abstract
class NuvkSurface : NuvkDeviceObject {
@nogc:
private:
    // Swapchain handle
    NuvkSwapchain swapchain;

    // Surface info and settings
    NuvkPresentMode presentMode;
    NuvkTextureFormat textureFormat;
    NuvkSurfaceCompositeMode compositeMode = NuvkSurfaceCompositeMode.opaque;
    vec2u surfaceSize;
    vec2u minExtents = vec2u(0, 0);
    vec2u maxExtents = vec2u(uint.max, uint.max);
    uint framesInFlight = 1;
    uint minInFlight = 1;
    uint maxInFlight = uint.max;

protected:

    /**
        Creates a swapchain that can be rendered with
    */
    abstract NuvkSwapchain onCreateSwapchain();

    /**
        Called when the surface is requested to re-enumerate.

        This function should set all the relevant info
    */
    abstract void onRequestReenumerate();

    /**
        Set the minimum allowed extents
    */
    final
    void setMinExtents(vec2u minExtents) {
        this.minExtents = minExtents;
    }

    /**
        Set the maximum allowed extents
    */
    final
    void setMaxExtents(vec2u maxExtents) {
        this.maxExtents = maxExtents;
    }

    /**
        Sets the minimum number of frames that can be in-flight
        for the swapchain.
    */
    final
    void setMinimumInFlight(uint minImages) {
        if (minImages == 0)
            minImages = 1;
        
        this.minInFlight = minImages;
    }

    /**
        Sets the maximum number of frames that can be in-flight
        for the swapchain.
    */
    final
    void setMaximumInFlight(uint maxImages) {
        
        // 0 means "no limit" for Vulkan, so
        // just set it arbitrarily high.
        if (maxImages == 0)
            maxImages = uint.max;

        this.maxInFlight = maxImages;
    }

    /**
        Clips given extents to fit within the current minimum
        and maximum.
    */
    final
    vec2u clipExtents(vec2u size) {
        this.reenumerate();

        return vec2u(
            clamp(size.x, minExtents.x, maxExtents.x),
            clamp(size.y, minExtents.y, maxExtents.y)
        );
    }

    /**
        Clips the in-flight frames to be within the allowed range.
    */
    final
    uint clipInFlight(uint inFlight) {
        this.reenumerate();

        return clamp(inFlight, minInFlight, maxInFlight);
    }

public:

    ~this() {
        if (swapchain)
            nogc_delete(swapchain);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat, NuvkHandle surfaceHandle) {
        super(device);
        this.setHandle(surfaceHandle);
        this.reenumerate();

        this.setPresentationMode(presentMode);
        this.setFormat(textureFormat);
        this.setCompositeMode(NuvkSurfaceCompositeMode.opaque);
        this.setFramesInFlight(this.getMinimumInFlight);
    }

    /**
        Requests that the surface re-enumerates its properties.
    */
    final
    void reenumerate() {
        this.onRequestReenumerate();
    }

    /**
        Gets the amount of frames that the surface can have in-flight
    */
    final
    uint getFramesInFlight() {
        return framesInFlight;
    }

    /**
        Sets the amount of frames that the surface can have in-flight
    */
    final
    void setFramesInFlight(uint framesInFlight) {
        this.framesInFlight = this.clipInFlight(framesInFlight);
        this.notifyChanged();
    }

    /**
        Gets the composition mode of the surface
    */
    final
    NuvkSurfaceCompositeMode getCompositeMode() {
        return compositeMode;
    }

    /**
        Gets the composition mode of the surface
    */
    final
    void setCompositeMode(NuvkSurfaceCompositeMode compositeMode) {
        nuvkEnforce(
            isCompositeModeSupported(compositeMode),
            "Specified composition mode is not supported!"
        );

        this.compositeMode = compositeMode;
        this.notifyChanged();
    }

    /**
        Gets the presentation mode of the surface
    */
    final
    NuvkPresentMode getPresentationMode() {
        return presentMode;
    }

    /**
        Sets the presentation mode of the surface.

        This will invalidate the swapchain!
    */
    final
    void setPresentationMode(NuvkPresentMode presentMode) {
        nuvkEnforce(
            isPresentationModeSupported(presentMode),
            "Specified presentation mode not supported!"
        );

        this.presentMode = presentMode;
        this.notifyChanged();
    }

    /**
        Gets the presentation mode of the surface
    */
    final
    NuvkTextureFormat getFormat() {
        return textureFormat;
    }

    /**
        Sets the texture format of the surface.

        This will invalidate the swapchain!
    */
    final
    void setFormat(NuvkTextureFormat textureFormat) {
        nuvkEnforce(
            isFormatSupported(textureFormat),
            "Specified format not supported!"
        );

        this.textureFormat = textureFormat;
        this.notifyChanged();
    }

    /**
        Sets the size of the surface.

        This will invalidate the swapchain!
    */
    final
    void resize(vec2u size) {
        this.surfaceSize = this.clipExtents(size);
        this.notifyChanged();
    }

    /**
        Gets the size of the surface
    */
    final
    vec2u getSize() {
        return surfaceSize;
    }

    /**
        Gets the minimum size of swapchain textures
    */
    final
    vec2u getMinExtents() => this.minExtents;

    /**
        Gets the maximum size of swapchain textures
    */
    final
    vec2u getMaxExtents() => this.maxExtents;

    /**
        Gets the minimum number of frames that can be in-flight
        for the swapchain.
    */
    final
    uint getMinimumInFlight() => this.minInFlight;

    /**
        Gets the maximum number of frames that can be in-flight
        for the swapchain.
    */
    final
    uint getMaximumInFlight() => this.maxInFlight;

    /**
        Notify the surface that it has been changed.
        This should be called when the window is resized,
        or restored from a minimized state.

        This will invalidate the swapchain!
    */
    final
    void notifyChanged() {
        if (swapchain) {
            this.reenumerate();
            swapchain.recreate();
        }
    }

    /**
        Gets the swapchain for the surface
    */
    final
    NuvkSwapchain getSwapchain() {
        if (!swapchain)
            swapchain = this.onCreateSwapchain();
        
        return swapchain;
    }

    /**
        Gets whether it is possible to use the specified texture format.
    */
    abstract bool isFormatSupported(NuvkTextureFormat textureFormat);
    
    /**
        Gets whether it is possible to use the specified presentation mode.
    */
    abstract bool isPresentationModeSupported(NuvkPresentMode presentMode);

    /**
        Gets whether it is possible to use the specified composite mode.
    */
    abstract bool isCompositeModeSupported(NuvkSurfaceCompositeMode compositeMode);

    /**
        Gets whether it's possible to render to the surface in its
        current state. 
    */
    final
    bool isRenderCapable() {
        return 
            this.maxExtents.x > 0 && 
            this.maxExtents.y > 0;
    }

}

/**
    A swapchain containing images that can be rendered to.
*/
abstract
class NuvkSwapchain : NuvkDeviceObject {
@nogc:
private:
    NuvkSurface surface;
    NuvkFence frameAvailableFence;

    uint allocatedFrameCount;
protected:
    
    /**
        Updates the swapchain with new information from the
        surface.
    */
    final
    void recreate() {
        surface.reenumerate();
        this.onRecreate();
    }

    /**
        Resets the synchronization objects.
    */
    final
    void resetSyncObjects() {
        frameAvailableFence.reset();
    }

    /**
        Sets the maximum amount of frames in flight
    */
    final
    void setAllocatedFrameCount(uint allocatedFrameCount) {
        this.allocatedFrameCount = allocatedFrameCount;
    }

    /**
        Gets the next texture in the swapchain.

        This texture is owned by the swapchain, do not free it.
    */
    abstract NuvkTextureView onGetNext(ulong timeout = ulong.max);

    /**
        Called wheb the surface should be re-created.
    */
    abstract void onRecreate();

public:

    ~this() {
        nogc_delete(frameAvailableFence);
    }

    /**
        Constructor
    */
    this(NuvkSurface surface) {
        super(surface.getOwner());
        this.surface = surface;

        this.frameAvailableFence = surface.getOwner().createFence();
        frameAvailableFence.reset();

        this.recreate();
    }

    /**
        Gets the surface this swapchain is attached to.
    */
    final
    NuvkSurface getSurface() {
        return surface;
    }

    /**
        Gets the frame-available semaphore bound to this swapchain.
    */
    final
    NuvkFence getFrameAvailableFence() {
        return frameAvailableFence;
    }

    /**
        Gets the next texture in the swapchain.

        This texture is owned by the swapchain, do not free it.
    */
    final
    NuvkTextureView getNext(ulong timeout = ulong.max) {
        NuvkTextureView next = this.onGetNext(timeout);

        // Acquire the image, as it will be in an undefined state after
        // it has been acquired from the swapchain.
        if (next) 
            next.getTexture().acquire();
        
        return next;
    }

    /**
        Gets the current texture in the swapchain.

        This texture is owned by the swapchain, do not free it.
    */
    abstract NuvkTextureView getCurrent();

    /**
        Gets the amount of texture views that have been allocated
        for in-flight textures.
    */
    final
    uint getAllocatedFrameCount() => allocatedFrameCount;

    /**
        Gets the maximum number of frames that can be in-flight.
    */
    final
    uint getMaxFramesInFlight() => allocatedFrameCount > 0 ? allocatedFrameCount-1 : 0;
}

/**
    Presentation mode for the surface
*/
enum NuvkPresentMode {
    
    /**
        Frames are immediately submitted to the surface

        This may result in screen tearing    
    */
    immediate,

    /**
        Frames are buffered and submitted to the surface
        synchronized to the vertical blanking interval.
    */
    vsync,

    /**
        Frames are buffered and submitted to the surface
        synchronized to the vertical blanking interval,
        while allowing submission at higher rates.
    */
    tripleBuffered
}

/**
    Composition modes for the windowing system.
*/
enum NuvkSurfaceCompositeMode {

    /**
        Surface should be composited with no transparency.
    */
    opaque          = 0x01,

    /**
        Surface should be composited with premultipled alpha
    */
    preMultiplied   = 0x02,

    /**
        Surface should be composited with premultipled alpha
    */
    postMultiplied  = 0x04
}