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
import nuvk.instance;
import nuvk.device;
import nuvk.core;
import vulkan.khr.surface;
import vulkan.khr.swapchain;
import vulkan.core;
import numem;
import nulib;

/**
    A physical device.
*/
class NuvkPhysicalDevice : VulkanObject!(VkPhysicalDevice, VK_OBJECT_TYPE_PHYSICAL_DEVICE) {
private:
@nogc:
    VkPhysicalDeviceFeatures2 features_;
    VkPhysicalDeviceProperties2 deviceProps_;
    VkPhysicalDeviceMemoryProperties2 memoryProps_;
    VkQueueFamilyProperties2[] familyProps_;

public:

    /**
        The base family properties of the physical device.
    */
    final @property VkQueueFamilyProperties2[] queueFamilies() => familyProps_;

    /**
        The amount of queue families this device has.
    */
    final @property uint queueFamilyCount() {
        uint pCount;
        vkGetPhysicalDeviceQueueFamilyProperties2(handle, &pCount, null);
        return pCount;
    }

    // Destructor
    ~this() {
        nu_freea(familyProps_);
    }

    /**
        Constructs a new Physical Device.
    */
    this(VkPhysicalDevice handle) {
        super(handle);

        this.familyProps_ = nu_malloca!VkQueueFamilyProperties2(queueFamilyCount);
        cast(void)this.getDeviceQueueFamilyProperties(familyProps_);
    }

    /**
        Gets the features of the device.
        
        Params:
            in_ = The input structure chain to fill.
    */
    void getFeatures(VkPhysicalDeviceFeatures2* in_) {
        if (!in_)
            return;

        vkGetPhysicalDeviceFeatures2(handle, in_);
    }

    /**
        Gets the properties of the device.
        
        Params:
            in_ = The input structure chain to fill.
    */
    void getProperties(VkPhysicalDeviceProperties2* in_) {
        if (!in_)
            return;
        
        vkGetPhysicalDeviceProperties2(handle, in_);
    }

    /**
        Gets the properties of the given format.

        Params:
            format = The format to get properties about.
            in_ = The input structure chain to fill.
        
        Returns:
            A VkFormatProperties describing the properties
            of the format.
    */
    void getFormatProperties(VkFormat format, VkFormatProperties2* in_) {
        if (!in_)
            return;
        
        vkGetPhysicalDeviceFormatProperties2(handle, format, in_);
    }

    /**
        Gets the memory properties of the physical device.
        
        Params:
            in_ = The input structure chain to fill.

        Returns:
            A VkPhysicalDeviceMemoryProperties2 describing the 
            memory properties of the physical device.
    */
    void getMemoryProperties(VkPhysicalDeviceMemoryProperties2* in_) {
        if (!in_)
            return;
        
        vkGetPhysicalDeviceMemoryProperties2(handle, in_);
    }

    /**
        Gets the base queue family properties.
        
        Params:
            in_ = The input structure chains to fill.
        
        Returns:
            The amount of queue families which were written.
    */
    uint getDeviceQueueFamilyProperties(ref VkQueueFamilyProperties2[] in_) {
        import nulib.math : min;

        uint pCount = cast(uint)min(in_.length, queueFamilyCount);
        if (pCount > 0)
            vkGetPhysicalDeviceQueueFamilyProperties2(handle, &pCount, in_.ptr);
        return pCount;
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
        vkEnforce(vkCreateDevice(handle, &createInfo, null, &result_));
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
    weak_vector!(const(char)*) extensions;
    VkFlags queueTypes;
    VkSurfaceKHR surface;

public:

    /// Destructor
    ~this() {
        requiredFeatures.clear();
        optionalFeatures.clear();
        foreach(str; extensions) {
            nu_free(cast(void*)str);
        }
        extensions.clear();
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

        // Just to ensure we can get them no matter what.
        VK_KHR_surface surfaceProcs;
        instance.loadProcs(surfaceProcs);

        if (surface) {
            queueTypes |= VK_QUEUE_GRAPHICS_BIT;
            extensions ~= nstring(VK_KHR_SWAPCHAIN_EXTENSION_NAME).take().ptr;
        }

        vector!VkDeviceQueueCreateInfo queuesToCreate;
        auto reqFeatures = requiredFeatures.copy();
        auto optFeatures = optionalFeatures.copy();
        outer: foreach(physicalDevice; instance.devices) {
            bool isSurfaceSupported = surface ? false : true;
            bool hasRequiredQueues = false;
            bool hasRequiredFeatures = false;

            // Skip devices which doesn't support the requested version.
            VkPhysicalDeviceProperties2 props;
            physicalDevice.getProperties(&props);
            if (props.properties.apiVersion < minimumVersion)
                continue;
                

            physicalDevice.getFeatures(cast(VkPhysicalDeviceFeatures2*)reqFeatures.front);
            physicalDevice.getFeatures(cast(VkPhysicalDeviceFeatures2*)optFeatures.front);
            
            hasRequiredFeatures = requiredFeatures.isFeaturesCompatible(reqFeatures);

            // Queues
            queuesToCreate.clear();
            foreach(i, queue; physicalDevice.queueFamilies) {
                if ((queue.queueFamilyProperties.queueFlags & queueTypes) > 0) {

                    float priority = 1;
                    queuesToCreate ~= VkDeviceQueueCreateInfo(
                        queueFamilyIndex: cast(uint)i,
                        queueCount: 1,
                        pQueuePriorities: &priority
                    );
                }
            }
            hasRequiredQueues = queuesToCreate.length > 0;

            // Surface
            if (surface) {
                foreach(qi; 0..physicalDevice.queueFamilies.length) {
                    uint supported;
                    surfaceProcs.vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice.handle, cast(uint)qi, surface, &supported);

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
