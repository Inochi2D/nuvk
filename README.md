# NuVK

Library which provides a loader and utilities for Vulkan, including the nuvk SPIR-V shader introspection
and compilation framework.

## Building
The Vulkan SDK must be installed on your system, as NuVK links directly to the `vulkan-1` link loader,
on Windows it adds `%VULKAN_SDK%\Lib` to the library search path.

## Extensions
Some extensions may be preloaded by setting the version specifier for the extension in the dub versions
for your project. Eg. `VK_KHR_swapchain` will bind all of the swapchain functionality, given that
the Vulkan SDK you have installed features them.

## Minimum Version
The minimum version for NuVK is Vulkan 1.3, mainly due to the additions in relation to dynamic rendering
it brings.