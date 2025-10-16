module vulkan.platforms.xlib;

import core.stdc.config;

alias XID = c_ulong;
alias VisualID = XID;
alias Window = XID;

struct Display;