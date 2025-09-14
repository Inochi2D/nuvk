/**
    NuVK Vulkan Utilities
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.utils;
import nuvk.eh;
import vulkan;
import numem;
import nulib;

/**
    Gets all of the extension properties for the
    global vulkan instance.
    
    Returns:
        A slice of all of the instance extension properties.
*/
VkExtensionProperties[] nuvkGetInstanceExtensionProperties() @nogc nothrow {
    uint pCount;
    vkEnumerateInstanceExtensionProperties(null, &pCount, null);

    VkExtensionProperties[] props = nu_malloca!VkExtensionProperties(pCount);
    vkEnumerateInstanceExtensionProperties(null, &pCount, props.ptr);
    return props;
}

/**
    Gets all of the layer properties for the
    global vulkan instance.
    
    Returns:
        A slice of all of the instance layer properties.
*/
VkLayerProperties[] nuvkGetInstanceLayerProperties() @nogc {
    uint pCount;
    vkEnumerateInstanceLayerProperties(&pCount, null);

    VkLayerProperties[] props = nu_malloca!VkLayerProperties(pCount);
    vkEnumerateInstanceLayerProperties(&pCount, props.ptr);
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
bool nuvkIsExtensionInPropertySlice(VkExtensionProperties[] props, string extension) @nogc {
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
bool nuvkIsLayerInPropertySlice(VkLayerProperties[] props, string layer) @nogc nothrow {
    foreach(prop; props) {
        if (prop.layerName.ptr.fromStringz == layer) {
            return true;
        }
    }
    return false;
}


/**
    Helps building Vulkan Instances.
*/
struct InstanceBuilder {
private:
@nogc:
    VkApplicationInfo appInfo;
    weak_vector!(const(char)*) layers;
    weak_vector!(const(char)*) extensions;

    void freeSelf() {
        if (appInfo.pApplicationName)
            nu_free(cast(void*)appInfo.pApplicationName);
        if (appInfo.pEngineName)
            nu_free(cast(void*)appInfo.pEngineName);

        foreach(layer; layers[])
            if (layer)
                nu_free(cast(void*)layer);
        
        foreach(extension; extensions[])
            if (extension)
                nu_free(cast(void*)extension);
        
        layers.clear();
        extensions.clear();
    }

    void validateLayers() {
        auto props = nuvkGetInstanceLayerProperties();
        foreach(layer; layers) {
            if (!nuvkIsLayerInPropertySlice(props, cast(string)layer.fromStringz)) {

                nu_freea(props);
                nstring errMsg = makeErrorMessage("Layer '%s' is not present or could not be loaded.", layer);
                throw nogc_new!VkException(VK_ERROR_LAYER_NOT_PRESENT, errMsg[], __FILE__, __LINE__);
            }
        }

        nu_freea(props);
    }

    void validateExtensions() {
        auto props = nuvkGetInstanceExtensionProperties();
        foreach(extension; extensions) {
            if (!nuvkIsExtensionInPropertySlice(props, cast(string)extension.fromStringz)) {

                nu_freea(props);
                nstring errMsg = makeErrorMessage("Extension '%s' is not supported.", extension);
                throw nogc_new!VkException(VK_ERROR_EXTENSION_NOT_PRESENT, errMsg[], __FILE__, __LINE__);
            }
        }

        nu_freea(props);
    }

public:

    /**
        Sets the application name.

        Params:
            value = The value to set.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder setAppName(string value) {
        if (appInfo.pApplicationName)
            nu_free(cast(void*)appInfo.pApplicationName);
        appInfo.pApplicationName = null;
        
        if (value.length > 0) {
            nstring str = value;
            appInfo.pApplicationName = str.take().ptr;
        }
        return this;
    }

    /**
        Sets the application version.

        Params:
            value = The value to set.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder setAppVersion(uint value) {
        appInfo.applicationVersion = value;
        return this;
    }

    /**
        Sets the engine version.

        Params:
            value = The value to set.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder setEngineVersion(uint value) {
        appInfo.engineVersion = value;
        return this;
    }

    /**
        Sets the Vulkan API version.

        Params:
            value = The value to set.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder setVulkanVersion(uint value) {
        appInfo.apiVersion = value;
        return this;
    }

    /**
        Sets the engine name.

        Params:
            value = The value to set.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder setEngineName(string value) {
        if (appInfo.pEngineName)
            nu_free(cast(void*)appInfo.pEngineName);
        appInfo.pEngineName = null;
        
        if (value.length > 0) {
            nstring str = value;
            appInfo.pEngineName = str.take().ptr;
        }
        return this;
    }

    /**
        Adds a layer to the instance

        Params:
            value = The layer to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addLayer(string value) {
        this.layers ~= nstring(value).take().ptr;
        return this;
    }

    /**
        Adds multiple layers to the instance

        Params:
            values = The layers to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addLayers(string[] values) {
        foreach(value; values) {
            this.layers ~= nstring(value).take().ptr;
        }
        return this;
    }

    /**
        Adds multiple layers to the instance

        Params:
            values = The layers to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addLayers(const(char)** values) {
        const(char)** v;
        while(v !is null) {
            this.layers ~= nstring(*v).take().ptr;
            v++;
        }
        return this;
    }

    /**
        Adds an extension to the instance

        Params:
            value = The extension to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addExtension(string value) {
        this.extensions ~= nstring(value).take().ptr;
        return this;
    }

    /**
        Adds multiple extensions to the instance

        Params:
            values = The extensions to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addExtensions(string[] values) {
        foreach(value; values) {
            this.extensions ~= nstring(value).take().ptr;
        }
        return this;
    }

    /**
        Adds multiple extensions to the instance

        Params:
            values = The extensions to add.
        
        Returns:
            This instance builder instance.
    */
    ref InstanceBuilder addExtensions(const(char)** values) {
        const(char)** v;
        while(v !is null) {
            this.extensions ~= nstring(*v).take().ptr;
            v++;
        }
        return this;
    }

    /**
        Builds a VkInstance from the builder.
    */
    VkInstance build() {
        VkInstance instance;
        auto createInfo = VkInstanceCreateInfo(
            pApplicationInfo: &appInfo,
            enabledLayerCount: cast(uint)layers.length,
            ppEnabledLayerNames: layers.ptr,
            enabledExtensionCount: cast(uint)extensions.length,
            ppEnabledExtensionNames: extensions.ptr,
        );

        this.validateLayers();
        this.validateExtensions();

        vkEnforce(vkCreateInstance(&createInfo, null, instance));
        this.freeSelf();
        return instance;
    }
}

/**
    Gets whether the given type is a chainable vulkan struct.
*/
enum isVkChain(T) = 
    is(T == struct) &&
    is(typeof(T.tupleof[0]) : VkStructureType) && 
    is(typeof(T.tupleof[1]) : const(void)*);

/**
    A class which helps building feature chains.
*/
final
class ChainBuilder : NuObject {
private:
@nogc:
    void[] data_;
    vector!ChainInfo elements;
    
    static
    struct ChainInfo {
        VkStructureType sType;
        size_t offset;
        size_t size;
    }

    static
    struct VkStruct {
        VkStructureType sType;
        const(void)* pNext;
    }
    
    // Allocates space for the given struct.
    T* allocate(T)() {
        this.elements ~= ChainInfo(T.init.sType, data_.length, T.sizeof);
        this.data_ = data_.nu_resize(data_.length+elements[$-1].size);
        return cast(T*)(data_.ptr+elements[$-1].offset);
    }

    // Finds the requested struct.
    T* find(T)() {
        foreach(i; 0..elements.length)
            if (elements[i].sType == T.init.sType)
                return cast(T*)(data_.ptr + elements[i].offset);

        return this.allocate!T;
    }

    // Finalizes all of the chain by pointing the pNext to the next
    // struct.
    void finalize() {
        if (elements.length < 2)
            return;

        import std.stdio : printf;

        foreach(i; 0..cast(ptrdiff_t)elements.length-1) {
            VkStruct* ptr = cast(VkStruct*)(data_.ptr+elements[i].offset);
            ptr.pNext = data_.ptr+elements[i].size;
        }
    }

public:

    /**
        Creates a new chain builder.

        Returns:
            A new $(D ChainBuilder) instance.
    */
    static ChainBuilder create() {
        return nogc_new!ChainBuilder();
    }

    /**
        Whether the chain is empty.
    */
    @property bool empty() => data_.length == 0;

    // Destructor
    ~this() {
        this.clear();
    }

    /**
        Adds a feature struct in the chain,
        if the given struct is already present, sets
        the current instance instead.
    
        Params:
            struct_ = The structure to set in the chain.
        
        Returns:
            The $(D FeaturesChain) instance that the function
            was called on.
    */
    ChainBuilder add(T)(T struct_) if (isVkChain!T) {
        T* toSet = this.find!T;
        *toSet = struct_; 
        return this;
    }

    /**
        Gets whether the given struct is present in the chain.

        Returns:
            $(D true) if the given struct is in the chain,
            $(D false) otherwise.
    */
    bool has(T)() if (isVkChain!T) {
        foreach(i; 0..elements.length)
            if (elements[i].sType == T.init.sType)
                return true;
        
        return false;
    }

    /**
        Gets whether the given struct type id is present 
        in the chain.

        Params:
            type = The structure type ID to query.

        Returns:
            $(D true) if the given struct is in the chain,
            $(D false) otherwise.
    */
    bool has(VkStructureType type) {
        foreach(i; 0..elements.length)
            if (elements[i].sType == type)
                return true;
        
        return false;
    }

    /**
        Finalizes the feature chain and gets the result.

        This result has to be cast to the needed type by yourself.

        Returns:
            A pointer to the first vulkan struct in the chain,
            $(D null) if the chain is empty.
    */
    void* get() {
        this.finalize();
        return data_.length > 0 ? data_.ptr : null;
    }

    /**
        Clears all elements from the chain.
    */
    void clear() {
        elements.clear();
        nu_freea(data_);
    }

    /**
        Frees this chain.
    */
    void free() {
        auto self = this;
        nogc_delete(self);
    }
}