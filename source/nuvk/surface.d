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
    NuvkSwapchain swapchain;
    NuvkPresentMode presentMode;
    NuvkTextureFormat textureFormat;
    vec2u surfaceSize;

    void updateSwapchainState(bool stateChanged = false) {
        if (!swapchain) 
            swapchain = this.onCreateSwapchain();
        else if (stateChanged)
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
        nuvkEnforce(
            isPresentModeValid(presentMode),
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
        Sets the presentation mode of the surface.

        This will invalidate the swapchain!
    */
    final
    void setFormat(NuvkTextureFormat textureFormat) {
        nuvkEnforce(
            isFormatValid(textureFormat),
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
        this.surfaceSize = size;
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
        Notify the surface that it has been changed.
        This should be called when the window is resized,
        or restored from a minimized state.

        This will invalidate the swapchain!
    */
    final
    void notifyChanged() {
        this.updateSwapchainState(true);
    }

    /**
        Gets the swapchain for the surface
    */
    final
    NuvkSwapchain getSwapchain() {
        this.updateSwapchainState();
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
    NuvkFence frameAvailableFence;

protected:
    
    /**
        Updates the swapchain with new information from the
        surface.
    */
    abstract void update(bool forceRecreate=false);

    /**
        Resets the synchronization objects.
    */
    final
    void resetSyncObjects() {
        frameAvailableFence.reset();
    }

    /**
        Gets the next texture in the swapchain.

        This texture is owned by the swapchain, do not free it.
    */
    abstract NuvkTextureView onGetNext(ulong timeout = ulong.max);

public:

    ~this() {
        nogc_delete(frameAvailableFence);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkSurface surface) {
        super(device);
        this.surface = surface;

        this.frameAvailableFence = device.createFence();
        frameAvailableFence.reset();
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