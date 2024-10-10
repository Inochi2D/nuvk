/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.context;
import nuvk.core.vk.internal.utils;
import nuvk.core.vk;
import nuvk.core;
import numem.all;


private {
    extern(System)
    VkBool32 nuvkVkDbgCallback(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageType, const VkDebugUtilsMessengerCallbackDataEXT* pCallbackData, void* pUserData) nothrow @nogc {
        nuvkLogDebug("{0}", pCallbackData.pMessage);
        return VK_FALSE;
    }

    const string[] nuvkVkDebugLayers = [
        "VK_LAYER_KHRONOS_validation",
    ];

    const string[] nuvkVkInstanceRequiredExtensions = [
        "VK_KHR_surface",
        "VK_EXT_debug_utils",
        "VK_EXT_layer_settings",
    ];
}

/**
    Vulkan implementation
*/
class NuvkContextVk : NuvkContext {
@nogc:
private:
    weak_vector!NuvkDeviceInfo devices;
    VkInstance instance;
    
    VkDebugUtilsMessengerEXT debugCallback;

    NuvkVkRequestList requestedExtensions;
    NuvkVkRequestList requestedLayers;

    void enumerateLayers() {
        vector!nstring supportedLayerStrings;
        vector!VkLayerProperties supportedLayers = nuvkVkContextGetAllLayers();


        foreach(ref layer; supportedLayers) {
            supportedLayerStrings ~= nstring(layer.layerName.ptr);
        }

        requestedLayers = nogc_new!NuvkVkRequestList(supportedLayerStrings, "instance layers");
    }

    void enumerateExtensions() {
        vector!nstring supportedExtensionStrings;
        vector!VkExtensionProperties supportedExtensions = nuvkVkContextGetAllExtensions();

        foreach(ref extension; supportedExtensions) {
            supportedExtensionStrings ~= nstring(extension.extensionName.ptr);
        }

        requestedExtensions = nogc_new!NuvkVkRequestList(supportedExtensionStrings, "instance extensions");
    }
    
    void createInstance(const(char)*[] requiredExtensions) {

        VkApplicationInfo appInfo;
        appInfo.apiVersion = VK_API_VERSION_1_3;

        VkInstanceCreateInfo instanceCreateInfo;
        instanceCreateInfo.pApplicationInfo = &appInfo;

        // Extensions
        {
            foreach(requiredExtension; requiredExtensions) {
                requestedExtensions.add(cast(string)fromStringz(requiredExtension));
            }

            foreach(requiredExtension; nuvkVkInstanceRequiredExtensions) {
                requestedExtensions.add(requiredExtension);
            }
        }

        // Layers
        debug {
            foreach(debugLayer; nuvkVkDebugLayers) {
                requestedLayers.add(debugLayer);
            }
        }

        auto extensions = requestedExtensions.getRequests();
        auto layers = requestedLayers.getRequests();

        instanceCreateInfo.enabledExtensionCount = cast(uint)extensions.length;
        instanceCreateInfo.ppEnabledExtensionNames = extensions.ptr;
        instanceCreateInfo.enabledLayerCount = cast(uint)layers.length;
        instanceCreateInfo.ppEnabledLayerNames = layers.ptr;

        nuvkEnforce(
            vkCreateInstance(&instanceCreateInfo, null, &instance) == VK_SUCCESS,
            "Failed creating Vulkan Instance!"
        );

        this.setHandle(instance);
    }
    
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
        weak_vector!NuvkDeviceInfo deviceInfos;

        uint deviceCount;
        vkEnumeratePhysicalDevices(instance, &deviceCount, null);
        
        auto devices = weak_vector!VkPhysicalDevice(deviceCount);
        vkEnumeratePhysicalDevices(instance, &deviceCount, devices.data());

        foreach(device; devices) {
            deviceInfos ~= nogc_new!(NuvkDeviceVkInfo)(device);
        }

        return deviceInfos;
    }

    /**
        Implements the context initialisation
    */
    override
    void onInitContext(NuvkContextDescriptor descriptor) {
        nuvkInitVulkan();

        this.enumerateExtensions();
        this.enumerateLayers();
        this.createInstance(descriptor.vulkan.requiredExtensions[]);

        loadInstanceLevelFunctionsExt(instance);
        loadDeviceLevelFunctionsExt(instance);
        
        debug(validation) {
            VkDebugUtilsMessengerCreateInfoEXT debugCallbackInfo;
            debugCallbackInfo.messageSeverity = 
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT;
            debugCallbackInfo.messageType = 
                VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;
            debugCallbackInfo.pfnUserCallback = &nuvkVkDbgCallback;
            nuvkEnforce(
                vkCreateDebugUtilsMessengerEXT(instance, &debugCallbackInfo, null, &debugCallback) == VK_SUCCESS,
                nstring("Could not create debug messenger!")
            );
        }
    }

    /**
        Implements the context initialisation
    */
    override
    void onCleanupContext() {
        if (debugCallback != VK_NULL_HANDLE) {
            vkDestroyDebugUtilsMessengerEXT(instance, debugCallback, null);
        }

        nogc_delete(requestedExtensions);
        nogc_delete(requestedLayers);
    }

public:

    this(NuvkContextDescriptor descriptor) {
        super(descriptor);
    }

    /**
        Creates a device.
    */
    override
    NuvkDevice createDevice(NuvkDeviceInfo deviceChoice) {

        // Don't allow null-device creation.
        if (deviceChoice is null)
            return null;

        return nogc_new!NuvkDeviceVk(this, deviceChoice);
    }
}