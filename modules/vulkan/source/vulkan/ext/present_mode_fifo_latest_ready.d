/**
 * VK_EXT_present_mode_fifo_latest_ready (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.present_mode_fifo_latest_ready;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.core;
import vulkan.khr.present_mode_fifo_latest_ready;

extern (System) @nogc nothrow:

version (VK_VERSION_1_4)
    version = VK_VERSION_1_3;
version (VK_VERSION_1_3)
    version = VK_VERSION_1_2;
version (VK_VERSION_1_2)
    version = VK_VERSION_1_1;

public import vulkan.khr.swapchain;

enum VK_EXT_PRESENT_MODE_FIFO_LATEST_READY_SPEC_VERSION = 1;
enum VK_EXT_PRESENT_MODE_FIFO_LATEST_READY_EXTENSION_NAME = "VK_EXT_present_mode_fifo_latest_ready";

alias VkPhysicalDevicePresentModeFifoLatestReadyFeaturesEXT = VkPhysicalDevicePresentModeFifoLatestReadyFeaturesKHR;
