/**
    VK_KHR_win32 Extensions
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.win32;
import vulkan.core;

extern (System) @nogc nothrow:

/**
    SECURITY_ATTRIBUTES
*/
struct SECURITY_ATTRIBUTES {
    uint nLength;
    void* lpSecurityDescriptor;
    int bInheritHandle;
}