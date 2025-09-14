/**
    NuVK PhysicalDevice
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.physicaldevice;
import nuvk.device;
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

/**
    A wrapped VkPhysicalDevice.
*/
struct PhysicalDevice {
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
            VkPhysicalDeviceFeatures enumerating features
            of the device.
    */
    VkPhysicalDeviceFeatures getFeatures() {
        VkPhysicalDeviceFeatures result_;
        vkGetPhysicalDeviceFeatures(ptr, &result_);
        return result_;
    }

    /**
        Gets the properties of the device.

        Returns:
            VkPhysicalDeviceProperties enumerating properties
            of the device.
    */
    VkPhysicalDeviceProperties getProperties() {
        VkPhysicalDeviceProperties result_;
        vkGetPhysicalDeviceProperties(ptr, &result_);
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
            A VkPhysicalDeviceMemoryProperties describing the 
            memory properties of the physical device.
    */
    VkPhysicalDeviceMemoryProperties getMemoryProperties() {
        VkPhysicalDeviceMemoryProperties props;
        vkGetPhysicalDeviceMemoryProperties(ptr, &props);
        return props;
    }

    /**
        Gets the list of queue family properties for the physical
        device.
        
        Returns:
            A slice of VkQueueFamilyProperties describing the
            different queues supported by the physical device.
    */
    VkQueueFamilyProperties[] getDeviceQueueFamilyProperties() {
        uint pCount;
        vkGetPhysicalDeviceQueueFamilyProperties(ptr, &pCount, null);

        VkQueueFamilyProperties[] props = nu_malloca!VkQueueFamilyProperties(pCount);
        vkGetPhysicalDeviceQueueFamilyProperties(ptr, &pCount, props.ptr);
        return props;
    }

    /**
        Creates a device from this Physical Device.

        Params:
            createInfo =    Info used to create the device.
            alloc =         The allocator to create it with or $(D null).
        
        Returns:
            A newly allocated device.
    */
    Device createDevice(VkDeviceCreateInfo createInfo, const(VkAllocationCallbacks)* alloc = null) {
        Device result_;
        vkEnforce(vkCreateDevice(ptr, &createInfo, alloc, &result_.ptr));
        return result_;
    }
}