/**
 * VK_MSFT_layered_driver (Device)
 * 
 * Author:
 *     Microsoft Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.msft.layered_driver;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_MSFT_LAYERED_DRIVER_SPEC_VERSION = 1;
enum VK_MSFT_LAYERED_DRIVER_EXTENSION_NAME = "VK_MSFT_layered_driver";

enum VkLayeredDriverUnderlyingApiMSFT {
    VK_LAYERED_DRIVER_UNDERLYING_API_NONE_MSFT = 0,
    VK_LAYERED_DRIVER_UNDERLYING_API_D3D12_MSFT = 1,
}

enum VK_LAYERED_DRIVER_UNDERLYING_API_NONE_MSFT = VkLayeredDriverUnderlyingApiMSFT.VK_LAYERED_DRIVER_UNDERLYING_API_NONE_MSFT;
enum VK_LAYERED_DRIVER_UNDERLYING_API_D3D12_MSFT = VkLayeredDriverUnderlyingApiMSFT.VK_LAYERED_DRIVER_UNDERLYING_API_D3D12_MSFT;

struct VkPhysicalDeviceLayeredDriverPropertiesMSFT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_DRIVER_PROPERTIES_MSFT;
    void* pNext;
    VkLayeredDriverUnderlyingApiMSFT underlyingAPI;
}
