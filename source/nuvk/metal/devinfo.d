/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.metal.devinfo;
import nuvk.context;
import nuvk;
static if (NuvkHasMetal):

import metal.mtldevice;
import foundation.collections.nsarray;
import numem.all;

/**
    Information about a device
*/
class MTLNuvkDeviceInfo : NuvkDeviceInfo {
@nogc:
private:
    
    nstring deviceName;
    bool isSupported;
    NuvkDeviceType deviceType;
    NuvkDeviceFeatures deviceFeatures;
    NuvkDeviceLimits deviceLimits;

    void enumerate(ref MTLDevice device) {

        // Query device support.
        isSupported = 
            device.supportsFamily(MTLGPUFamily.Metal3) && 
            !device.headless;

        // Don't bother with the rest if it's not supported.
        if (!isSupported)
            return;
        
        // Copy NSString name out of the device.
        auto nsname = device.name();
        deviceName = nsname.toString();
        nsname.release();

        // Determine device type.
        deviceType = 
            device.location == MTLDeviceLocation.BuiltIn ? 
            NuvkDeviceType.integratedGPU : 
            NuvkDeviceType.dedicatedGPU;


        // Determine device features.
        deviceFeatures = NuvkDeviceFeatures(
            customBorderColors: false,
            anisotropicFiltering: true,
            taskShaders: true,
            meshShaders: true,
            tileShading: device.readWriteTextureSupport >= MTLReadWriteTextureTier.Tier1,
            wideLines: false,
            largePoints: false,
            textureCompressionBC: device.supportsBCTextureCompression,
            textureCompressionETC2: true,
            textureCompressionASTC: true,
            raytracing: device.supportsRaytracing,
            hostMapBuffers: true,
            hostMapCoherent: device.hasUnifiedMemory,
            sharing: true
        );

        deviceLimits = NuvkDeviceLimits(
            maxTextureSize1D: uint.max, // TODO: Find these values out.
            maxTextureSize2D: uint.max,
            maxTextureSize3D: uint.max,
            maxTextureSizeCube: uint.max,
            maxFramebufferWidth: uint.max,
            maxFramebufferHeight: uint.max,
            maxColorAttachments: uint.max,
            maxAnisotropy: 16,
            maxLodBias: 1,
            maxShaderSamplers: uint.max,
            maxShaderUniformBuffers: uint.max,
            maxShaderStorageBuffers: uint.max,
            maxShaderTextures: uint.max,
            maxVertexAttributes: uint.max,
            maxVertexBindings: uint.max,
            maxVertexOffset: uint.max,
            maxVertexStride: uint.max,
            maxVertexOutputs: uint.max,
            maxFragmentInputs: uint.max,
            maxFragmentOutputs: uint.max,
            memoryAlignmentOptimal: 1,
            memoryAlignmentMinimum: 1,
        );
    }

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(deviceName);
    }

    /**
        Creates a device info from a metal device.
    */
    this(ref MTLDevice device) {
        this.enumerate(device);
    }

    /**
        Internal function used to discard
        devices which are not suitable for nuvk.
    */
    override
    bool isDeviceSuitable() {
        return isSupported;
    }

    /**
        Gets the name of the device
    */
    override
    string getDeviceName() {
        return deviceName.toString();
    }

    /**
        Gets the type of the device
    */
    override
    NuvkDeviceType getDeviceType() {
        return deviceType;
    }

    /**
        Gets the device's features
    */
    override
    NuvkDeviceFeatures getDeviceFeatures() {
        return deviceFeatures;
    }

    /**
        Gets the device's limits
    */
    override
    NuvkDeviceLimits getDeviceLimits() {
        return deviceLimits;
    }

    /**
        Gets information about the queues that can be
        instantiated by the device.
    */
    override
    NuvkQueueFamilyInfo[] getQueueFamilyInfos() {
        return [];
    }
}