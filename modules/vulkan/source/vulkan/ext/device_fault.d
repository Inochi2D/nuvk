/**
 * VK_EXT_device_fault (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.device_fault;

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

struct VK_EXT_device_fault {
    
    @VkProcName("vkGetDeviceFaultInfoEXT")
    PFN_vkGetDeviceFaultInfoEXT vkGetDeviceFaultInfoEXT;
}

enum VK_EXT_DEVICE_FAULT_SPEC_VERSION = 2;
enum VK_EXT_DEVICE_FAULT_EXTENSION_NAME = "VK_EXT_device_fault";

struct VkPhysicalDeviceFaultFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FAULT_FEATURES_EXT;
    void* pNext;
    VkBool32 deviceFault;
    VkBool32 deviceFaultVendorBinary;
}

struct VkDeviceFaultCountsEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_FAULT_COUNTS_EXT;
    void* pNext;
    uint addressInfoCount;
    uint vendorInfoCount;
    VkDeviceSize vendorBinarySize;
}

struct VkDeviceFaultInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_DEVICE_FAULT_INFO_EXT;
    void* pNext;
    char[VK_MAX_DESCRIPTION_SIZE] description;
    VkDeviceFaultAddressInfoEXT* pAddressInfos;
    VkDeviceFaultVendorInfoEXT* pVendorInfos;
    void* pVendorBinaryData;
}

struct VkDeviceFaultAddressInfoEXT {
    VkDeviceFaultAddressTypeEXT addressType;
    VkDeviceAddress reportedAddress;
    VkDeviceSize addressPrecision;
}

enum VkDeviceFaultAddressTypeEXT {
    VK_DEVICE_FAULT_ADDRESS_TYPE_NONE_EXT = 0,
    VK_DEVICE_FAULT_ADDRESS_TYPE_READ_INVALID_EXT = 1,
    VK_DEVICE_FAULT_ADDRESS_TYPE_WRITE_INVALID_EXT = 2,
    VK_DEVICE_FAULT_ADDRESS_TYPE_EXECUTE_INVALID_EXT = 3,
    VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_UNKNOWN_EXT = 4,
    VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_INVALID_EXT = 5,
    VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_FAULT_EXT = 6,
}

enum VK_DEVICE_FAULT_ADDRESS_TYPE_NONE_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_NONE_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_READ_INVALID_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_READ_INVALID_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_WRITE_INVALID_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_WRITE_INVALID_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_EXECUTE_INVALID_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_EXECUTE_INVALID_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_UNKNOWN_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_UNKNOWN_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_INVALID_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_INVALID_EXT;
enum VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_FAULT_EXT = VkDeviceFaultAddressTypeEXT.VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_FAULT_EXT;

struct VkDeviceFaultVendorInfoEXT {
    char[VK_MAX_DESCRIPTION_SIZE] description;
    ulong vendorFaultCode;
    ulong vendorFaultData;
}

enum VkDeviceFaultVendorBinaryHeaderVersionEXT {
    VK_DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_ONE_EXT = 1,
}

enum VK_DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_ONE_EXT = VkDeviceFaultVendorBinaryHeaderVersionEXT.VK_DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_ONE_EXT;

struct VkDeviceFaultVendorBinaryHeaderVersionOneEXT {
    uint headerSize;
    VkDeviceFaultVendorBinaryHeaderVersionEXT headerVersion;
    uint vendorID;
    uint deviceID;
    uint driverVersion;
    ubyte[VK_UUID_SIZE] pipelineCacheUUID;
    uint applicationNameOffset;
    uint applicationVersion;
    uint engineNameOffset;
    uint engineVersion;
    uint apiVersion;
}

alias PFN_vkGetDeviceFaultInfoEXT = VkResult function(
    VkDevice device,
    VkDeviceFaultCountsEXT* pFaultCounts,
    VkDeviceFaultInfoEXT* pFaultInfo,
);
