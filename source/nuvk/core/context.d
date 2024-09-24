module nuvk.core.context;
import nuvk.core;
import numem.all;

import nuvk.core.vk.context;

/**
    The type of the context.
*/
enum NuvkContextType {
    vulkan,
    metal
}

/**
    The type of a device.
*/
enum NuvkDeviceType {
    integratedGPU,
    dedicatedGPU
}

/**
    Information about a device
*/
abstract
class NuvkDeviceInfo : NuvkObject {
@nogc:
public:

    /**
        Gets the name of the device
    */
    abstract string getDeviceName();

    /**
        Gets the type of the device
    */
    abstract NuvkDeviceType getDeviceType();

    /**
        Gets whether the device supports staging buffers.
    */
    abstract bool supportsStaging();

}

/**
    The root context of the rendering engine
*/
abstract
class NuvkContext : NuvkObject {
@nogc:
public:

    /**
        Gets a list of devices which can be used for rendering.
    */
    abstract NuvkDeviceInfo[] getDevices();

    /**
        Gets the default device for the system.
    */
    abstract NuvkDeviceInfo getDefaultDevice();

    /**
        Creates a device.
    */
    abstract NuvkDevice createDevice(NuvkDeviceInfo deviceChoice);
}

/**
    Creates a context

    Returns null if context creation failed.
*/
NuvkContext nuvkCreateContext(NuvkContextType type, const(char)*[] requiredExtensions = null) {
    if (type == NuvkContextType.vulkan) {
        return nogc_new!NuvkVkContext(requiredExtensions);
    }

    return null;
}