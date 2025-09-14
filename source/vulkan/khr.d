/**
    VK_KHR Extensions
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.khr;
import vulkan.core;

public import vulkan.khr_surface;
public import vulkan.khr_swapchain;
public import vulkan.khr_display;
public import vulkan.khr_display_swapchain;

extern (System) @nogc nothrow:

enum uint VK_KHR_SAMPLER_MIRROR_CLAMP_TO_EDGE_SPEC_VERSION = 3;
enum string VK_KHR_SAMPLER_MIRROR_CLAMP_TO_EDGE_EXTENSION_NAME = "VK_KHR_sampler_mirror_clamp_to_edge";