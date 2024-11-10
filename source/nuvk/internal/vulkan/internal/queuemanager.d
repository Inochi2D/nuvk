module nuvk.internal.vulkan.internal.queuemanager;
import nuvk.internal.vulkan;
import nuvk.core;
import nuvk.queue;
import nuvk.devinfo;
import numem.all;

import core.stdc.stdlib : malloc, free;
import core.stdc.stdio : printf;

private {
    const float nuvkVkDeviceQueuePriority = 1.0f;
    
    // A queue family
    class NuvkQueueVkFamily {
    @nogc:
        this(NuvkQueueFamilyInfo familyInfo) {
            this.familyInfo = familyInfo;

            // Specializations
            this.assignedQueues = weak_vector!NuvkQueue(familyInfo.maxQueueCount);
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
        NuvkQueueFamilyInfo familyInfo;

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
        int getNextQueueIndex() {
            foreach(i, queue; assignedQueues) {
                if (queue is null) 
                    return cast(int)i;
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
class NuvkDeviceVkQueueManager {
@nogc:
private:
    NuvkDeviceVk nuvkDevice;
    NuvkDeviceInfo nuvkDeviceInfo;

    vector!NuvkQueueVkFamily queueFamilies;
    vector!VkDeviceQueueCreateInfo queueCreateInfos;

    /**
        Generates the information needed to instantiate all of the queues.
    */
    void generateQueueInfo() {
        auto qfamilies = nuvkDevice.getDeviceInfo().getQueueFamilyInfos();

        foreach(i, NuvkQueueFamilyInfo family; qfamilies) {
            queueFamilies ~= nogc_new!NuvkQueueVkFamily(family);

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
            if (family.familyInfo.specialization == specialization && family.canInstantiateMore()) {
                return i;
            }
        }

        // Try to find one that at least supports the specified specializations.
        foreach(i, family; queueFamilies) {

            // NOTE: This uses a bitwise AND to filter out any specialiations
            // That the family might have *extra*
            // in this case we just care if the queue supports the specialization.
            uint spec = (family.familyInfo.specialization & specialization);
            if (spec == specialization && family.canInstantiateMore()) {
                return i;
            }
        }

        return -1;
    }

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(queueCreateInfos);
        nogc_delete(queueFamilies);
    }

    /**
        Constructor
    */
    this(NuvkDeviceVk device) {
        this.nuvkDevice = device;
        this.generateQueueInfo();
    }

    /**
        Creates a queue with the specified specializations
    */
    final
    NuvkQueue createQueue(uint count, NuvkQueueSpecialization specialization) {
        VkQueue queue;

        // Get queue information
        auto device = cast(VkDevice)nuvkDevice.getHandle();
        ptrdiff_t familyIndex = findQueueFamilyFor(specialization);
        nuvkEnforce(
            familyIndex >= 0,
            "Could not find any free queues supporting the specialization"
        );

        NuvkQueueVkFamily queueFamily = this.queueFamilies[familyIndex];
        NuvkQueueFamilyInfo familyInfo = queueFamily.familyInfo;

        // Prior check should ensure this is a valid value.
        int queueIndex = queueFamily.getNextQueueIndex();
        nuvkEnforce(queueIndex >= 0, "Failed to find free queue!");

        vkGetDeviceQueue(device, familyInfo.index, queueIndex, &queue);
        queueFamily.assignedQueues[queueIndex] = nogc_new!NuvkQueueVk(nuvkDevice, queue, familyInfo, queueIndex, count);
        
        return queueFamily.assignedQueues[queueIndex];
    }

    /**
        Removes a command queue
    */
    final
    bool removeQueue(NuvkQueueVk queue) {
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

