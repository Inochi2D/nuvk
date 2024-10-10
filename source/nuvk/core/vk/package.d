/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Nuvk - Vulkan implementation
*/
module nuvk.core.vk;
import erupted.platform_extensions;
import erupted.vulkan_lib_loader;

public import erupted.types;
public import erupted.functions;

version(Windows)
    mixin Platform_Extensions!USE_PLATFORM_WIN32_KHR;
else
    mixin Platform_Extensions!();

import nuvk.core;
import numem.all;

public import nuvk.core.vk.buffer;
public import nuvk.core.vk.context;
public import nuvk.core.vk.device;
public import nuvk.core.vk.shader;
public import nuvk.core.vk.sync;
public import nuvk.core.vk.queue;
public import nuvk.core.vk.cmdbuffer;
public import nuvk.core.vk.texture;
public import nuvk.core.vk.surface;
public import nuvk.core.vk.devinfo;

// Sharing
version(Windows) {
    import core.sys.windows.windef;
    import core.sys.windows.winbase : CloseHandle;
    enum NuvkVkMemorySharingFlagBit = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT;
    enum NuvkSemaphoreVkSharingFlagBit = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT;

    enum NuvkVkMemorySharingExtName = "VK_KHR_external_memory_win32";
    enum NuvkSemaphoreVkSharingExtName = "VK_KHR_external_semaphore_win32";
} else {
    import core.sys.posix.unistd : close;
    enum NuvkVkMemorySharingFlagBit = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT;
    enum NuvkSemaphoreVkSharingFlagBit = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT;

    enum NuvkVkMemorySharingExtName = "VK_KHR_external_memory_fd";
    enum NuvkSemaphoreVkSharingExtName = "VK_KHR_external_semaphore_fd";
}

private {
    bool nuvkVkIsInitialized = false;
}

void nuvkInitVulkan() @nogc {
    if (!nuvkVkIsInitialized) {
        nuvkEnforce(loadGlobalLevelFunctions(), "Failed to load Vulkan");
        nuvkEnforce(nuvkGetVulkanVersion() >= VK_API_VERSION_1_3, "Vulkan 1.3 required.");
        nuvkVkIsInitialized = true;
    }
}

/**
    Gets the supported instance vulkan version
*/
uint nuvkGetVulkanVersion() @nogc {
    uint ver;
    vkEnumerateInstanceVersion(&ver);
    return ver;
}


/**
    Gets the share handle for the specified memory
*/
ulong nuvkGetSharedHandleVk(VkDevice device, VkDeviceMemory memory) @nogc {
    ulong shareId;
    version(Windows) {
        VkMemoryGetWin32HandleInfoKHR getInfo;
        getInfo.memory = memory;
        getInfo.handleType = NuvkVkMemorySharingFlagBit;
        vkGetMemoryWin32HandleKHR(device, &getInfo, cast(HANDLE*)&shareId);
    } else {
        VkMemoryGetFdInfoKHR getInfo;
        getInfo.memory = memory;
        getInfo.handleType = NuvkVkMemorySharingFlagBit;
        vkGetMemoryFdKHR(device, &getInfo, cast(int*)&shareId);
    }
    return shareId;
}

/**
    Gets the share handle for the specified semaphore
*/
ulong nuvkGetSharedHandleVk(VkDevice device, VkSemaphore semaphore) @nogc {
    ulong shareId;
    version(Windows) {
        VkSemaphoreGetWin32HandleInfoKHR getInfo;
        getInfo.semaphore = semaphore;
        getInfo.handleType = NuvkSemaphoreVkSharingFlagBit;
        vkGetSemaphoreWin32HandleKHR(device, &getInfo, cast(HANDLE*)&shareId);
    } else {
        VkSemaphoreGetFdInfoKHR getInfo;
        getInfo.semaphore = semaphore;
        getInfo.handleType = NuvkSemaphoreVkSharingFlagBit;
        vkGetSemaphoreFdKHR(device, &getInfo, cast(int*)&shareId);
    }
    return shareId;
}

/**
    Closes a shared handle.
*/
bool nuvkCloseSharedHandleVk(ulong handle) @nogc {

    // Handle 0 is invalid.
    if (handle == 0)
        return false;

    version(Windows) {
        return CloseHandle(cast(HANDLE)handle) == TRUE;
    } else {
        return close(cast(int)handle) == 0;
    }
}