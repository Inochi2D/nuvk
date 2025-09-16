/**
    Command Queues and Pools
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.queue;
import nuvk.device;
import vulkan.core;
import nuvk.core;
import numem;
import nulib;

/**
    A vulkan queue
*/
final
class NuvkQueue : NuvkDeviceObject!VkQueue {
private:
@nogc:
    uint queueFamily_;
    uint queueIndex_;

public:
    alias handle this;

    /**
        The family index of this queue.
    */
    @property uint queueFamily() => queueFamily_;

    /**
        The index of this queue
    */
    @property uint queueIndex() => queueIndex_;

    /**
        Constructs a new Queue

        Params:
            device =        The device which owns the queue.
            ptr =           The VkQueue instance.
            queueFamily =   The queue family of the queue.
            queueIndex =    The queue index of the queue.
    */
    this(NuvkDevice device, VkQueue ptr, uint queueFamily, uint queueIndex) {
        this.queueFamily_ = queueFamily;
        super(device, ptr);
    }

    /**
        Creates a new command pool for the queue.
    */
    NuvkCommandPool createPool() {
        return nogc_new!NuvkCommandPool(this);
    }
}

/**
    A vulkan command pool.
*/
final
class NuvkCommandPool : NuvkDeviceObject!VkCommandPool {
private:
@nogc:
    NuvkQueue queue_;

public:

    /**
        The queue this pool submits to.
    */
    @property NuvkQueue queue() => queue_;

    // Destructor
    ~this() {
        vkDestroyCommandPool(device.handle, handle, null);
    }

    /**
        Constructs a new Command Pool

        Params:
            queue =     The queue which the pool submits to.
    */
    this(NuvkQueue queue) {
        this.queue_ = queue;

        VkCommandPool pool_;
        auto poolCreateInfo = VkCommandPoolCreateInfo(
            queueFamilyIndex: queue_.queueFamily
        );
        vkCreateCommandPool(device.handle, &poolCreateInfo, null, &pool_);
        super(queue.device, pool_);
    }

    /**
        Resets the command pool.

        Params:
            resetFlags = Reset flags.
        
        Returns:
            $(D VK_SUCCESS) on success,
            negative VkResult otherwise.
    */
    VkResult reset(VkCommandPoolResetFlags resetFlags) {
        return vkResetCommandPool(device.handle, handle, resetFlags);
    }

    /**
        Trims the command pool, freeing memory if possible.

        Params:
            trimFlags = Trimming flags.
    */
    void trim(VkCommandPoolTrimFlags trimFlags) {
        vkTrimCommandPool(device.handle, handle, trimFlags);
    }

    /**
        Allocates a command buffer from the pool.

        Params:
            level = The level to allocate.
        
        Returns:
            A new VkCommandBuffer handle.
    */
    VkCommandBuffer allocate(VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
        VkCommandBuffer cmdbuffer;
        auto cmdbufCreateInfo = VkCommandBufferAllocateInfo(
            commandPool: handle,
            commandBufferCount: 1,
            level: level
        );

        vkAllocateCommandBuffers(device.handle, &cmdbufCreateInfo, &cmdbuffer);
        return cmdbuffer;
    }
}