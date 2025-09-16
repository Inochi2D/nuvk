/**
    Devices
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.device;
import nuvk.physicaldevice;
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

import nuvk.queue;
import nuvk.buffer;
import nuvk.image;

/**
    A vulkan device.
*/
final
class NuvkDevice : NuRefCounted {
private:
@nogc:
    VkPhysicalDeviceMemoryProperties2 memoryProps_;
    VkPhysicalDeviceProperties2 physicalDeviceProps_;
    NuvkPhysicalDevice physicalDevice_;
    VkDevice handle_;
    vector!NuvkQueue queues_;

    // Helper that creates all of the allocated queues.
    void createQueues(VkDeviceCreateInfo createInfo) {
        VkQueue pQueue;

        foreach(i, VkDeviceQueueCreateInfo queue; createInfo.pQueueCreateInfos[0..createInfo.queueCreateInfoCount]) {
            foreach(j; 0..queue.queueCount) {
                vkGetDeviceQueue(handle_, queue.queueFamilyIndex, j, &pQueue);
                queues_ ~= nogc_new!NuvkQueue(this, pQueue, queue.queueFamilyIndex, j);
            }
        }
    }
public:
    alias handle this;

    /**
        The internal VkDevice handle for this device.
    */
    @property VkDevice handle() nothrow => handle_;

    /**
        The internal VkDevice handle for this device.
    */
    @property NuvkPhysicalDevice physicalDevice() nothrow => physicalDevice_;

    /**
        The name of the device.
    */
    @property string name() nothrow => cast(string)physicalDeviceProps_.properties.deviceName.ptr.fromStringz();

    /**
        The memory properties of the device.
    */
    @property VkPhysicalDeviceMemoryProperties2 memoryProperties() nothrow => memoryProps_;

    /**
        The queues associated with this device.
    */
    @property NuvkQueue[] queues() nothrow => queues_[];

    /// Destructor
    ~this() {
        queues_.clear();
        vkDestroyDevice(handle_, null);
    }

    /**
        Constructs a Device.

        Params:
            ptr =               The pointer to the Device.
            physicalDevice =    The physical device associated with the device.
            createInfo =        The information the device was created with.
    */
    this(VkDevice ptr, NuvkPhysicalDevice physicalDevice, VkDeviceCreateInfo createInfo) {
        this.handle_ = ptr;
        this.physicalDevice_ = physicalDevice;
        this.physicalDeviceProps_ = physicalDevice.getProperties();
        this.memoryProps_ = physicalDevice.getMemoryProperties();
        this.createQueues(createInfo);
    }

    /**
        Creates a new buffer from the device with the given creation
        properties and memory property flags.

        Params:
            createInfo  = Creation information for the buffer.
            reqProps    = Requested properties of the buffer's memory.

        Returns:
            The new buffer.
    */
    NuvkBuffer createBuffer(VkBufferCreateInfo createInfo, VkMemoryPropertyFlags reqProps) {
        return nogc_new!NuvkBuffer(this, createInfo, reqProps);
    }

    /**
        Creates a new image from the device with the given creation
        properties.

        Params:
            createInfo  = Creation information for the image.

        Returns:
            The new image.
    */
    NuvkImage createImage(VkImageCreateInfo createInfo) {
        return nogc_new!NuvkImage(this, createInfo);
    }

    /**
        Waits for the device to be idle.

        Returns:
            A $(D VkResult).
    */
    VkResult waitIdle() {
        return vkDeviceWaitIdle(handle_);
    }

    /**
        Gets the memory type index that satisfies all the requirements
        in the given bitmask.

        Params:
            reqProps = A bitmask of the required memory properties.
        
        Returns:
            Index of the memory type that satisfies the request,
            $(D -1) otherwise.
    */
    int selectMemoryTypeFor(VkMemoryPropertyFlags reqProps) {
        auto props = memoryProperties.memoryProperties;
        foreach(i, memoryType; props.memoryTypes[0..props.memoryTypeCount]) {
            if ((memoryType.propertyFlags & reqProps) == reqProps)
                return cast(uint)i;
        }
        return -1;
    }
}

/**
    An object belonging to a device.
*/
abstract
class NuvkDeviceObject(T) : NuRefCounted {
private:
@nogc:
    NuvkDevice device_;
    T handle_;

public:
    alias handle this;

    /**
        The native vulkan handle of the object.
    */
    @property T handle() => handle_;

    /**
        The device which created this object.
    */
    @property NuvkDevice device() => device_;

    /**
        A device object.
    */
    this(NuvkDevice device, T ptr) {
        this.device_ = device;
        this.handle_ = ptr;
    }
}