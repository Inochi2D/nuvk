module vulkan.vk_video.common;


/**
    Creates a Vulkan Video Version
*/
enum uint VK_MAKE_VIDEO_STD_VERSION(uint major, uint minor, uint patch) =
    ((major << 22) | (minor << 12) | (patch));