/**
 * VK_NV_low_latency2 (Device)
 * 
 * Author:
 *     NVIDIA Corporation
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.nv.low_latency2;

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

public import vulkan.khr.present_id;
public import vulkan.khr.present_id2;
version (VK_VERSION_1_2) {} else {
    public import vulkan.khr.timeline_semaphore;
}

struct VK_NV_low_latency2 {
    
    @VkProcName("vkSetLatencySleepModeNV")
    PFN_vkSetLatencySleepModeNV vkSetLatencySleepModeNV;
    
    @VkProcName("vkLatencySleepNV")
    PFN_vkLatencySleepNV vkLatencySleepNV;
    
    @VkProcName("vkSetLatencyMarkerNV")
    PFN_vkSetLatencyMarkerNV vkSetLatencyMarkerNV;
    
    @VkProcName("vkGetLatencyTimingsNV")
    PFN_vkGetLatencyTimingsNV vkGetLatencyTimingsNV;
    
    @VkProcName("vkQueueNotifyOutOfBandNV")
    PFN_vkQueueNotifyOutOfBandNV vkQueueNotifyOutOfBandNV;
}

enum VK_NV_LOW_LATENCY_2_SPEC_VERSION = 2;
enum VK_NV_LOW_LATENCY_2_EXTENSION_NAME = "VK_NV_low_latency2";

struct VkLatencySleepModeInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_LATENCY_SLEEP_MODE_INFO_NV;
    const(void)* pNext;
    VkBool32 lowLatencyMode;
    VkBool32 lowLatencyBoost;
    uint minimumIntervalUs;
}

struct VkLatencySleepInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_LATENCY_SLEEP_INFO_NV;
    const(void)* pNext;
    VkSemaphore signalSemaphore;
    ulong value;
}

struct VkSetLatencyMarkerInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_SET_LATENCY_MARKER_INFO_NV;
    const(void)* pNext;
    ulong presentID;
    VkLatencyMarkerNV marker;
}

struct VkGetLatencyMarkerInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_GET_LATENCY_MARKER_INFO_NV;
    const(void)* pNext;
    uint timingCount;
    VkLatencyTimingsFrameReportNV* pTimings;
}

struct VkLatencyTimingsFrameReportNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_LATENCY_TIMINGS_FRAME_REPORT_NV;
    const(void)* pNext;
    ulong presentID;
    ulong inputSampleTimeUs;
    ulong simStartTimeUs;
    ulong simEndTimeUs;
    ulong renderSubmitStartTimeUs;
    ulong renderSubmitEndTimeUs;
    ulong presentStartTimeUs;
    ulong presentEndTimeUs;
    ulong driverStartTimeUs;
    ulong driverEndTimeUs;
    ulong osRenderQueueStartTimeUs;
    ulong osRenderQueueEndTimeUs;
    ulong gpuRenderStartTimeUs;
    ulong gpuRenderEndTimeUs;
}

enum VkLatencyMarkerNV {
    VK_LATENCY_MARKER_SIMULATION_START_NV = 0,
    VK_LATENCY_MARKER_SIMULATION_END_NV = 1,
    VK_LATENCY_MARKER_RENDERSUBMIT_START_NV = 2,
    VK_LATENCY_MARKER_RENDERSUBMIT_END_NV = 3,
    VK_LATENCY_MARKER_PRESENT_START_NV = 4,
    VK_LATENCY_MARKER_PRESENT_END_NV = 5,
    VK_LATENCY_MARKER_INPUT_SAMPLE_NV = 6,
    VK_LATENCY_MARKER_TRIGGER_FLASH_NV = 7,
    VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_START_NV = 8,
    VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_END_NV = 9,
    VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_START_NV = 10,
    VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_END_NV = 11,
}

enum VK_LATENCY_MARKER_SIMULATION_START_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_SIMULATION_START_NV;
enum VK_LATENCY_MARKER_SIMULATION_END_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_SIMULATION_END_NV;
enum VK_LATENCY_MARKER_RENDERSUBMIT_START_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_RENDERSUBMIT_START_NV;
enum VK_LATENCY_MARKER_RENDERSUBMIT_END_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_RENDERSUBMIT_END_NV;
enum VK_LATENCY_MARKER_PRESENT_START_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_PRESENT_START_NV;
enum VK_LATENCY_MARKER_PRESENT_END_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_PRESENT_END_NV;
enum VK_LATENCY_MARKER_INPUT_SAMPLE_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_INPUT_SAMPLE_NV;
enum VK_LATENCY_MARKER_TRIGGER_FLASH_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_TRIGGER_FLASH_NV;
enum VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_START_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_START_NV;
enum VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_END_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_END_NV;
enum VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_START_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_START_NV;
enum VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_END_NV = VkLatencyMarkerNV.VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_END_NV;

struct VkLatencySubmissionPresentIdNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_LATENCY_SUBMISSION_PRESENT_ID_NV;
    const(void)* pNext;
    ulong presentID;
}

struct VkSwapchainLatencyCreateInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_SWAPCHAIN_LATENCY_CREATE_INFO_NV;
    const(void)* pNext;
    VkBool32 latencyModeEnable;
}

struct VkOutOfBandQueueTypeInfoNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_OUT_OF_BAND_QUEUE_TYPE_INFO_NV;
    const(void)* pNext;
    VkOutOfBandQueueTypeNV queueType;
}

enum VkOutOfBandQueueTypeNV {
    VK_OUT_OF_BAND_QUEUE_TYPE_RENDER_NV = 0,
    VK_OUT_OF_BAND_QUEUE_TYPE_PRESENT_NV = 1,
}

enum VK_OUT_OF_BAND_QUEUE_TYPE_RENDER_NV = VkOutOfBandQueueTypeNV.VK_OUT_OF_BAND_QUEUE_TYPE_RENDER_NV;
enum VK_OUT_OF_BAND_QUEUE_TYPE_PRESENT_NV = VkOutOfBandQueueTypeNV.VK_OUT_OF_BAND_QUEUE_TYPE_PRESENT_NV;

struct VkLatencySurfaceCapabilitiesNV {
    VkStructureType sType = VK_STRUCTURE_TYPE_LATENCY_SURFACE_CAPABILITIES_NV;
    const(void)* pNext;
    uint presentModeCount;
    VkPresentModeKHR* pPresentModes;
}

alias PFN_vkSetLatencySleepModeNV = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    const(VkLatencySleepModeInfoNV)* pSleepModeInfo,
);

alias PFN_vkLatencySleepNV = VkResult function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    const(VkLatencySleepInfoNV)* pSleepInfo,
);

alias PFN_vkSetLatencyMarkerNV = void function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    const(VkSetLatencyMarkerInfoNV)* pLatencyMarkerInfo,
);

alias PFN_vkGetLatencyTimingsNV = void function(
    VkDevice device,
    VkSwapchainKHR swapchain,
    VkGetLatencyMarkerInfoNV* pLatencyMarkerInfo,
);

alias PFN_vkQueueNotifyOutOfBandNV = void function(
    VkQueue queue,
    const(VkOutOfBandQueueTypeInfoNV)* pQueueTypeInfo,
);
