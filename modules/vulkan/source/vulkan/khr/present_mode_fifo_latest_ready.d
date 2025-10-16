/**
 * VK_KHR_present_mode_fifo_latest_ready (Device)
 * 
 * Author:
 *     Khronos
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.khr.present_mode_fifo_latest_ready;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.core;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.swapchain;

enum VK_KHR_PRESENT_MODE_FIFO_LATEST_READY_SPEC_VERSION = 1;
enum VK_KHR_PRESENT_MODE_FIFO_LATEST_READY_EXTENSION_NAME = "VK_KHR_present_mode_fifo_latest_ready";

struct VkPhysicalDevicePresentModeFifoLatestReadyFeaturesKHR {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_MODE_FIFO_LATEST_READY_FEATURES_KHR;
    void* pNext;
    VkBool32 presentModeFifoLatestReady;
}
