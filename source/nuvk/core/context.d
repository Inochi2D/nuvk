/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.context;
import nuvk.core;
import numem.all;

import nuvk.core.vk.context;

/**
    The type of the context.
*/
enum NuvkContextType {

    /**
        Choose the best context type based on platform.
    */
    best,

    /**
        Nuvk is backed by Vulkan.
    */
    vulkan,
    
    /**
        Nuvk is backed by Metal.
    */
    metal
}

/**
    Information which can be passed to Vulkan
*/
struct NuvkVkContextDescriptor {
@nogc:
    weak_vector!(const(char)*) requiredExtensions;
}

/**
    Information which can be passed to Metal
*/
struct NuvkMtlContextDescriptor {
@nogc:
    // Nothing here yet :)
}

/**
    Information passed to a context on creation.

    This is context type specific.
*/
struct NuvkContextDescriptor {
@nogc:
    
    /**
        The type of context to request.
    */
    NuvkContextType type;

    union {

        /**
            Information which can be passed to Vulkan
        */
        NuvkVkContextDescriptor vulkan;

        /**
            Information which can be passed to Metal
        */
        NuvkMtlContextDescriptor metal;
    }
}

/**
    The root context of the rendering engine
*/
abstract
class NuvkContext : NuvkObject {
@nogc:
private:
    NuvkContextType contextType;
    vector!NuvkDeviceInfo deviceInfo;

    void enumerateDevices() {
        auto infos = this.onEnumerateDevices();
        foreach(i; 0..infos.size()) {

            // Handle invalid device.
            // We free it
            if (!infos[i].isDeviceSuitable()) {
                nogc_delete(infos[i]);
                continue;
            }

            // Remaining devices change ownership.
            // They are now fully owned by the context.
            deviceInfo ~= infos[i];
        }
    }

protected:

    /**
        Implements the device enumeration algorithm.

        This is automatically called.

        Any NuvkDeviceInfo instance which return `false` from
        `isDeviceSuitable` will be discarded.

        The function should move the "best suited" device to element 0.
    */
    abstract weak_vector!NuvkDeviceInfo onEnumerateDevices();

    /**
        Implements the context initialisation
    */
    abstract void onInitContext(NuvkContextDescriptor descriptor);

    /**
        Implements the context cleanup
    */
    abstract void onCleanupContext();

public:

    /**
        Destructor
    */
    ~this() {
        this.onCleanupContext();
        nogc_delete(deviceInfo);
    }

    /**
        Constructor
    */
    this(NuvkContextDescriptor descriptor) {
        this.contextType = descriptor.type;
        
        this.onInitContext(descriptor);
        this.enumerateDevices();
    }

    /**
        Gets information about the nuvk-capable devices on the system.
    */
    final
    NuvkDeviceInfo[] getDevices() {
        return deviceInfo[];
    }

    /**
        Gets information about the default device for the system.

        If no devices are suitable for nuvk, this returns null.
    */
    final
    NuvkDeviceInfo getDefaultDevice() {
        return deviceInfo.size() > 0 ? deviceInfo[0] : null;
    }

    /**
        Creates a device.
    */
    abstract NuvkDevice createDevice(NuvkDeviceInfo deviceChoice);

    /**
        Gets the type of the context created.
    */
    final
    NuvkContextType getContextType() {
        return contextType;
    }
}

/**
    Creates a context

    Returns null if context creation failed.
*/
NuvkContext nuvkCreateContext(NuvkContextDescriptor descriptor) @nogc {
    switch(descriptor.type) {
        case NuvkContextType.best:
            version(AppleOS) {

                // First try metal
                descriptor.type = NuvkContextType.metal;
                descriptor.metal = NuvkMtlContextDescriptor.init;
                auto ctx = nuvkCreateContext(descriptor);
                if (ctx)
                    return ctx;
                
            }

            // Attempt vulkan
            descriptor.type = NuvkContextType.vulkan;
            descriptor.vulkan = NuvkVkContextDescriptor.init;
            return nuvkCreateContext(descriptor);

        case NuvkContextType.vulkan:
            return nogc_new!NuvkVkContext(descriptor);

        case NuvkContextType.metal:
            
            // Metal is only supported on apple devices.
            version(AppleOS) 
                return nogc_new!NuvkMtlContext(descriptor);
            else
                return null;

        default:
            return null;
    }
}