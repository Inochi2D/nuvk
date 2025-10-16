/**
 * VK_ARM_scheduling_controls
 * 
 * Author:
 *     ARM Limited
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.arm.scheduling_controls;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.arm.shader_core_builtins;

enum VK_ARM_SCHEDULING_CONTROLS_SPEC_VERSION = 1;
enum VK_ARM_SCHEDULING_CONTROLS_EXTENSION_NAME = "VK_ARM_scheduling_controls";

struct VkDeviceQueueShaderCoreControlCreateInfoARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_SHADER_CORE_CONTROL_CREATE_INFO_ARM;
    void* pNext;
    uint shaderCoreCount;
}

struct VkPhysicalDeviceSchedulingControlsFeaturesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_FEATURES_ARM;
    void* pNext;
    VkBool32 schedulingControls;
}

struct VkPhysicalDeviceSchedulingControlsPropertiesARM {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_PROPERTIES_ARM;
    void* pNext;
    VkFlags64 schedulingControlsFlags;
}

alias VkPhysicalDeviceSchedulingControlsFlagsARM = VkFlags64;

enum VkPhysicalDeviceSchedulingControlsFlagBitsARM : ulong {
    VK_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_SHADER_CORE_COUNT_ARM = 1,
}

enum VK_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_SHADER_CORE_COUNT_ARM = VkPhysicalDeviceSchedulingControlsFlagBitsARM.VK_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_SHADER_CORE_COUNT_ARM;
