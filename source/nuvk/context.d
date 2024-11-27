/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.context;
import nuvk;
import numem.all;

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
struct NuvkContextVkDescriptor {
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
        NuvkContextVkDescriptor vulkan;

        /**
            Information which can be passed to Metal
        */
        NuvkMtlContextDescriptor metal;
    }
}

/**
    Bitflag over every backend that nuvk supports.

    See [nuvkAvailableBackends].
*/
enum NuvkBackend {
    /// No backend
    none        = 0x00,

    /// Vulkan backend
    vulkan      = 0x01,

    /// Metal backend
    metal       = 0x02, 

    /// WebGPU backend
    webgpu      = 0x03,
}

/**
    Whether the Metal dependency is present.
*/
version(Have_metal_d) enum NuvkHasMetal = true;
else enum NuvkHasMetal = false;

version(Have_erupted) enum NuvkHasVulkan = true;
else enum NuvkHasVulkan = false;

/**
    All of the available backends of Nuvk on the current system.

    The available backends depends on the platform and which optional
    dependencies nuvk was compiled with.
*/
__gshared const(NuvkBackend) nuvkAvailableBackends = 
    (NuvkHasMetal ? NuvkBackend.metal : NuvkBackend.none) |
    (NuvkHasVulkan ? NuvkBackend.vulkan : NuvkBackend.none);

static if (!(NuvkHasMetal || NuvkHasVulkan))
    pragma(msg, "WARNING: No backends specfied for nuvk!");

static if (NuvkHasMetal)  import nuvk.metal.context;
static if (NuvkHasVulkan) import nuvk.vulkan.context;

/**
    Creates a context

    Returns null if context creation failed.
*/
NuvkContext nuvkCreateContext(NuvkContextDescriptor descriptor) @nogc {
    switch(descriptor.type) {
        case NuvkContextType.best:
            static if (NuvkHasMetal) {

                // First try metal
                descriptor.type = NuvkContextType.metal;
                descriptor.metal = NuvkMtlContextDescriptor.init;
                auto ctx = nuvkCreateContext(descriptor);
                if (ctx)
                    return ctx;
                
            }

            // Attempt vulkan
            descriptor.type = NuvkContextType.vulkan;
            descriptor.vulkan = NuvkContextVkDescriptor.init;
            return nuvkCreateContext(descriptor);

        case NuvkContextType.vulkan:
            static if (NuvkHasVulkan)
                return nogc_new!NuvkContextVk(descriptor);
            else
                return null;

        case NuvkContextType.metal:
            
            // Metal is only supported on apple devices.
            static if (NuvkHasMetal)
                return nogc_new!MTLNuvkContext(descriptor);
            else
                return null;

        default:
            return null;
    }
}