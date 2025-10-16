module vulkan.platforms.windows;

alias HANDLE = void*;

alias HINSTANCE = HANDLE;
alias HWND = HANDLE;
alias HMONITOR = HANDLE;

alias LPCWSTR = const(wchar)*;

struct SECURITY_ATTRIBUTES {
    uint nLength;
    void* lpSecurityDescriptor;
    int bInheritHandle;
}

alias DWORD = uint;