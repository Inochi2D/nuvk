module vulkan.video.defines;

pragma(inline, true)
uint VK_MAKE_VIDEO_STD_VERSION(uint major, uint minor, uint patch) {
    return (major << 22) | (minor << 12) | patch;
}