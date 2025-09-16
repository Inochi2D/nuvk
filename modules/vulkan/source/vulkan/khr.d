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

//
//                  VK_KHR_sampler_mirror_clamp_to_edge
//
enum uint VK_KHR_SAMPLER_MIRROR_CLAMP_TO_EDGE_SPEC_VERSION = 3;
enum string VK_KHR_SAMPLER_MIRROR_CLAMP_TO_EDGE_EXTENSION_NAME = "VK_KHR_sampler_mirror_clamp_to_edge";

//
//                  VK_KHR_multiview
//
enum uint VK_KHR_MULTIVIEW_SPEC_VERSION =     1;
enum string VK_KHR_MULTIVIEW_EXTENSION_NAME =   "VK_KHR_multiview";

alias VkRenderPassMultiviewCreateInfoKHR = VkRenderPassMultiviewCreateInfo;
alias VkPhysicalDeviceMultiviewFeaturesKHR = VkPhysicalDeviceMultiviewFeatures;
alias VkPhysicalDeviceMultiviewPropertiesKHR = VkPhysicalDeviceMultiviewProperties;

//
//                  VK_KHR_shader_draw_parameters
//
enum uint VK_KHR_SHADER_DRAW_PARAMETERS_SPEC_VERSION = 1;
enum string VK_KHR_SHADER_DRAW_PARAMETERS_EXTENSION_NAME = "VK_KHR_shader_draw_parameters";

//
//                  VK_KHR_shader_float16_int8
//
enum uint VK_KHR_SHADER_FLOAT16_INT8_SPEC_VERSION = 1;
enum string VK_KHR_SHADER_FLOAT16_INT8_EXTENSION_NAME = "VK_KHR_shader_float16_int8";
alias VkPhysicalDeviceShaderFloat16Int8FeaturesKHR = VkPhysicalDeviceShaderFloat16Int8Features;
alias VkPhysicalDeviceFloat16Int8FeaturesKHR = VkPhysicalDeviceShaderFloat16Int8Features;

//
//                  VK_KHR_16bit_storage
//
enum uint VK_KHR_16BIT_STORAGE_SPEC_VERSION = 1;
enum string VK_KHR_16BIT_STORAGE_EXTENSION_NAME = "VK_KHR_16bit_storage";
alias VkPhysicalDevice16BitStorageFeaturesKHR = VkPhysicalDevice16BitStorageFeatures;
