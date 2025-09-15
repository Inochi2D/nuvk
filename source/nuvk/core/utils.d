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
import nuvk.core.eh;
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
    Gets whether the given type is a chainable vulkan struct.
*/
enum isVkChain(T) = 
    is(T == struct) &&
    is(typeof(T.tupleof[0]) : VkStructureType) && 
    is(typeof(T.tupleof[1]) : const(void)*);

/**
    A chain of vulkan structs.
*/
struct VkStructChain {
private:
@nogc:
    void[] data_;
    VkChainedStruct[] chain_;

public:

    // Destructor
    ~this() {
        this.clear();
    }

    /**
        Pointer to the chain.
    */
    @property VkBaseOutStructure* front() => data_.ptr ? cast(VkBaseOutStructure*)data_.ptr : null;

    /**
        Gets the last structure in the chain.
    */
    @property VkBaseOutStructure* back() => data_.ptr ? chain_[$-1].ptr : null;

    /**
        The amount of structs stored in the chain.
    */
    @property uint count() => cast(uint)chain_.length;

    /**
        The chain as a slice.
    */
    @property VkChainedStruct[] chain() => chain_;

    /**
        Tries to find the given structure within the chain.

        Params:
            type = The structure type to look for.
        
        Returns:
            The address of the in structure on success,
            $(D null) otherwise.
    */
    VkChainedStruct* find(VkStructureType type) {
        foreach(ref c; chain_) {
            if (c.ptr && c.ptr.sType == type)
                return &c;
        }
        return null;
    }

    /**
        Adds a struct to the chain.
    */
    void add(T)(T struct_) if (isVkChain!T) {
        size_t offset = data_.length;
        data_ = data_.nu_resize(data_.length+T.sizeof);

        chain_ = chain_.nu_resize(chain_.length+1);
        chain_[$-1].size = T.sizeof;
        chain_[$-1].ptr = cast(VkBaseOutStructure*)(data_.ptr+offset);

        *(cast(T*)chain_[$-1].ptr) = struct_;
    }

    /**
        Makes a new struct chain that consists of the combined
        elements of this chain and another.

        Params:
            other = The other struct chain to combine with.
        
        Returns:
            A new struct chain containing elements from both.
    */
    VkStructChain combined(ref VkStructChain other) {
        VkStructChain new_;

        // Copy over offsets; adjust the end by
        // the data length.
        new_.chain_ = nu_malloca!VkChainedStruct(chain_.length+other.chain_.length);
        new_.chain_[0..chain_.length] = chain_[0..$];
        new_.chain_[chain_.length..$] = other.chain_[0..$];
        
        // Then copy over the data, then readjust.
        new_.data_ = nu_malloca!ubyte(data_.length + other.data_.length);
        new_.data_[0..data_.length] = data_[0..$];
        new_.data_[data_.length..$] = other.data_[0..$];
        new_.readjust();
        return new_;
    }

    /**
        Re-adjusts the chain's members to have correct pNext pointers.

        Returns:
            This object.
    */
    auto ref readjust() {
        ptrdiff_t chainCount = cast(ptrdiff_t)chain_.length-1;
        if (chainCount < 0)
            return this;

        chain_[0].ptr = cast(VkBaseOutStructure*)data_.ptr;
        chain_[0].ptr.pNext = cast(VkBaseOutStructure*)(data_.ptr+chain_[0].size);
        foreach(i; 1..chainCount) {
            void* base = (cast(void*)chain_[i-1].ptr)+chain_[i].size;

            chain_[i].ptr = cast(VkBaseOutStructure*)base;
            chain_[i].ptr.pNext = cast(VkBaseOutStructure*)(base+chain_[i].size);
        }

        back.pNext = null;
        return this;
    }

    /**
        Makes a copy of the struct chain.
    */
    VkStructChain copy() {
        return VkStructChain(data_.nu_dup());
    }

    /**
        Takes ownership of the structure chain's memory,
        this will destroy the offset information related
        to the chain.

        Returns:
            Pointer to the internal struct chain.
    */
    void* take() {

        void* ptr = data_.ptr;
        nu_freea(chain_);
        nogc_zeroinit(data_);
        return ptr;
    }

    /**
        Clears the chain.
    */
    void clear() {
        nu_freea(data_);
        nu_freea(chain_);
    }
}

/**
    A chained structure stored in a VkStructChain
*/
struct VkChainedStruct {
    size_t size;
    VkBaseOutStructure* ptr;
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