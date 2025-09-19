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
import nuvk.sync;

/**
    A vulkan device.
*/
final
class NuvkDevice : VulkanObject!(VkDevice, VK_OBJECT_TYPE_DEVICE) {
private:
@nogc:
    VkPhysicalDeviceMemoryProperties2 memoryProps_;
    VkPhysicalDeviceProperties2 physicalDeviceProps_;
    NuvkPhysicalDevice physicalDevice_;
    vector!NuvkQueue queues_;

    // Helper that creates all of the allocated queues.
    void createQueues(VkDeviceCreateInfo createInfo) {
        VkQueue pQueue;

        foreach(i, VkDeviceQueueCreateInfo queue; createInfo.pQueueCreateInfos[0..createInfo.queueCreateInfoCount]) {
            foreach(j; 0..queue.queueCount) {
                vkGetDeviceQueue(handle, queue.queueFamilyIndex, j, &pQueue);
                queues_ ~= nogc_new!NuvkQueue(this, pQueue, queue.queueFamilyIndex, j);
            }
        }
    }

public:

    /**
        The physical device associated with this device.
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
        cast(void)this.physicalDevice_.release();
        queues_.clear();

        vkDestroyDevice(handle, null);
    }

    /**
        Constructs a Device.

        Params:
            handle =            The Vulkan handle of the Device.
            physicalDevice =    The physical device associated with the device.
            createInfo =        The information the device was created with.
    */
    this(VkDevice handle, NuvkPhysicalDevice physicalDevice, VkDeviceCreateInfo createInfo) {
        super(handle);

        this.physicalDevice_ = physicalDevice.retained();
        this.physicalDevice_.getProperties(&physicalDeviceProps_);
        this.physicalDevice_.getMemoryProperties(&memoryProps_);
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
        Creates a new fence.

        Params:
            flags  = Creation flags for the fence.

        Returns:
            The new fence.
    */
    NuvkFence createFence(VkFenceCreateFlags flags) {
        return nogc_new!NuvkFence(this, flags);
    }

    /**
        Creates a new semaphore.

        Returns:
            The new semaphore.
    */
    NuvkSemaphore createSemaphore() {
        return nogc_new!NuvkSemaphore(this);
    }

    /**
        Creates a new semaphore.

        Params:
            initialValue = Initial value of the timeline semaphore.

        Returns:
            The new semaphore.
    */
    NuvkTimelineSemaphore createTimelineSemaphore(uint initialValue) {
        return nogc_new!NuvkTimelineSemaphore(this, initialValue);
    }

    /**
        Waits for the device to be idle.

        Returns:
            A $(D VkResult).
    */
    VkResult waitIdle() {
        return vkDeviceWaitIdle(handle);
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

    /**
        Loads procedures for the device.

        Params:
            procs = The structure to store the procedures pointers in.
    */
    void loadProcs(T)(ref T procs) {
        handle.loadProcs!T(procs);
    }
}

/**
    An object belonging to a device.
*/
abstract
class NuvkDeviceObject(T, VkObjectType objectType) : VulkanObject!(T, objectType) {
private:
@nogc:
    NuvkDevice device_;

public:

    ~this() { }

    /**
        The device which created this object.
    */
    @property NuvkDevice device() => device_;

    /**
        A device object.
    */
    this(NuvkDevice device, T handle) {
        this.device_ = device;
        super(handle);
    }
}