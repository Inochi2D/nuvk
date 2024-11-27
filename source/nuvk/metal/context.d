/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.metal.context;
import nuvk.context;
import nuvk;
static if (NuvkHasMetal):

import metal.mtldevice;
import foundation.collections.nsarray;
import numem.all;

import nuvk.metal.devinfo;
import nuvk.metal.device;

class MTLNuvkContext : NuvkContext {
@nogc:
private:
    NSArray!MTLDevice devices;

protected:

    /**
        Implements the device enumeration algorithm.

        This is automatically called.

        Any NuvkDeviceInfo instance which return `false` from
        `isDeviceSuitable` will be discarded.

        The function should move the "best suited" device to element 0.
    */
    override
    weak_vector!NuvkDeviceInfo onEnumerateDevices() {
        weak_vector!NuvkDeviceInfo infos;
        foreach(i; 0..devices.length) {
            infos ~= nogc_new!MTLNuvkDeviceInfo(devices[i]);
        }
        return infos;
    }

    /**
        Implements the context initialisation
    */
    override
    void onInitContext(NuvkContextDescriptor descriptor) {
        devices = MTLDevice.allDevices();
    }

    /**
        Implements the context cleanup
    */
    override
    void onCleanupContext() {
        devices.release();
    }

public:

    /**
        Constructor
    */
    this(NuvkContextDescriptor descriptor) {
        super(descriptor);
    }

    override
    NuvkDevice createDevice(NuvkDeviceInfo devInfo) {
        return null;
    }
}