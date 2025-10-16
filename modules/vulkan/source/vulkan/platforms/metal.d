module vulkan.platforms.metal;

alias CAMetalLayer = void;
alias MTLDevice_id = void*;
alias MTLCommandQueue_id = void*;
alias MTLBuffer_id = void*;
alias MTLTexture_id = void*;
alias MTLSharedEvent_id = void*;

private struct __IOSurface;
alias IOSurfaceRef = __IOSurface*;