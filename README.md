# NuVK

Library which provides a loader and utilities for Vulkan, including the nuvk SPIR-V shader introspection
and compilation framework.

## Building
The Vulkan SDK must be installed on your system, as NuVK links directly to the `vulkan-1` link loader,
on Windows it adds `%VULKAN_SDK%\Lib` to the library search path.