module nuvk.apple.port;
import nuvk.core.platform;

public import core.sys.darwin.mach.port;
public import core.sys.darwin.mach.kern_return;
public import core.sys.darwin.mach.semaphore;

static if(NuvkIsAppleOS):
extern(C):

/// IPC Space
struct ipc_space;
alias ipc_space_t = ipc_space*;
alias mach_port_name_t = natural_t;

/// Deallocates a mach port
kern_return_t mach_port_deallocate(ipc_space_t space, mach_port_name_t name);