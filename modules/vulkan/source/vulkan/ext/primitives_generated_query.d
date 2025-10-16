/**
 * VK_EXT_primitives_generated_query (Device)
 * 
 * Author:
 *     Multivendor
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.ext.primitives_generated_query;

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

public import vulkan.ext.transform_feedback;

enum VK_EXT_PRIMITIVES_GENERATED_QUERY_SPEC_VERSION = 1;
enum VK_EXT_PRIMITIVES_GENERATED_QUERY_EXTENSION_NAME = "VK_EXT_primitives_generated_query";

struct VkPhysicalDevicePrimitivesGeneratedQueryFeaturesEXT {
    VkStructureType sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIMITIVES_GENERATED_QUERY_FEATURES_EXT;
    void* pNext;
    VkBool32 primitivesGeneratedQuery;
    VkBool32 primitivesGeneratedQueryWithRasterizerDiscard;
    VkBool32 primitivesGeneratedQueryWithNonZeroStreams;
}
