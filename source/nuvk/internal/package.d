/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Internal implementation details of nuvk.

    This should not be used directly unless you know what you're doing.

    Importing this module will import all of the available backends.
*/
module nuvk.internal;

/**
    Bitflag over every backend that nuvk supports.

    See [nuvkAvailableBackends].
*/
enum NuvkBackend {
    /// No backend
    none        = 0x00,

    /// Vulkan backend
    vulkan      = 0x01,

    /// Metal backend
    metal       = 0x02, 
}

/**
    Whether the Metal dependency is present.
*/
version(Has_d_metal_binding) enum NuvkHasMetal = true;
else enum NuvkHasMetal = false;

version(has_erupted) enum NuvkHasVulkan = true;
else enum NuvkHasVulkan = false;

/**
    All of the available backends of Nuvk on the current system.

    The available backends depends on the platform and which optional
    dependencies nuvk was compiled with.
*/
__gshared const(NuvkBackend) nuvkAvailableBackends = 
    (NuvkHasMetal ? NuvkBackend.metal : NuvkBackend.none) |
    (NuvkHasVulkan ? NuvkBackend.vulkan : NuvkBackend.none);


static if (NuvkHasMetal) public import nuvk.internal.metal;
static if (NuvkHasVulkan) public import nuvk.internal.vulkan;