/**
    Synchronisation Primitives.
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.sync;
import nuvk.device;
import nuvk.core;
import vulkan.core;

/**
    A fence
*/
class NuvkFence : NuvkDeviceObject!(VkFence, VK_OBJECT_TYPE_FENCE) {
public:
@nogc:

    /**
        The current status of the fence.
    */
    @property VkResult status() => vkGetFenceStatus(device.handle, handle);

    // Destructor
    ~this() {
        vkDestroyFence(device.handle, handle, null);
    }

    /**
        Constructs a fence from a vulkan handle.
    */
    this(NuvkDevice device, VkFence handle) {
        super(device, handle);
    }

    /**
        Constructs a new Fence

        Params:
            device =    The device to create the fence for.
            flags =     The creation flags
        
        Returns:
            A new fence or $(D null) on failure.
    */
    this(NuvkDevice device, VkFenceCreateFlags flags) {
        VkFence fence_;
        auto createInfo = VkFenceCreateInfo(flags: flags);
        vkEnforce(vkCreateFence(device.handle, &createInfo, null, &fence_));
        super(device, fence_);
    }

    /**
        Waits for the fence to be signalled.
        
        Returns:
            A VkResult value indicating success or error states.
    */
    VkResult await(ulong timeout) {
        VkFence handle_ = handle;
        return vkWaitForFences(device.handle, 1, &handle_, true, timeout);
    }

    /**
        Resets the fence.
        
        Returns:
            A VkResult value indicating success or error states.
    */
    VkResult reset() {
        VkFence handle_ = handle;
        return vkResetFences(device.handle, 1, &handle_);
    }
}

/**
    A Binary Semaphore
*/
class NuvkSemaphore : NuvkDeviceObject!(VkSemaphore, VK_OBJECT_TYPE_SEMAPHORE) {
public:
@nogc:

    // Destructor
    ~this() {
        vkDestroySemaphore(device.handle, handle, null);
    }

    /**
        Constructs a semaphore from a vulkan handle.
    */
    this(NuvkDevice device, VkSemaphore handle) {
        super(device, handle);
    }

    /**
        Constructs a new semaphore

        Params:
            device =    The device to create the fence for.
        
        Returns:
            A new semaphore or $(D null) on failure.
    */
    this(NuvkDevice device) {
        VkSemaphore semaphore_;
        auto typeCreateInfo = VkSemaphoreTypeCreateInfo(
            semaphoreType: VK_SEMAPHORE_TYPE_BINARY
        );
        auto createInfo = VkSemaphoreCreateInfo(
            pNext: &typeCreateInfo
        );
        vkEnforce(vkCreateSemaphore(device.handle, &createInfo, null, &semaphore_));
        super(device, semaphore_);
    }
}

/**
    A Timeline Semaphore
*/
class NuvkTimelineSemaphore : NuvkDeviceObject!(VkSemaphore, VK_OBJECT_TYPE_SEMAPHORE) {
public:
@nogc:

    /**
        The value of the semahpore.
    */
    @property ulong counter() {
        ulong value;
        vkGetSemaphoreCounterValue(device.handle, handle, &value);
        return value;
    }

    // Destructor
    ~this() {
        vkDestroySemaphore(device.handle, handle, null);
    }

    /**
        Constructs a semaphore from a vulkan handle.
    */
    this(NuvkDevice device, VkSemaphore handle) {
        super(device, handle);
    }

    /**
        Constructs a new timeline semaphore

        Params:
            device =        The device to create the fence for.
            initialValue =  The initial value
        
        Returns:
            A new semaphore or $(D null) on failure.
    */
    this(NuvkDevice device, uint initialValue) {
        VkSemaphore semaphore_;
        auto typeCreateInfo = VkSemaphoreTypeCreateInfo(
            semaphoreType: VK_SEMAPHORE_TYPE_TIMELINE,
            initialValue: initialValue
        );
        auto createInfo = VkSemaphoreCreateInfo(
            pNext: &typeCreateInfo
        );
        vkEnforce(vkCreateSemaphore(device.handle, &createInfo, null, &semaphore_));
        super(device, semaphore_);
    }

    /**
        Waits for the semaphore to be signalled with the given value.

        Params:
            value =     The value to wait for.
            timeout =   The timeout to wait in ms.
        
        Returns:
            A VkResult value indicating success or error states.
    */
    VkResult await(ulong value, ulong timeout = 0) {
        VkSemaphore handle_ = handle;
        auto waitInfo = VkSemaphoreWaitInfo(
            semaphoreCount: 1,
            pSemaphores: &handle_,
            pValues: &value
        );
        return vkWaitSemaphores(device.handle, &waitInfo, timeout);
    }

    /**
        Signals the semaphore with the given value.

        Params:
            value = The value to signal with.
        
        Returns:
            A VkResult value indicating success or error states.
    */
    VkResult signal(ulong value) {
        auto signalInfo = VkSemaphoreSignalInfo(
            semaphore: handle,
            value: value
        );
        return vkSignalSemaphore(device.handle, &signalInfo);
    }
}