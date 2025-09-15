/**
    Command Queues
    
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
class NuvkQueue : NuObject {
private:
@nogc:
    VkQueue handle_;

public:
    alias handle this;

    /**
        Gets the vulkan handle for this queue.
    */
    final @property VkQueue handle() => handle_;

    /**
        Constructs a new Queue

        Params:
            ptr = The VkQueue instance.
    */
    this(VkQueue ptr) {
        this.handle_ = ptr;
    }
}