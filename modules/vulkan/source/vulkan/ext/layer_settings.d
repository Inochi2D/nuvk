/**
 * VK_EXT_layer_settings (Instance)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.layer_settings;

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

enum VK_EXT_LAYER_SETTINGS_SPEC_VERSION = 2;
enum VK_EXT_LAYER_SETTINGS_EXTENSION_NAME = "VK_EXT_layer_settings";

struct VkLayerSettingsCreateInfoEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_LAYER_SETTINGS_CREATE_INFO_EXT;
    const(void)* pNext;
    uint settingCount;
    const(VkLayerSettingEXT)* pSettings;
}

struct VkLayerSettingEXT {
    const(char)* pLayerName;
    const(char)* pSettingName;
    VkLayerSettingTypeEXT type;
    uint valueCount;
    const(void)* pValues;
}

enum VkLayerSettingTypeEXT {
    VK_LAYER_SETTING_TYPE_BOOL32_EXT = 0,
    VK_LAYER_SETTING_TYPE_INT32_EXT = 1,
    VK_LAYER_SETTING_TYPE_INT64_EXT = 2,
    VK_LAYER_SETTING_TYPE_UINT32_EXT = 3,
    VK_LAYER_SETTING_TYPE_UINT64_EXT = 4,
    VK_LAYER_SETTING_TYPE_FLOAT32_EXT = 5,
    VK_LAYER_SETTING_TYPE_FLOAT64_EXT = 6,
    VK_LAYER_SETTING_TYPE_STRING_EXT = 7,
}

enum VK_LAYER_SETTING_TYPE_BOOL32_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_BOOL32_EXT;
enum VK_LAYER_SETTING_TYPE_INT32_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_INT32_EXT;
enum VK_LAYER_SETTING_TYPE_INT64_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_INT64_EXT;
enum VK_LAYER_SETTING_TYPE_UINT32_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_UINT32_EXT;
enum VK_LAYER_SETTING_TYPE_UINT64_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_UINT64_EXT;
enum VK_LAYER_SETTING_TYPE_FLOAT32_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_FLOAT32_EXT;
enum VK_LAYER_SETTING_TYPE_FLOAT64_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_FLOAT64_EXT;
enum VK_LAYER_SETTING_TYPE_STRING_EXT = VkLayerSettingTypeEXT.VK_LAYER_SETTING_TYPE_STRING_EXT;
