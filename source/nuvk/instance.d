/**
    NuVK Instance
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.instance;
import nuvk.physicaldevice;
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

/**
    A vulkan instance
*/
struct Instance {
public:
@nogc:
    VkInstance ptr;
    alias ptr this;

    /**
        Constructs a Instance.

        Params:
            ptr = The pointer to the instance.
    */
    this(VkInstance ptr) {
        this.ptr = ptr;
    }

    /**
        Gets all of the physical devices for the given vulkan instance.
        
        Returns:
            A slice of all of the instance's devices.
    */
    PhysicalDevice[] getPhysicalDevices() {
        uint pCount;
        vkEnumeratePhysicalDevices(ptr, &pCount, null);

        PhysicalDevice[] devices = nu_malloca!PhysicalDevice(pCount);
        vkEnumeratePhysicalDevices(ptr, &pCount, cast(VkPhysicalDevice*)devices.ptr);
        return devices;
    }

    /**
        Destroys the instance.
    */
    void destroy() {
        vkDestroyInstance(ptr, null);
    }
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
        auto props = getInstanceLayerProperties();
        foreach(layer; layers) {
            if (!props.hasLayer(cast(string)layer.fromStringz)) {

                nu_freea(props);
                nstring errMsg = makeErrorMessage("Layer '%s' is not present or could not be loaded.", layer);
                throw nogc_new!VkException(VK_ERROR_LAYER_NOT_PRESENT, errMsg[], __FILE__, __LINE__);
            }
        }

        nu_freea(props);
    }

    void validateExtensions() {
        auto props = getInstanceExtensionProperties();
        foreach(extension; extensions) {
            if (!props.hasExtension(cast(string)extension.fromStringz)) {

                nu_freea(props);
                nstring errMsg = makeErrorMessage("Extension '%s' is not supported.", extension);
                throw nogc_new!VkException(VK_ERROR_EXTENSION_NOT_PRESENT, errMsg[], __FILE__, __LINE__);
            }
        }

        nu_freea(props);
    }

public:

    /**
        Begins building an instance.

        Returns:
            A new instance.
    */
    static InstanceBuilder begin() {
        return InstanceBuilder.init;
    }

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