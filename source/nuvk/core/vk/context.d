/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.context;
import nuvk.core.vk;
import nuvk.core;
import numem.all;


private {
    extern(System)
    VkBool32 nuvkVkDbgCallback(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageType, const VkDebugUtilsMessengerCallbackDataEXT* pCallbackData, void* pUserData) nothrow @nogc {
        import core.stdc.stdio : printf;
        printf("[Validation Layer] %s\n",pCallbackData.pMessage);
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

class NuvkVkDeviceInfo : NuvkDeviceInfo {
@nogc:
private:
    weak_vector!VkQueueFamilyProperties queueFamilyProperties;
    weak_vector!VkExtensionProperties extensionProperties;

    VkPhysicalDevice physicalDevice;
    VkPhysicalDeviceMemoryProperties physicalDeviceMemoryProperties;
    VkPhysicalDeviceProperties deviceProperties;

    NuvkDeviceType deviceType;
    nstring deviceName;

    void loadDeviceInformation(VkPhysicalDevice physicalDevice) {
        vkGetPhysicalDeviceProperties(physicalDevice, &deviceProperties);
        
        this.deviceName = nstring(deviceProperties.deviceName.ptr);
        switch(deviceProperties.deviceType) {
            default:
                this.deviceType = NuvkDeviceType.integratedGPU;
                break;
            
            case VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
                this.deviceType = NuvkDeviceType.dedicatedGPU;
                break;
        }

        vkGetPhysicalDeviceMemoryProperties(physicalDevice, &physicalDeviceMemoryProperties);
    }

    bool getIsDeviceSuitable() {

        // Vulkan 1.3 devices are required.
        if (deviceProperties.apiVersion < VK_VERSION_1_3)
            return false;

		foreach(size_t idx, VkQueueFamilyProperties queueProp; getQueueFamilyProperties()) {
			if (queueProp.queueFlags & VK_QUEUE_GRAPHICS_BIT) 
				return true;
		}

        return false;
    }

    /**
        Gets the memory index matching the requested flags and bit depth.
    */
    bool hasMemoryWithFlags(VkMemoryPropertyFlags flagsRequired) {
        foreach(idx, memoryType; this.getMemoryTypes()) {
            const(bool) hasRequiredFlags = 
                (memoryType.propertyFlags & flagsRequired) == flagsRequired;

            if (hasRequiredFlags)
                return true;
        }

        return false;
    }

    void initInfo() {
        
        // Queue Families
        {
            uint queueFamilyCount;
            vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, null);
            
            queueFamilyProperties = weak_vector!VkQueueFamilyProperties(queueFamilyCount);
            vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, queueFamilyProperties.data());
        }
    
        // Extension properties
        {
            uint deviceExtensionSupportCount;
            vkEnumerateDeviceExtensionProperties(physicalDevice, null, &deviceExtensionSupportCount, null);

            extensionProperties = weak_vector!VkExtensionProperties(deviceExtensionSupportCount);
            vkEnumerateDeviceExtensionProperties(physicalDevice, null, &deviceExtensionSupportCount, extensionProperties.data());   
        }
    }

public:
    
    /**
        Constructor
    */
    this(VkPhysicalDevice physicalDevice) {
        this.physicalDevice = physicalDevice;
        this.initInfo();
        this.loadDeviceInformation(physicalDevice);
        this.setHandle(physicalDevice);
    }

    /**
        Gets the name of the device
    */
    override
    string getDeviceName() {
        return cast(string)deviceName[];
    }

    /**
        Gets the type of the device
    */
    override
    NuvkDeviceType getDeviceType() {
        return deviceType;
    }

    /**
        Gets extension properties
    */
    VkExtensionProperties[] getExtenstionProperties() {
        return extensionProperties[];
    }

    /**
        Gets queue family properties
    */
    VkQueueFamilyProperties[] getQueueFamilyProperties() {
        return queueFamilyProperties[];
    }

    /**
        Gets the memory index matching the requested flags and bit depth.
    */
    int getMatchingMemoryIndex(uint bitsRequired, VkMemoryPropertyFlags flagsRequired) {
        foreach(idx, memoryType; this.getMemoryTypes()) {
            const(bool) isRequiredType = 
                (bitsRequired & (1 << idx)) != 0;
            
            const(bool) hasRequiredFlags = 
                (memoryType.propertyFlags & flagsRequired) == flagsRequired;

            if (isRequiredType && hasRequiredFlags)
                return cast(int)idx;
        }

        return -1;
    }

    /**
        Gets a list of memory types supported by the device.
    */
    VkMemoryType[] getMemoryTypes() {
        const(uint) memoryCount = physicalDeviceMemoryProperties.memoryTypeCount;
        return physicalDeviceMemoryProperties.memoryTypes[0..memoryCount];
    }

    /**
        Gets a list of memory types supported by the device.
    */
    VkMemoryHeap[] getMemoryHeaps() {
        const(uint) memoryCount = physicalDeviceMemoryProperties.memoryHeapCount;
        return physicalDeviceMemoryProperties.memoryHeaps[0..memoryCount];
    }

    /**
        Gets the index of the transfer queue
    */
    ptrdiff_t getTransferQueueFamily() {
        foreach(i, VkQueueFamilyProperties queue; queueFamilyProperties[]) {
            if (queue.queueFlags & VK_QUEUE_TRANSFER_BIT) {
                return i;
            }
        }
        return -1;
    }

    /**
        Gets the index of the graphics queue
    */
    ptrdiff_t getGraphicsQueueFamily() {
        foreach(i, VkQueueFamilyProperties queue; queueFamilyProperties[]) {
            if (queue.queueFlags & VK_QUEUE_GRAPHICS_BIT) {
                return i;
            }
        }
        return -1;
    }

    /**
        Gets the index of the graphics queue
    */
    ptrdiff_t getComputeQueueFamily() {
        foreach(i, VkQueueFamilyProperties queue; queueFamilyProperties[]) {
            if (queue.queueFlags & VK_QUEUE_COMPUTE_BIT) {
                return i;
            }
        }
        return -1;
    }

    /**
        Gets whether the device supports staging buffers.
    */
    override
    bool supportsStaging() {
        return hasMemoryWithFlags(VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT) >= 0;
    }
}

/**
    Gets all of the extensions available
*/
vector!VkExtensionProperties nuvkVkContextGetAllExtensions() @nogc {
    vector!VkExtensionProperties extensionProps;
    
    uint extensionCount;
    vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);

    extensionProps = vector!VkExtensionProperties(extensionCount);
    vkEnumerateInstanceExtensionProperties(null, &extensionCount, extensionProps.data());
    return extensionProps;
}

/**
    Gets all of the validation layers available
*/
vector!VkLayerProperties nuvkVkContextGetAllLayers() @nogc {
    vector!VkLayerProperties layerProps;
    
    uint layerCount;
    vkEnumerateInstanceLayerProperties(&layerCount, null);

    layerProps = vector!VkLayerProperties(layerCount);
    vkEnumerateInstanceLayerProperties(&layerCount, layerProps.data());
    return layerProps;
}
/**
    Vulkan implementation
*/
class NuvkVkContext : NuvkContext {
@nogc:
private:
    weak_vector!NuvkDeviceInfo devices;
    VkInstance instance;
    
    VkDebugUtilsMessengerEXT debugCallback;

    NuvkVkRequestList requestedExtensions;
    NuvkVkRequestList requestedLayers;

    void initInstanceInfo() {
        vector!VkExtensionProperties supportedExtensions
            = nuvkVkContextGetAllExtensions();
        vector!VkLayerProperties supportedLayers
            = nuvkVkContextGetAllLayers();

        vector!nstring supportedExtensionStrings;
        vector!nstring supportedLayerStrings;

        foreach(ref extension; supportedExtensions) {
            supportedExtensionStrings ~= nstring(extension.extensionName.ptr);
        }

        foreach(ref layer; supportedLayers) {
            supportedLayerStrings ~= nstring(layer.layerName.ptr);
        }

        requestedExtensions = NuvkVkRequestList(supportedExtensionStrings);
        requestedLayers = NuvkVkRequestList(supportedLayerStrings);
    }

    void createInstance(const(char)*[] requiredExtensions) {
        nuvkVkInitVulkan();
        this.initInstanceInfo();

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

            import core.stdc.stdio : printf;

            foreach(i, extension; requestedExtensions.getRequests()) {
                printf("[Nuvk::Vulkan] instance extension[%d] = %s\n", cast(uint)i, extension);
            }

            foreach(i, layer; requestedLayers.getRequests()) {
                printf("[Nuvk::Vulkan] instance layer[%d] = %s\n", cast(uint)i, layer);
            }
        }

        auto extensions = requestedExtensions.getRequests();
        auto layers = requestedLayers.getRequests();

        instanceCreateInfo.enabledExtensionCount = cast(uint)extensions.length;
        instanceCreateInfo.ppEnabledExtensionNames = extensions.ptr;
        instanceCreateInfo.enabledLayerCount = cast(uint)layers.length;
        instanceCreateInfo.ppEnabledLayerNames = layers.ptr;

        enforce(
            vkCreateInstance(&instanceCreateInfo, null, &instance) == VK_SUCCESS,
            nstring("Failed creating Vulkan Instance!")
        );

        this.setHandle(instance);
    }

    void setupDebugCallback() {
        debug {
            VkDebugUtilsMessengerCreateInfoEXT debugCallbackInfo;
            debugCallbackInfo.messageSeverity = 
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT;
            debugCallbackInfo.messageType = 
                VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
                VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;
            debugCallbackInfo.pfnUserCallback = &nuvkVkDbgCallback;
            enforce(
                vkCreateDebugUtilsMessengerEXT(instance, &debugCallbackInfo, null, &debugCallback) == VK_SUCCESS,
                nstring("Could not create debug messenger!")
            );
        }
    }

    void cleanupDebugCallback() {
        if (debugCallback != VK_NULL_HANDLE) {
            vkDestroyDebugUtilsMessengerEXT(instance, debugCallback, null);
        }
    }

    bool enumerateDevices() {
        uint deviceCount;

        if (vkEnumeratePhysicalDevices(instance, &deviceCount, null) != VK_SUCCESS)
            return false;
        
        auto devices = weak_vector!VkPhysicalDevice(deviceCount);
        if (vkEnumeratePhysicalDevices(instance, &deviceCount, devices.data())) 
            return false;

        // Iterate devices and add the ones which are suitable.
        if (deviceCount > 0) {
            foreach(device; devices) {
                auto device_ = nogc_new!(NuvkVkDeviceInfo)(device);

                if (device_.getIsDeviceSuitable())
                    this.devices ~= device_;
                else
                    nogc_delete(device_);
            }
        }
        
        return true;
    }

public:

    ~this() {
        cleanupDebugCallback();
    }

    this(const(char)*[] requiredExtensions) {
        this.createInstance(requiredExtensions);
        loadInstanceLevelFunctionsExt(instance);
        loadDeviceLevelFunctionsExt(instance);
        this.setupDebugCallback();
        
        enforce(enumerateDevices(), nstring("Failed to enumerate devices"));
    }

    /**
        Gets a list of information about devices which can be used for rendering.
    */
    override
    NuvkDeviceInfo[] getDevices() {
        return devices[];
    }

    /**
        Gets information about the default device for the system.
    */
    override
    NuvkDeviceInfo getDefaultDevice() {
        if (devices.size() == 0) 
            return null;
        return devices[0];
    }

    /**
        Creates a device.
    */
    override
    NuvkDevice createDevice(NuvkDeviceInfo deviceChoice) {
        
        // Don't allow null-device creation.
        if (deviceChoice is null)
            return null;

        return nogc_new!NuvkVkDevice(this, deviceChoice);
    }
}