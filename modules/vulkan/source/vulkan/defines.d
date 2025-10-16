/**
 * 
 */
module vulkan.defines;


enum VK_NULL_HANDLE = null;
enum VKSC_API_VARIANT = 1;

pragma(inline, true)
uint VK_MAKE_VERSION(uint major, uint minor, uint patch) @nogc nothrow {
	return (major << 22) | (minor << 12) | patch;
}

pragma(inline, true)
uint VK_VERSION_MAJOR(uint version_) @nogc nothrow {
	return version_ >> 22;
}

pragma(inline, true)
uint VK_VERSION_MINOR(uint version_) @nogc nothrow {
	return (version_ >> 12) & 0x3FFU;
}

pragma(inline, true)
uint VK_VERSION_PATCH(uint version_) @nogc nothrow {
	return version_ & 0xFFFU;
}

pragma(inline, true)
uint VK_MAKE_API_VERSION(uint variant, uint major, uint minor, uint patch) @nogc nothrow {
	return (variant << 29) | (major << 22) | (minor << 12) | patch;
}

pragma(inline, true)
uint VK_API_VERSION_VARIANT(uint version_) @nogc nothrow {
	return version_ >> 29;
}

pragma(inline, true)
uint VK_API_VERSION_MAJOR(uint version_) @nogc nothrow {
	return (version_ >> 22) & 0x7FU;
}

pragma(inline, true)
uint VK_API_VERSION_MINOR(uint version_) @nogc nothrow {
	return (version_ >> 12) & 0x3FFU;
}

pragma(inline, true)
uint VK_API_VERSION_PATCH(uint version_) @nogc nothrow {
	return version_ & 0xFFFU;
}