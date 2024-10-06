module nuvk.core.vk.internal.descpoolmgr;
import nuvk.core;
import nuvk.core.vk;
import numem.all;

enum MAX_POOL_ALLOCS = 1000;

/**
    A manager for descriptor pools.
*/
class NuvkDescriptorPoolManager {
@nogc:
private:
    struct VkPoolAllocation {
    @nogc:

        // The descriptor pool
        VkDescriptorPool pool;

        // Whether the last allocation succeeded.
        bool allocSucceeded;

        // The sets allocated
        weak_vector!VkDescriptorSet sets;
    }
    
    NuvkVkDevice device;
    weak_vector!VkPoolAllocation pools;

    void allocPool() {
        auto vkdevice = cast(VkDevice)device.getHandle();

        VkPoolAllocation allocation;
        
        VkDescriptorPoolSize poolSizeInfo;
        poolSizeInfo.descriptorCount = MAX_POOL_ALLOCS;

        VkDescriptorPoolCreateInfo createInfo;
        createInfo.poolSizeCount = 1;
        createInfo.pPoolSizes = &poolSizeInfo;
        createInfo.maxSets = MAX_POOL_ALLOCS;
        createInfo.flags = VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT;

        nuvkEnforce(
            vkCreateDescriptorPool(vkdevice, &createInfo, null, &allocation.pool) == VK_SUCCESS,
            "Failed to allocate descriptor pool!"
        );

        allocation.allocSucceeded = true;
        allocation.sets.reserve(MAX_POOL_ALLOCS);

        pools ~= allocation;
    }

    bool allocFor(ref VkPoolAllocation allocation, VkDescriptorSetLayout[] layouts) {
        
        // Early exit since last allocation failed.
        if (!allocation.allocSucceeded)
            return false;

        auto vkdevice = cast(VkDevice)device.getHandle();
        VkDescriptorSet set;

        VkDescriptorSetAllocateInfo allocInfo;
        allocInfo.descriptorPool = allocation.pool;
        allocInfo.descriptorSetCount = cast(uint)layouts.length;
        allocInfo.pSetLayouts = layouts.ptr;

        bool succeeded = vkAllocateDescriptorSets(vkdevice, &allocInfo, &set) == VK_SUCCESS;
        
        if (succeeded) {

            allocation.sets ~= set;
            return true;
        }

        allocation.allocSucceeded = false;
        return false;
    }

public:
    ~this() {

        // Destroy all the pools allocated
        auto vkdevice = cast(VkDevice)device.getHandle();
        foreach(pool; pools) {
            if (pool.pool != VK_NULL_HANDLE)
                vkDestroyDescriptorPool(vkdevice, pool.pool, null);
        }
    }

    this(NuvkVkDevice device) {
        this.device = device;
    }

    VkDescriptorSet getNext(VkDescriptorSetLayout[] layouts) {
        foreach(pool; pools) {
            if (this.allocFor(pool, layouts)) {
                return pool.sets[$-1];
            }
        }

        // No free pools, allocate a new one
        this.allocPool();
        return this.getNext(layouts);
    }

    void reset() {
        auto vkdevice = cast(VkDevice)device.getHandle();

        foreach(pool; pools) {
            vkResetDescriptorPool(vkdevice, pool.pool, 0);
            pool.sets.resize(0);
            pool.allocSucceeded = true;
        }
    }
}