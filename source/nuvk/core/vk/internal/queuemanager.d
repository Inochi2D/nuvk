module nuvk.core.vk.internal.queuemanager;
import nuvk.core.vk;
import nuvk.core;
import numem.all;

import core.stdc.stdlib : malloc, free;
import core.stdc.stdio : printf;

private {
    const float nuvkVkDeviceQueuePriority = 1.0f;
    
    // A queue family
    struct NuvkVkQueueFamily {
    @nogc:
        this(NuvkQueueSpecialization specialization, uint queueCount) {
            this.specialization = specialization;

            // Specializations
            this.assignedQueues = weak_vector!NuvkQueue(queueCount);
            foreach(i; 0..assignedQueues.size()) {
                assignedQueues[i] = null;
            }

            // Priorities
            this.priorities = cast(float*)malloc(assignedQueues.size()*float.sizeof);
            foreach(i; 0..assignedQueues.size()) {
                priorities[i] = 1.0f;
            }
        }

        ~this() {
            if (priorities) {
                free(priorities);
            }
        }

        float* priorities;

        // Sepcialization for the family
        NuvkQueueSpecialization specialization;

        // Queue assignments
        weak_vector!NuvkQueue assignedQueues;

        /**
            Gets whether the queue family can instantiate more queues.
        */
        bool canInstantiateMore() {
            return getNextQueueIndex() >= 0;
        }

        /**
            Gets the next free queue index
        */
        ptrdiff_t getNextQueueIndex() {
            foreach(i, queue; assignedQueues) {
                if (queue is null) 
                    return i;
            }

            return -1;
        }
    }
}

/**
    A mask specifying the maximum supported vulkan queue flags.
*/
enum VkMaxSupportedQueueMask = VK_QUEUE_GRAPHICS_BIT | VK_QUEUE_COMPUTE_BIT | VK_QUEUE_TRANSFER_BIT;

/**
    Gets vulkan queue flags
*/
VkQueueFlags toVkQueueFlags(NuvkQueueSpecialization specialization) @nogc {
    uint queueFlags = 0;

    if (specialization & NuvkQueueSpecialization.graphics)
        queueFlags |= VK_QUEUE_GRAPHICS_BIT;

    if (specialization & NuvkQueueSpecialization.compute)
        queueFlags |= VK_QUEUE_COMPUTE_BIT;

    if (specialization & NuvkQueueSpecialization.transfer)
        queueFlags |= VK_QUEUE_TRANSFER_BIT;

    return cast(VkQueueFlags)queueFlags;
}

/**
    Gets nuvk queue specialization
*/
NuvkQueueSpecialization toNuvkSpecialization(VkQueueFlags queueFlags) @nogc {
    uint specialization = 0;

    if (queueFlags & VK_QUEUE_GRAPHICS_BIT)
        specialization |= NuvkQueueSpecialization.graphics;

    if (queueFlags & VK_QUEUE_COMPUTE_BIT)
        specialization |= NuvkQueueSpecialization.compute;

    if (queueFlags & VK_QUEUE_TRANSFER_BIT)
        specialization |= NuvkQueueSpecialization.transfer;

    return cast(NuvkQueueSpecialization)specialization;
}

/**
    Manager for device queues, helping delegate queues for specific
    specializations.
*/
class NuvkVkDeviceQueueManager {
@nogc:
private:
    NuvkVkDevice nuvkDevice;
    NuvkDeviceInfo nuvkDeviceInfo;

    vector!(NuvkVkQueueFamily*) queueFamilies;
    vector!VkDeviceQueueCreateInfo queueCreateInfos;

    /**
        Generates the information needed to instantiate all of the queues.
    */
    void generateQueueInfo() {
        auto qfamilies = nuvkDevice.getDeviceInfo().getQueueFamilyInfos();

        foreach(i, NuvkQueueFamilyInfo family; qfamilies) {
            queueFamilies ~= nogc_new!NuvkVkQueueFamily(
                family.specialization,
                family.maxQueueCount
            );

            VkDeviceQueueCreateInfo queueCreateInfo;
            queueCreateInfo.queueFamilyIndex = cast(uint)i;
            queueCreateInfo.queueCount = family.maxQueueCount;
            queueCreateInfo.pQueuePriorities = queueFamilies[$-1].priorities;

            this.queueCreateInfos ~= queueCreateInfo;
        }
    }

    /**
        Finds the index of the queue family that matches the best
        for the specified specialization.
    */
    ptrdiff_t findQueueFamilyFor(NuvkQueueSpecialization specialization) {

        // Try to find queue that matches exact specs
        foreach(i, family; queueFamilies) {
            if (family.specialization == specialization && family.canInstantiateMore()) {
                return i;
            }
        }

        // Try to find one that at least supports the specified specializations.
        foreach(i, family; queueFamilies) {

            // NOTE: This uses a bitwise AND to filter out any specialiations
            // That the family might have *extra*
            // in this case we just care if the queue supports the specialization.
            uint spec = (family.specialization & specialization);
            if (spec == specialization && family.canInstantiateMore()) {
                return i;
            }
        }

        return -1;
    }

public:

    /**
        Constructor
    */
    this(NuvkVkDevice device) {
        this.nuvkDevice = device;
        this.generateQueueInfo();
    }

    /**
        Creates a queue with the specified specializations
    */
    final
    NuvkQueue createQueue(NuvkQueueSpecialization specialization) {
        VkQueue queue;

        auto device = cast(VkDevice)nuvkDevice.getHandle();
        ptrdiff_t queueFamilyIndex = findQueueFamilyFor(specialization);
        enforce(
            queueFamilyIndex >= 0,
            nstring("Could not find any free queues supporting the specialization")
        );

        // Prior check should ensure this is a valid value.
        ptrdiff_t queueIndex = queueFamilies[queueFamilyIndex].getNextQueueIndex();
        vkGetDeviceQueue(device, cast(uint)queueFamilyIndex, cast(uint)queueIndex, &queue);
        queueFamilies[queueFamilyIndex]
            .assignedQueues[queueIndex] = nogc_new!NuvkVkQueue(nuvkDevice, specialization, queue, cast(uint)queueFamilyIndex);
        
        return queueFamilies[queueFamilyIndex].assignedQueues[queueIndex];
    }

    /**
        Removes a command queue
    */
    final
    bool removeQueue(NuvkVkQueue queue) {
        foreach(i; 0..queueFamilies.size()) {
            foreach(k; 0..queueFamilies[i].assignedQueues.size()) {
                if (queueFamilies[i].assignedQueues[k] is queue) {
                    nogc_delete(queueFamilies[i].assignedQueues[k]);
                    queueFamilies[i].assignedQueues[k] = null;
                    
                    return true;
                }
            }
        }

        return false;
    }

    /**
        Gets a slice of the creation information a device needs
    */
    final
    VkDeviceQueueCreateInfo[] getVkQueueCreateInfos() {
        return queueCreateInfos[];
    }
}

