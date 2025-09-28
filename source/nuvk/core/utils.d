/**
    NuVK Vulkan Utilities
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.core.utils;
import nuvk.core.chain;
import vulkan.eh;
import vulkan;
import numem;
import nulib;

/// Invalid structure type to use as sentinel.
enum VK_STRUCTURE_TYPE_SENTINEL = uint.max;

/**
    Gets all of the extension properties for the global 
    vulkan instance.
    
    Returns:
        A slice of all of the instance extension properties.
*/
VkExtensionProperties[] getInstanceExtensionProperties() @nogc nothrow {
    uint pCount;
    vkEnumerateInstanceExtensionProperties(null, &pCount, null);

    VkExtensionProperties[] props = nu_malloca!VkExtensionProperties(pCount);
    vkEnumerateInstanceExtensionProperties(null, &pCount, props.ptr);
    return props;
}

/**
    Gets all of the layer properties for the global 
    vulkan instance.
    
    Returns:
        A slice of all of the instance layer properties.
*/
VkLayerProperties[] getInstanceLayerProperties() @nogc {
    uint pCount;
    vkEnumerateInstanceLayerProperties(&pCount, null);

    VkLayerProperties[] props = nu_malloca!VkLayerProperties(pCount);
    vkEnumerateInstanceLayerProperties(&pCount, props.ptr);
    return props;
}

/**
    Gets all of the extension properties for the given physical
    device.

    Params:
        physicalDevice = The physical device to get the properties for.
    
    Returns:
        A slice of all of the device's extension properties.
*/
VkExtensionProperties[] getExtensionProperties(VkPhysicalDevice physicalDevice) @nogc nothrow {
    uint pCount;
    vkEnumerateDeviceExtensionProperties(physicalDevice, null, &pCount, null);

    VkExtensionProperties[] props = nu_malloca!VkExtensionProperties(pCount);
    vkEnumerateDeviceExtensionProperties(physicalDevice, null, &pCount, props.ptr);
    return props;
}

/**
    Gets all of the layer properties for the given physical
    device.

    Params:
        physicalDevice = The physical device to get the properties for.
    
    Returns:
        A slice of all of the device's layer properties.
*/
VkLayerProperties[] getLayerProperties(VkPhysicalDevice physicalDevice) @nogc {
    uint pCount;
    vkEnumerateDeviceLayerProperties(physicalDevice, &pCount, null);

    VkLayerProperties[] props = nu_malloca!VkLayerProperties(pCount);
    vkEnumerateDeviceLayerProperties(physicalDevice, &pCount, props.ptr);
    return props;
}

/**
    Gets whether the given extension is in the extension properties
    slice.

    Params:
        props =     The properties slice.
        extension = Name of the extension.
    
    Returns:
        $(D true) if the slice has the given extension,
        $(D false) otherwise.
*/
bool hasExtension(VkExtensionProperties[] props, string extension) @nogc {
    foreach(prop; props) {
        if (prop.extensionName.ptr.fromStringz == extension) {
            return true;
        }
    }
    return false;
}

/**
    Gets whether the given layer is in the layer properties
    slice.

    Params:
        props = The properties slice.
        layer = Name of the layer.
    
    Returns:
        $(D true) if the slice has the given layer,
        $(D false) otherwise.
*/
bool hasLayer(VkLayerProperties[] props, string layer) @nogc nothrow {
    foreach(prop; props) {
        if (prop.layerName.ptr.fromStringz == layer) {
            return true;
        }
    }
    return false;
}


/**
    Gets feature flags from a feature flag vulkan struct.

    Params:
        target = The target struct to get the feature flags from.
    
    Returns:
        A VkBool32 slice of all the feature flags of the structure
        if possible, $(D null) otherwise.
*/
VkBool32[] getFeatureFlags(VkChainedStruct target) @nogc {
    if (target.ptr is null)
        return [];

    size_t elements = (target.size - VkBaseOutStructure.sizeof) / VkBool32.sizeof;
    return (cast(VkBool32*)((cast(void*)target.ptr)+VkBaseOutStructure.sizeof))[0..elements];
}

/**
    Applies the given mask to the given chain.

    Params:
        target =    The right hand chain of requested features.
        mask =      The left hand chain of required features.

    Note:
        Both chains MUST end with a sentinel structure.
*/
void maskChain(ref VkStructChain target, ref VkStructChain mask) @nogc {
    foreach(tgt; target.chain) {
        VkBool32[] tgtFeatures = tgt.getFeatureFlags();
        if (auto msk = mask.find(tgt.ptr.sType)) {
            VkBool32[] mskFeatures = (*msk).getFeatureFlags();

            tgtFeatures[0..$] &= mskFeatures[0..$];
        } 
    }
}

/**
    Gets whether the left hand size structure is deemed compatible with
    the right hand side structure.

    Params:
        req =   The right hand chain of requested features.
        mask =  The left hand chain of required features.

    Returns:
        $(D true) if $(D rhs) enables features that are
        supported by $(D lhs), $(D false) otherwise.
*/
bool isFeaturesCompatible(ref VkStructChain req, ref VkStructChain mask) @nogc {
    foreach(tgt; req.chain) {
        VkBool32[] tgtFeatures = tgt.getFeatureFlags();
        if (auto msk = mask.find(tgt.ptr.sType)) {
            VkBool32[] mskFeatures = (*msk).getFeatureFlags();

            foreach(i; 0..tgtFeatures.length) {
                if ((tgtFeatures[i] & mskFeatures[i]) != tgtFeatures[i])
                    return false;
            }
        } 
    }
    return true;
}