/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.surface;
import nuvk.core;
import numem.all;

/**
    A surface that can be rendered to
*/
abstract
class NuvkSurface : NuvkDeviceObject {
@nogc:
private:
    weak_vector!NuvkSwapchain swapchains;

protected:

    /**
        Gets a list of swapchains bound to this surface
    */
    final
    NuvkSwapchain[] getSwapchains() {
        return swapchains[];
    }

    /**
        Creates a swapchain that can be rendered with
    */
    abstract NuvkSwapchain onCreateSwapchain();

    /**
        Updates all outdated swapchains
    */
    final
    void updateSwapchains() {
        foreach(swapchain; this.getSwapchains()) {
            if (swapchain.isSwapchainOutdated()) {
                swapchain.update();
            }
        }
    }


public:
    this(NuvkDevice device) {
        super(device, NuvkProcessSharing.processLocal);
    }

    /**
        Creates a swapchain that can be rendered with
    */
    final
    NuvkSwapchain createSwapchain() {
        NuvkSwapchain swapchain = this.onCreateSwapchain();
        if (swapchain) 
            swapchains ~= swapchain;
        
        return swapchain;
    }

    /**
        Updates the surface
    */
    abstract void update();
}

/**
    A swapchain containing images that can be rendered to.
*/
abstract
class NuvkSwapchain : NuvkDeviceObject {
@nogc:
private:
    NuvkSurface surface;

protected:
    
    /**
        Updates the swapchain with new information from the
        surface.
    */
    abstract void update();

public:

    ~this() {
        foreach(i; 0..surface.swapchains.size()) {
            if (surface.swapchains[i] is this) {
                surface.swapchains.remove(i);
                break;
            }
        }
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkSurface surface) {
        super(device, NuvkProcessSharing.processLocal);
        this.surface = surface;
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
}