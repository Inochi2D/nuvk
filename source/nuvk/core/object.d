/**
    Vulkan Objects Abstraction
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.core.object;
import vulkan.core;
import numem;

/**
    Base object for all wrapped Vulkan objects.
*/
abstract
class VulkanObject(T, VkObjectType objectType) : NuRefCounted {
private:
@nogc:
    T handle_;

protected:

    /**
        The handle associated with the object.
    */
    final @property void handle(T value) nothrow pure {
        handle_ = value;
    }

public:
    alias handle this;

    /**
        The handle associated with the object.
    */
    final @property T handle() nothrow pure => handle_;

    /**
        The Vulkan Object Type of the object.
    */
    final @property VkObjectType type() nothrow pure => objectType;

    /**
        Constructs a Vulkan Object.

        Params:
            handle = The handle to construct the object with.
    */
    this(T handle) {
        this.handle_ = handle;
    }
}