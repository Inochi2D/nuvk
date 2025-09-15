/**
    Physical Devices
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.physicaldevice;
import nuvk.device;
import nuvk.core;
import vulkan.khr_surface;
import vulkan.core;
import numem;
import nulib;
import nuvk.instance;

/**
    A wrapped VkPhysicalDevice.
*/
struct NuvkPhysicalDevice {
public:
@nogc:
    VkPhysicalDevice ptr;
    alias ptr this;

    /**
        Constructs a PhysicalDevice.

        Params:
            ptr = The pointer to the physical device.
    */
    this(VkPhysicalDevice ptr) {
        this.ptr = ptr;
    }

    /**
        Gets the features of the device.

        Returns:
            VkPhysicalDeviceFeatures2 enumerating features
            of the device.
    */
    VkPhysicalDeviceFeatures2 getFeatures() {
        VkPhysicalDeviceFeatures2 result_;
        vkGetPhysicalDeviceFeatures2(ptr, &result_);
        return result_;
    }

    /**
        Gets the properties of the device.

        Returns:
            VkPhysicalDeviceProperties2 enumerating properties
            of the device.
    */
    VkPhysicalDeviceProperties2 getProperties() {
        VkPhysicalDeviceProperties2 result_;
        vkGetPhysicalDeviceProperties2(ptr, &result_);
        return result_;
    }

    /**
        Gets the properties of the given format.

        Params:
            format = The format to get properties about.
        
        Returns:
            A VkFormatProperties describing the properties
            of the format.
    */
    VkFormatProperties getFormatProperties(VkFormat format) {
        VkFormatProperties props;
        vkGetPhysicalDeviceFormatProperties(ptr, format, &props);
        return props;
    }

    /**
        Gets the memory properties of the physical device.
        
        Returns:
            A VkPhysicalDeviceMemoryProperties2 describing the 
            memory properties of the physical device.
    */
    VkPhysicalDeviceMemoryProperties2 getMemoryProperties() {
        VkPhysicalDeviceMemoryProperties2 props;
        vkGetPhysicalDeviceMemoryProperties2(ptr, &props);
        return props;
    }

    /**
        Gets the list of queue family properties for the physical
        device.
        
        Returns:
            A slice of VkQueueFamilyProperties2 describing the
            different queues supported by the physical device.
    */
    VkQueueFamilyProperties2[] getDeviceQueueFamilyProperties() {
        uint pCount;
        vkGetPhysicalDeviceQueueFamilyProperties2(ptr, &pCount, null);

        VkQueueFamilyProperties2[] props = nu_malloca!VkQueueFamilyProperties2(pCount);
        vkGetPhysicalDeviceQueueFamilyProperties2(ptr, &pCount, props.ptr);
        return props;
    }

    /**
        Creates a device from this Physical Device.

        Params:
            createInfo =    Info used to create the device.
        
        Returns:
            A newly allocated device.
    */
    NuvkDevice createDevice(VkDeviceCreateInfo createInfo) {
        VkDevice result_;
        vkEnforce(vkCreateDevice(ptr, &createInfo, null, &result_));
        return nogc_new!NuvkDevice(result_, this, createInfo);
    }
}

/**
    Helps selecting a physical device.
*/
struct PhysicalDeviceSelector {
private:
@nogc:
    NuvkInstance instance;
    uint minimumVersion;
    VkStructChain requiredFeatures;
    VkStructChain optionalFeatures;
    vector!(const(char)*) extensions;
    VkFlags queueTypes;
    VkSurfaceKHR surface;

public:

    /// Destructor
    ~this() {
        requiredFeatures.clear();
        optionalFeatures.clear();
        nogc_delete(extensions);
    }

    /**
        Constructs a DeviceSelector.
    */
    this(NuvkInstance instance) {
        this.instance = instance;
        this.requiredFeatures.add!VkPhysicalDeviceFeatures2(VkPhysicalDeviceFeatures2());
        this.optionalFeatures.add!VkPhysicalDeviceFeatures2(VkPhysicalDeviceFeatures2());
    }
        
    /**
        Sets the queue types that are wanted.
    */
    auto ref setQueueTypes(VkFlags types) {
        this.queueTypes = types;
        return this;
    }

    /**
        Sets the surface of the device.

        Params:
            surface = The surface to set.
    */
    auto ref setSurface(VkSurfaceKHR surface) {
        this.surface = surface;
        return this;
    }

    /**
        Sets the minimum Vulkan Core version to be used.

        Params:
            major = Major version
            minor = Minor version
    */
    auto ref setMinimumVersion(uint major, uint minor) {
        this.minimumVersion = (major << 22U) | (minor << 12U);
        return this;
    }

    /**
        Sets the minimum Vulkan Core version to be used.

        Params:
            version_ = A version build with VK_MAKE_API_VERSION
    */
    auto ref setMinimumVersion(uint version_) {
        this.minimumVersion = version_;
        return this;
    }

    /**
        Adds the given features to the device as required
        features.

        Params:
            features = The features to add.
    */
    auto ref addRequiredFeatures(T)(T features) if (isVkChain!T) {
        if (auto st = requiredFeatures.find(features.sType)) {
            *cast(T*)st.ptr = features;
            requiredFeatures.readjust();
            return this;
        }

        requiredFeatures.add!T(features);
        return this;
    }

    /**
        Adds the given features to the device as optional
        features.

        Params:
            features = The features to add.
    */
    auto ref addOptionalFeatures(T)(T features) if (isVkChain!T) {
        if (auto st = optionalFeatures.find(features.sType)) {
            *cast(T*)st.ptr = features;
            optionalFeatures.readjust();
            return this;
        }

        optionalFeatures.add!T(features);
        return this;
    }

    /**
        Adds the given extension to the device as an required
        extension.

        Params:
            extName = Name of the extension.
    */
    auto ref addRequiredExtension(string extName) {
        extensions ~= nstring(extName).take().ptr;
        return this;
    }

    /**
        Selects the best Physical Device and Device
        from the given options.
    */
    PhysicalDeviceSelection select() {
        PhysicalDeviceSelection result;
        auto physicalDevices = instance.getPhysicalDevices();

        // Just to ensure we can get them no matter what.
        VK_KHR_surface surfaceProcs;
        instance.loadProcs(surfaceProcs);

        if (surface)
            queueTypes |= VK_QUEUE_GRAPHICS_BIT;

        vector!VkDeviceQueueCreateInfo queuesToCreate;
        auto reqFeatures = requiredFeatures.copy();
        auto optFeatures = optionalFeatures.copy();
        outer: foreach(physicalDevice; physicalDevices) {
            bool isSurfaceSupported = surface ? false : true;
            bool hasRequiredQueues = false;
            bool hasRequiredFeatures = false;

            // Skip devices which doesn't support the requested version.
            VkPhysicalDeviceProperties2 props = physicalDevice.getProperties();
            if (props.properties.apiVersion < minimumVersion)
                continue;
                

            vkGetPhysicalDeviceFeatures2(physicalDevice, cast(VkPhysicalDeviceFeatures2*)reqFeatures.front);
            vkGetPhysicalDeviceFeatures2(physicalDevice, cast(VkPhysicalDeviceFeatures2*)optFeatures.front);
            
            hasRequiredFeatures = requiredFeatures.isFeaturesCompatible(reqFeatures);

            // Queues
            queuesToCreate.clear();
            VkQueueFamilyProperties2[] queues = physicalDevice.getDeviceQueueFamilyProperties();
            foreach(i, queue; queues) {
                if ((queue.queueFamilyProperties.queueFlags & queueTypes) > 0) {
                    queuesToCreate ~= VkDeviceQueueCreateInfo(
                        queueFamilyIndex: cast(uint)i,
                        queueCount: 1
                    );
                }
            }
            hasRequiredQueues = queuesToCreate.length > 0;
            nu_freea(queues);

            // Surface
            if (surface) {
                foreach(qi; 0..queues.length) {
                    uint supported;
                    surfaceProcs.vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, cast(uint)qi, surface, &supported);

                    if (supported) {
                        isSurfaceSupported = true;
                        break;
                    }
                }
            }

            if (isSurfaceSupported && hasRequiredQueues && hasRequiredFeatures) {
                optionalFeatures.maskChain(optFeatures);
                auto chain = requiredFeatures.combined(optionalFeatures);

                result.physicalDevice = physicalDevice;
                result.features = cast(VkPhysicalDeviceFeatures2*)chain.take();
                result.queuesToCreate = queuesToCreate.take();
                result.enabledExtensions = extensions.take();
                break outer; 
            }
        }

        reqFeatures.clear();
        optFeatures.clear();
        nu_freea(physicalDevices);
        return result;
    }
}

/**
    The selection result of a device selector
*/
struct PhysicalDeviceSelection {
public:
@nogc:

    /**
        The selected physical device
    */
    NuvkPhysicalDevice physicalDevice;

    /**
        The enabled features
    */
    VkPhysicalDeviceFeatures2* features;

    /**
        The selected families
    */
    VkDeviceQueueCreateInfo[] queuesToCreate;

    /**
        Enabled extensions
    */
    const(char)*[] enabledExtensions;

    /**
        Creates a device from this selection.

        This will free the meta-data about the selection,
        leaving behind the physicalDevice.
    */
    NuvkDevice createDevice() {
        if (!physicalDevice)
            return null;

        auto device = physicalDevice.createDevice(VkDeviceCreateInfo(
            pNext: features,
            queueCreateInfoCount: cast(uint)queuesToCreate.length,
            pQueueCreateInfos: queuesToCreate.ptr,
            enabledExtensionCount: cast(uint)enabledExtensions.length,
            ppEnabledExtensionNames: enabledExtensions.ptr
        ));

        // Free all the temporary data.
        nu_free(cast(void*)features);
        nu_freea(queuesToCreate);
        foreach(i; 0..enabledExtensions.length)
            nu_free(cast(void*)enabledExtensions[i]);
        nu_freea(enabledExtensions);
        return device;
    }
}
