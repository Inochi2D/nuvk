module nuvk.core.sharing;
import nuvk.core.types;
import nuvk.core.platform;


/**
    Closes a shared handle.
*/
bool nuvkCloseSharedHandle(NuvkHandleShared handle) @nogc {

    // Handle 0 is invalid.
    if (handle is null)
        return false;

    static if (NuvkIsWindows) {
        
        import core.sys.windows.winbase : CloseHandle;
        import core.sys.windows.windef : HANDLE, TRUE;
        return CloseHandle(cast(HANDLE)handle) == TRUE;
    } else static if (NuvkIsAppleOS) {
        
        import nuvk.apple.port;
        return mach_port_deallocate(mach_task_self(), cast(mach_port_name_t)handle);
    } else static if (NuvkIsPOSIX) {

        import core.sys.posix.unistd : close;
        return close(cast(int)handle) == 0;
    } else {
        static assert(0, "Platform is not supported!");
    }
}