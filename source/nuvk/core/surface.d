/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.surface;
import nuvk.core;
import numem.all;

import inmath;

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
    A surface that can be rendered to
*/
abstract
class NuvkSurface : NuvkDeviceObject {
@nogc:
private:
    NuvkSwapchain swapchain;
    NuvkPresentMode presentMode;
    NuvkTextureFormat textureFormat;
    vec2i surfaceSize;

    void updateSwapchainState(bool parentChanged = false) {
        if (!swapchain)
            swapchain = this.onCreateSwapchain();

        if (parentChanged || swapchain.isSwapchainOutdated())
            swapchain.update();
    }

protected:

    /**
        Creates a swapchain that can be rendered with
    */
    abstract NuvkSwapchain onCreateSwapchain();

    /**
        Gets whether it is possible to use the specified texture format.
    */
    abstract bool isFormatValid(NuvkTextureFormat textureFormat);
    
    /**
        Gets whether it is possible to use the specified presentation mode.
    */
    abstract bool isPresentModeValid(NuvkPresentMode presentMode);

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkPresentMode presentMode, NuvkTextureFormat textureFormat) {
        super(device);
        this.presentMode = presentMode;
        this.textureFormat = textureFormat;
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
        enforce(
            isPresentModeValid(presentMode),
            nstring("Specified presentation mode not supported!")
        );

        this.presentMode = presentMode;
        this.updateSwapchainState(true);
    }

    /**
        Gets the presentation mode of the surface
    */
    final
    NuvkTextureFormat getFormat() {
        return textureFormat;
    }

    /**
        Sets the presentation mode of the surface.

        This will invalidate the swapchain!
    */
    final
    void setFormat(NuvkTextureFormat textureFormat) {
        enforce(
            isFormatValid(textureFormat),
            nstring("Specified format not supported!")
        );

        this.textureFormat = textureFormat;
        this.updateSwapchainState(true);
    }

    /**
        Gets the swapchain for the surface
    */
    final
    NuvkSwapchain getSwapchain() {
        this.updateSwapchainState(true);
        return swapchain;
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
    NuvkSemaphore frameAvailable;

protected:
    
    /**
        Updates the swapchain with new information from the
        surface.
    */
    abstract void update();

public:

    ~this() {
        nogc_delete(frameAvailable);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkSurface surface) {
        super(device);
        this.surface = surface;
        this.frameAvailable = device.createSemaphore();
    }

    /**
        Whether the swapchain is outdated.
    */
    abstract bool isSwapchainOutdated();

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
    NuvkSemaphore getFrameAvailableSemaphore() {
        return frameAvailable;
    }

    /**
        Gets the next texture in the swapchain.

        This texture is owned by the swapchain, do not free it.
    */
    abstract NuvkTextureView getNext();
}