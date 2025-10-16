/**
 * VK_HUAWEI_hdr_vivid (Device)
 * 
 * Author:
 *     Huawei Technologies Co. Ltd.
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.huawei.hdr_vivid;

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

public import vulkan.ext.hdr_metadata;
public import vulkan.khr.swapchain;
version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
}

enum VK_HUAWEI_HDR_VIVID_SPEC_VERSION = 1;
enum VK_HUAWEI_HDR_VIVID_EXTENSION_NAME = "VK_HUAWEI_hdr_vivid";

struct VkPhysicalDeviceHdrVividFeaturesHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HDR_VIVID_FEATURES_HUAWEI;
    void* pNext;
    VkBool32 hdrVivid;
}

struct VkHdrVividDynamicMetadataHUAWEI {
    VkStructureType sType = VK_STRUCTURE_TYPE_HDR_VIVID_DYNAMIC_METADATA_HUAWEI;
    const(void)* pNext;
    size_t dynamicMetadataSize;
    const(void)* pDynamicMetadata;
}
