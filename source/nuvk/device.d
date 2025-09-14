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
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

/**
    A vulkan device.
*/
struct Device {
public:
@nogc:
    VkDevice ptr;
    alias ptr this;

    /**
        Constructs a Device.

        Params:
            ptr = The pointer to the Device.
    */
    this(VkDevice ptr) {
        this.ptr = ptr;
    }

    /**
        Waits for the device to be idle.

        Returns:
            A $(D VkResult).
    */
    VkResult waitIdle() {
        return vkDeviceWaitIdle(ptr);
    }

    /**
        Destroys the device.
    */
    void destroy() {
        vkDestroyDevice(ptr, null);
    }
}