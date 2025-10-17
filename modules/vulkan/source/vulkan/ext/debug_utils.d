/**
 * VK_EXT_debug_utils (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.debug_utils;

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

struct VK_EXT_debug_utils {
    
    @VkProcName("vkSetDebugUtilsObjectNameEXT")
    PFN_vkSetDebugUtilsObjectNameEXT vkSetDebugUtilsObjectNameEXT;
    
    @VkProcName("vkSetDebugUtilsObjectTagEXT")
    PFN_vkSetDebugUtilsObjectTagEXT vkSetDebugUtilsObjectTagEXT;
    
    @VkProcName("vkQueueBeginDebugUtilsLabelEXT")
    PFN_vkQueueBeginDebugUtilsLabelEXT vkQueueBeginDebugUtilsLabelEXT;
    
    @VkProcName("vkQueueEndDebugUtilsLabelEXT")
    PFN_vkQueueEndDebugUtilsLabelEXT vkQueueEndDebugUtilsLabelEXT;
    
    @VkProcName("vkQueueInsertDebugUtilsLabelEXT")
    PFN_vkQueueInsertDebugUtilsLabelEXT vkQueueInsertDebugUtilsLabelEXT;
    
    @VkProcName("vkCmdBeginDebugUtilsLabelEXT")
    PFN_vkCmdBeginDebugUtilsLabelEXT vkCmdBeginDebugUtilsLabelEXT;
    
    @VkProcName("vkCmdEndDebugUtilsLabelEXT")
    PFN_vkCmdEndDebugUtilsLabelEXT vkCmdEndDebugUtilsLabelEXT;
    
    @VkProcName("vkCmdInsertDebugUtilsLabelEXT")
    PFN_vkCmdInsertDebugUtilsLabelEXT vkCmdInsertDebugUtilsLabelEXT;
    
    @VkProcName("vkCreateDebugUtilsMessengerEXT")
    PFN_vkCreateDebugUtilsMessengerEXT vkCreateDebugUtilsMessengerEXT;
    
    @VkProcName("vkDestroyDebugUtilsMessengerEXT")
    PFN_vkDestroyDebugUtilsMessengerEXT vkDestroyDebugUtilsMessengerEXT;
    
    @VkProcName("vkSubmitDebugUtilsMessageEXT")
    PFN_vkSubmitDebugUtilsMessageEXT vkSubmitDebugUtilsMessageEXT;
}

enum VK_EXT_DEBUG_UTILS_SPEC_VERSION = 2;
enum VK_EXT_DEBUG_UTILS_EXTENSION_NAME = "VK_EXT_debug_utils";

alias PFN_vkDebugUtilsMessengerCallbackEXT = VkBool32 function(
    VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
    VkDebugUtilsMessageTypeFlagsEXT messageTypes,
    const(VkDebugUtilsMessengerCallbackDataEXT)* pCallbackData,
    void* pUserData,
);

struct VkDebugUtilsLabelEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_LABEL_EXT;
    const(void)* pNext;
    const(char)* pLabelName;
    float[4] color;
}

enum VkDebugUtilsMessageSeverityFlagBitsEXT : uint {
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT = 1,
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT = 16,
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT = 256,
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT = 4096,
}

enum VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT = VkDebugUtilsMessageSeverityFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT = VkDebugUtilsMessageSeverityFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT = VkDebugUtilsMessageSeverityFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT = VkDebugUtilsMessageSeverityFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;

alias VkDebugUtilsMessageSeverityFlagsEXT = VkBitFlagsBase!(VkFlags, VkDebugUtilsMessageSeverityFlagBitsEXT);

enum VkDebugUtilsMessageTypeFlagBitsEXT : uint {
    VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT = 1,
    VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT = 2,
    VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT = 4,
    VK_DEBUG_UTILS_MESSAGE_TYPE_DEVICE_ADDRESS_BINDING_BIT_EXT = 8,
}

enum VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT = VkDebugUtilsMessageTypeFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT = VkDebugUtilsMessageTypeFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT = VkDebugUtilsMessageTypeFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
enum VK_DEBUG_UTILS_MESSAGE_TYPE_DEVICE_ADDRESS_BINDING_BIT_EXT = VkDebugUtilsMessageTypeFlagBitsEXT.VK_DEBUG_UTILS_MESSAGE_TYPE_DEVICE_ADDRESS_BINDING_BIT_EXT;

alias VkDebugUtilsMessageTypeFlagsEXT = VkBitFlagsBase!(VkFlags, VkDebugUtilsMessageTypeFlagBitsEXT);

struct VkDebugUtilsMessengerCallbackDataEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT;
    const(void)* pNext;
    VkFlags flags;
    const(char)* pMessageIdName;
    int messageIdNumber;
    const(char)* pMessage;
    uint queueLabelCount;
    const(VkDebugUtilsLabelEXT)* pQueueLabels;
    uint cmdBufLabelCount;
    const(VkDebugUtilsLabelEXT)* pCmdBufLabels;
    uint objectCount;
    const(VkDebugUtilsObjectNameInfoEXT)* pObjects;
}

alias VkDebugUtilsMessengerCallbackDataFlagsEXT = VkFlags;
alias VkDebugUtilsMessengerCreateFlagsEXT = VkFlags;

struct VkDebugUtilsMessengerCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
    const(void)* pNext;
    VkFlags flags;
    VkFlags messageSeverity;
    VkFlags messageType;
    PFN_vkDebugUtilsMessengerCallbackEXT pfnUserCallback;
    void* pUserData;
}

alias VkDebugUtilsMessengerEXT = OpaqueHandle!("VkDebugUtilsMessengerEXT");

struct VkDebugUtilsObjectNameInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT;
    const(void)* pNext;
    VkObjectType objectType;
    ulong objectHandle;
    const(char)* pObjectName;
}

struct VkDebugUtilsObjectTagInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_TAG_INFO_EXT;
    const(void)* pNext;
    VkObjectType objectType;
    ulong objectHandle;
    ulong tagName;
    size_t tagSize;
    const(void)* pTag;
}

alias PFN_vkSetDebugUtilsObjectNameEXT = VkResult function(
    VkDevice device,
    const(VkDebugUtilsObjectNameInfoEXT)* pNameInfo,
);

alias PFN_vkSetDebugUtilsObjectTagEXT = VkResult function(
    VkDevice device,
    const(VkDebugUtilsObjectTagInfoEXT)* pTagInfo,
);

alias PFN_vkQueueBeginDebugUtilsLabelEXT = void function(
    VkQueue queue,
    const(VkDebugUtilsLabelEXT)* pLabelInfo,
);

alias PFN_vkQueueEndDebugUtilsLabelEXT = void function(
    VkQueue queue,
);

alias PFN_vkQueueInsertDebugUtilsLabelEXT = void function(
    VkQueue queue,
    const(VkDebugUtilsLabelEXT)* pLabelInfo,
);

alias PFN_vkCmdBeginDebugUtilsLabelEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkDebugUtilsLabelEXT)* pLabelInfo,
);

alias PFN_vkCmdEndDebugUtilsLabelEXT = void function(
    VkCommandBuffer commandBuffer,
);

alias PFN_vkCmdInsertDebugUtilsLabelEXT = void function(
    VkCommandBuffer commandBuffer,
    const(VkDebugUtilsLabelEXT)* pLabelInfo,
);

alias PFN_vkCreateDebugUtilsMessengerEXT = VkResult function(
    VkInstance instance,
    const(VkDebugUtilsMessengerCreateInfoEXT)* pCreateInfo,
    const(VkAllocationCallbacks)* pAllocator,
    ref VkDebugUtilsMessengerEXT pMessenger,
);

alias PFN_vkDestroyDebugUtilsMessengerEXT = void function(
    VkInstance instance,
    VkDebugUtilsMessengerEXT messenger,
    const(VkAllocationCallbacks)* pAllocator,
);

alias PFN_vkSubmitDebugUtilsMessageEXT = void function(
    VkInstance instance,
    VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
    VkDebugUtilsMessageTypeFlagsEXT messageTypes,
    const(VkDebugUtilsMessengerCallbackDataEXT)* pCallbackData,
);
