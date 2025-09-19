/**
    GPU Buffers
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project

    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nuvk.buffer;
import nuvk.device;
import vulkan.core;
import nuvk.core;
import numem;

/**
    A Vulkan Buffer
*/
final
class NuvkBuffer : NuvkDeviceObject!(VkBuffer, VK_OBJECT_TYPE_BUFFER) {
private:
@nogc:
    VkDeviceMemory memory_;
    VkBufferCreateInfo createInfo_;
    VkMemoryRequirements memRequirements_;

public:

    /**
        Size of the buffer in bytes.
    */
    @property ulong size() => memRequirements_.size;

    /**
        Alignment of the buffer in bytes.
    */
    @property ulong alignment() => memRequirements_.alignment;

    /// Destructor
    ~this() {
        if (handle)
            vkDestroyBuffer(device.handle, handle, null);
        
        if (memory_)
            vkFreeMemory(device.handle, memory_, null);
    }

    /**
        Constructs a new wrapped buffer.

        Params:
            device      = The device which owns the buffer
            createInfo  = Creation information for the buffer.
            reqProps    = Requested properties of the buffer's memory.
    */
    this(NuvkDevice device, VkBufferCreateInfo createInfo, VkMemoryPropertyFlags reqProps) {
        this.createInfo_ = createInfo;
        
        VkBuffer buffer_;
        int reqPropId = device.selectMemoryTypeFor(reqProps);
        if (reqPropId >= 0) {
            vkEnforce(vkCreateBuffer(device.handle, &createInfo_, null, &buffer_));
            vkGetBufferMemoryRequirements(device.handle, buffer_, &memRequirements_);
            
            auto allocInfo = VkMemoryAllocateInfo(
                allocationSize: memRequirements_.size,
                memoryTypeIndex: reqPropId
            );
            vkEnforce(vkAllocateMemory(device.handle, &allocInfo, null, &memory_));
            vkEnforce(vkBindBufferMemory(device.handle, buffer_, memory_, 0));
        }
        super(device, buffer_);
    }


    /**
        Constructs a new Vulkan Buffer

        Params:
            device      = The device which owns the buffer.
            ptr         = The pre-existing vulkan handle to use.
    */
    this(NuvkDevice device, VkBuffer ptr) {
        vkGetBufferMemoryRequirements(device.handle, ptr, &memRequirements_);
        super(device, ptr);
    }

    /**
        Maps the memory of the buffer into the address space of the 
        application.

        Returns:
            A slice of the mapped memory range.
    */
    void[] map() {
        void* pData;
        vkEnforce(vkMapMemory(device.handle, memory_, 0, VK_WHOLE_SIZE, 0, &pData));
        return pData[0..size];
    }

    /**
        Unmaps the memory of this buffer from the address space of the
        application.
    */
    void unmap() {
        vkUnmapMemory(device.handle, memory_);
    }
}

/**
    A Vulkan buffer view.
*/
final
class NuvkBufferView : NuvkDeviceObject!(VkBufferView, VK_OBJECT_TYPE_BUFFER_VIEW) {
private:
@nogc:
    NuvkBuffer buffer_;
    VkBufferViewCreateInfo createInfo_;

public:

    /**
        The buffer this is a view of.
    */
    @property NuvkBuffer buffer() => buffer_;

    /// Destructor
    ~this() {
        if (handle) {
            vkDestroyBufferView(device.handle, handle, null);
            buffer_.release();
        }
    }

    /**
        Constructs a new Vulkan Image View

        Params:
            device      = The device which owns the image view
            buffer      = The image this is a view of.
            createInfo  = Creation information for the image.
    */
    this(NuvkDevice device, NuvkBuffer buffer, VkBufferViewCreateInfo createInfo) {
        this.createInfo_ = createInfo;
        this.createInfo_.buffer = buffer.handle;

        VkBufferView bufferView_;
        vkEnforce(vkCreateBufferView(device.handle, &createInfo_, null, &bufferView_));

        this.buffer_ = buffer.retained();
        super(device, bufferView_);
    }

    /**
        Constructs a new Vulkan Image View

        Params:
            device      = The device which owns the buffer view
            buffer      = The buffer this is a view of.
            ptr         = The pre-existing vulkan handle to use.
    */
    this(NuvkDevice device, NuvkBuffer buffer, VkBufferView ptr) {
        this.buffer_ = buffer.retained();
        super(device, ptr);
    }
}