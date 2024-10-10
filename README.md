# NuVK

NuVK is a library which wraps Vulkan and Metal to a shared API.  
This library aims to make maintaining Inochi2D apps easier.


## Why not use WGPU/SDL3_GPU/etc?
We have a hard requirement of being able to export buffers, textures and synchronization primitives on both Windows, macOS and Linux.

Current graphics API wrappers like WGPU are more targeted at games and web and as such they do not expose the neccesary handles,
to allow this.

This library is just meant for use in Inochi Creator and Inochi Session, but it may be used elsewhere as well.

Contributions are welcome.

## What's `nuvk.compiler` about?

To faciliate ease of use between Vulkan and Metal with Nuvk, we'll be writing our own shader language.

This shader language will compile to SPIRV, then be transpiled via SPIRV-Cross, if neccesary.

This layer also allows early introspection of the SPIRV code to allow automatic creation of descriptor sets and the like.

## Examples

Examples can be found in the `examples/` directory.

## System Requirements

### Vulkan
Vulkan 1.3 is required to run nuvk on Windows and Linux.

#### Required Validation Layers (debug mode):
 * `VK_LAYER_KHRONOS_validation`

#### Required Instance Extensions
 * `VK_KHR_surface`

#### Required Device Extensions
 * `VK_EXT_primitive_topology_list_restart`
 * `VK_EXT_custom_border_color`
 * `VK_KHR_swapchain`
 * `VK_EXT_extended_dynamic_state3`
 * `VK_EXT_shader_object`

#### Optional Extensions
 * `VK_EXT_shader_tile_image`
 * `VK_KHR_external_memory`
 * `VK_KHR_external_memory_win32` (Windows)
 * `VK_KHR_external_memory_fd` (POSIX)
 * `VK_KHR_external_semaphore`
 * `VK_KHR_external_semaphore_win32` (Windows)
 * `VK_KHR_external_semaphore_fd` (POSIX)