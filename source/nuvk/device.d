/**
    NuVK Device
    
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

/**
    A vulkan device.
*/
class Device : NuRefCounted {
private:
    PhysicalDevice physicalDevice_;
    VkDevice handle_;
public:
@nogc:
    alias handle this;

    /**
        Gets the internal VkDevice handle for this device.
    */
    final @property VkDevice handle() => handle_;

    /**
        Gets the internal VkDevice handle for this device.
    */
    final @property PhysicalDevice physicalDevice() => physicalDevice_;

    /// Destructor
    ~this() {
        vkDestroyDevice(handle_, null);
    }

    /**
        Constructs a Device.

        Params:
            ptr =               The pointer to the Device.
            physicalDevice =    The physical device associated with the device.
    */
    this(VkDevice ptr, PhysicalDevice physicalDevice) {
        this.handle_ = ptr;
        this.physicalDevice_ = physicalDevice;
    }

    /**
        Waits for the device to be idle.

        Returns:
            A $(D VkResult).
    */
    VkResult waitIdle() {
        return vkDeviceWaitIdle(handle_);
    }
}