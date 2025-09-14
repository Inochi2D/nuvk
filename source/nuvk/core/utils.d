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

    // Helper which readjusts the data array from
    // an old target memory location to a new one.
    void readjust(void* src, void* tgt, ptrdiff_t offset = 0) {
        VkBaseOutStructure* next = cast(VkBaseOutStructure*)tgt;
        while(next) {
            if (!next.pNext)
                break;

            next.pNext = cast(VkBaseOutStructure*)((tgt+offset)+(cast(void*)next.pNext-src));
            next = cast(VkBaseOutStructure*)next.pNext;
        }
    }

public:

    // Destructor
    ~this() {
        nu_freea(data_);
    }

    /**
        Pointer to the chain.
    */
    @property VkBaseOutStructure* front() => cast(VkBaseOutStructure*)data_.ptr;

    /**
        Gets the last structure in the chain.
    */
    @property VkBaseOutStructure* back() {
        VkBaseOutStructure* next = front;
        while(next.pNext) {

            // Skip sentinel value.
            if (next.pNext.sType == VK_STRUCTURE_TYPE_SENTINEL)
                break;

            next = cast(VkBaseOutStructure*)next.pNext;
        }
        return next;
    }

    /**
        Pointer to the sentinel value.
    */
    @property VkBaseOutStructure* sentinel() => cast(VkBaseOutStructure*)(data_.ptr+(data_.length-VkBaseOutStructure.sizeof));

    /**
        Tries to find the given structure within the chain.

        Params:
            type = The structure type to look for.
        
        Returns:
            The address of the in structure on success,
            $(D null) otherwise.
    */
    VkBaseOutStructure* find(VkStructureType type) {
        VkBaseOutStructure* next = front;
        while(next.pNext) {
            if (next.sType == type)
                return next;

            next = cast(VkBaseOutStructure*)next.pNext;
        }
        return null;
    }

    /**
        Resizes the struct chain while updating all the pointers
        to point be based off their new base address.
    */
    void resize(size_t newSize) {
        ptrdiff_t sizeDelta = cast(ptrdiff_t)newSize-cast(ptrdiff_t)data_.length;
        if (sizeDelta > 0) {

            void* oldptr = data_.ptr;
            data_ = data_.nu_resize(newSize+VkBaseOutStructure.sizeof);
            this.readjust(data_.ptr, oldptr);

            // Zero fill end of resized array.
            (cast(ubyte[])data_)[$-sizeDelta..$] = 0;

            // Set sentinel type to 0xFFFFFFFF
            VkBaseOutStructure* sentinel = cast(VkBaseOutStructure*)(data_.ptr+(data_.length-VkBaseOutStructure.sizeof));
            sentinel.sType = VK_STRUCTURE_TYPE_SENTINEL;
        }
    }

    /**
        Adds a struct to the chain.
    */
    void add(T)(T struct_) if (isVkChain!T) {
        this.resize(data_.length+T.sizeof);

        // Update the "next" pointer.
        auto dest = cast(T*)back.pNext;
        struct_.pNext = this.sentinel;
        *dest = struct_;
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
        ptrdiff_t splitIdx = cast(ptrdiff_t)data_.length-cast(ptrdiff_t)VkBaseOutStructure.sizeof;
        if (splitIdx > 0) {
            new_.data_ = nu_malloc(data_.length + other.data_.length)[0..data_.length + other.data_.length];
            new_.data_[0..splitIdx] = data_[0..splitIdx];
            new_.data_[splitIdx..splitIdx+other.data_.length] = other.data_[0..$];
            this.readjust(other.data_.ptr, new_.data_.ptr+splitIdx, -splitIdx);
            this.readjust(data_.ptr, new_.data_.ptr);
        }
        return new_;
    }

    /**
        Makes a copy of the struct chain.
    */
    VkStructChain copy() {
        void[] cpdata_ = data_.nu_dup();
        this.readjust(cpdata_.ptr, data_.ptr);
        return VkStructChain(cpdata_);
    }

    /**
        Takes ownership of the structure chain's memory.
    */
    void* take() {
        this.finalize();

        void* ptr = cast(void*)this.front;
        nogc_zeroinit(data_);
        return ptr;
    }

    /**
        Finalizes the struct chain, removing the sentinel
        value from the chain.
    */
    void finalize() {
        back.pNext = null;
    }

    /**
        Clears the chain.
    */
    void clear() {
        nu_freea(data_);
    }
}

/**
    Finds the given structue type in the given chain.

    Params:
        chain = The chain to look within.
        type =  The type to look for.
    
    Returns:
        A pointer to the structure within the chain if found,
        $(D null) otherwise.
*/
VkBaseOutStructure* findInChain(VkBaseOutStructure* chain, VkStructureType type) @nogc {
    while(chain) {
        if (chain.sType == type)
            return chain;

        chain = chain.pNext;
    }
    return null;
}

/**
    Gets feature flags from a feature flag vulkan struct.

    Params:
        target = The target struct to get the feature flags from.
    
    Returns:
        A VkBool32 slice of all the feature flags of the structure
        if possible, $(D null) otherwise.
*/
VkBool32[] getFeatureFlags(VkBaseOutStructure* target) @nogc {
    
    // sentinel value.
    if (target.sType == VK_STRUCTURE_TYPE_SENTINEL)
        return null;

    void* ptr = cast(void*)target;
    void* nptr = cast(void*)target.pNext;
    ptrdiff_t elements = ((nptr-ptr)-VkBaseOutStructure.sizeof)/VkBool32.sizeof;
    if (elements <= 0)
        return null;
    
    return (cast(VkBool32*)(ptr+VkBaseOutStructure.sizeof))[0..elements];
}

/**
    Applies the given mask to the given chain.

    Params:
        target =    The right hand chain of requested features.
        mask =      The left hand chain of required features.

    Note:
        Both chains MUST end with a sentinel structure.
*/
void maskChain(VkBaseOutStructure* target, VkBaseOutStructure* mask) @nogc {
    while(target) {

        // Skip sentinel value.
        if (target.sType == VK_STRUCTURE_TYPE_SENTINEL)
            break;

        VkBool32[] tgtFeatures = target.getFeatureFlags();

        if (VkBaseOutStructure* imask = mask.findInChain(target.sType)) {
            VkBool32[] maskFeatures = imask.getFeatureFlags();

            // Mismatched sizes?
            if (tgtFeatures.length != maskFeatures.length)
                return;

            tgtFeatures[0..$] &= maskFeatures[0..$];
        }
        target = target.pNext;
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
bool isFeaturesCompatible(VkBaseOutStructure* req, VkBaseOutStructure* mask) @nogc {
    while(req) {

        // Skip sentinel value.
        if (req.sType == VK_STRUCTURE_TYPE_SENTINEL)
            break;

        VkBool32[] reqFeatures = req.getFeatureFlags();
        if (VkBaseOutStructure* imask = mask.findInChain(req.sType)) {
            VkBool32[] maskFeatures = imask.getFeatureFlags();

            // Mismatched sizes?
            if (reqFeatures.length != maskFeatures.length)
                return false;

            foreach(i; 0..reqFeatures.length) {
                if ((reqFeatures[i] & maskFeatures[i]) != reqFeatures[i])
                    return false;
            }
        }
    }
    return true;
}