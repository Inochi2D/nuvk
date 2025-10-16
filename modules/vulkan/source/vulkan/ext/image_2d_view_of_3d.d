/**
 * VK_EXT_image_2d_view_of_3d
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.image_2d_view_of_3d;

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

version (VK_VERSION_1_1) {} else {
    public import vulkan.khr.get_physical_device_properties2;
    public import vulkan.khr.maintenance1;
}

enum VK_EXT_IMAGE_2D_VIEW_OF_3D_SPEC_VERSION = 1;
enum VK_EXT_IMAGE_2D_VIEW_OF_3D_EXTENSION_NAME = "VK_EXT_image_2d_view_of_3d";

struct VkPhysicalDeviceImage2DViewOf3DFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_2D_VIEW_OF_3D_FEATURES_EXT;
    void* pNext;
    VkBool32 image2DViewOf3D;
    VkBool32 sampler2DViewOf3D;
}
