/**
 * VK_NV_display_stereo (Instance)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.display_stereo;

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

public import vulkan.khr.get_display_properties2;
public import vulkan.khr.display;

enum VK_NV_DISPLAY_STEREO_SPEC_VERSION = 1;
enum VK_NV_DISPLAY_STEREO_EXTENSION_NAME = "VK_NV_display_stereo";

struct VkDisplaySurfaceStereoCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_SURFACE_STEREO_CREATE_INFO_NV;
    const(void)* pNext;
    VkDisplaySurfaceStereoTypeNV stereoType;
}

enum VkDisplaySurfaceStereoTypeNV {
    VK_DISPLAY_SURFACE_STEREO_TYPE_NONE_NV = 0,
    VK_DISPLAY_SURFACE_STEREO_TYPE_ONBOARD_DIN_NV = 1,
    VK_DISPLAY_SURFACE_STEREO_TYPE_HDMI_3D_NV = 2,
    VK_DISPLAY_SURFACE_STEREO_TYPE_INBAND_DISPLAYPORT_NV = 3,
}

enum VK_DISPLAY_SURFACE_STEREO_TYPE_NONE_NV = VkDisplaySurfaceStereoTypeNV.VK_DISPLAY_SURFACE_STEREO_TYPE_NONE_NV;
enum VK_DISPLAY_SURFACE_STEREO_TYPE_ONBOARD_DIN_NV = VkDisplaySurfaceStereoTypeNV.VK_DISPLAY_SURFACE_STEREO_TYPE_ONBOARD_DIN_NV;
enum VK_DISPLAY_SURFACE_STEREO_TYPE_HDMI_3D_NV = VkDisplaySurfaceStereoTypeNV.VK_DISPLAY_SURFACE_STEREO_TYPE_HDMI_3D_NV;
enum VK_DISPLAY_SURFACE_STEREO_TYPE_INBAND_DISPLAYPORT_NV = VkDisplaySurfaceStereoTypeNV.VK_DISPLAY_SURFACE_STEREO_TYPE_INBAND_DISPLAYPORT_NV;

struct VkDisplayModeStereoPropertiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_DISPLAY_MODE_STEREO_PROPERTIES_NV;
    const(void)* pNext;
    VkBool32 hdmi3DSupported;
}
