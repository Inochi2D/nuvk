/**
    Nuvk Vulkan Error Handling
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.eh;
import vulkan.core;
import numem;

/**
    Enforces that the given VkResult code is a success code,
    otherwise throws a $(D VkException).

    Params:
        result =    The VkResult code to enforce as a success.
        file =      The file the check was performed in.
        line =      The line of that file the check was performed in.
*/
void vkEnforce(VkResult result, string file = __FILE__, uint line = __LINE__) @nogc {
    if (result < 0)
        throw nogc_new!VkException(result, file, line);
}

/**
    An exception thrown from Vulkan based on a VkResult.
*/
class VkException : NuException {
public:
@nogc:

    /**
        The Vulkan Result Code
    */
    VkResult code;

    /**
        Constructs a VkException from a VkResult.
    */
    this(VkResult result, string file = __FILE__, uint line = __LINE__) {
        super(result.fromVkResult(), null, file, line);
        this.code = result;
    }
}

private
string fromVkResult(VkResult value) @nogc nothrow {
    switch(value) {
        default:                                                    return "Unknown Error";
        case VK_ERROR_OUT_OF_HOST_MEMORY:                           return "Host memory allocation has failed.";
        case VK_ERROR_OUT_OF_DEVICE_MEMORY:                         return "Device memory allocation has failed.";
        case VK_ERROR_INITIALIZATION_FAILED:                        return "Initialization of the object could not be completed.";
        case VK_ERROR_DEVICE_LOST:                                  return "The logical or physical device has been lost.";
        case VK_ERROR_MEMORY_MAP_FAILED:                            return "Mapping of the memory object has failed.";
        case VK_ERROR_LAYER_NOT_PRESENT:                            return "Requested layer is not present or could not be loaded.";
        case VK_ERROR_EXTENSION_NOT_PRESENT:                        return "Requested extension is not supported.";
        case VK_ERROR_FEATURE_NOT_PRESENT:                          return "Requested feature is not supported.";
        case VK_ERROR_INCOMPATIBLE_DRIVER:                          return "Requested version of Vulkan is not supported by the driver or is otherwise incompatible.";
        case VK_ERROR_TOO_MANY_OBJECTS:                             return "Too many objects of the type have already been created.";
        case VK_ERROR_FORMAT_NOT_SUPPORTED:                         return "Requested format is not supported on this device.";
        case VK_ERROR_SURFACE_LOST_KHR:                             return "Surface is no longer available.";
        case VK_ERROR_NATIVE_WINDOW_IN_USE_KHR:                     return "The requested window is already in use.";
        case VK_ERROR_OUT_OF_DATE_KHR:                              return "The surface is out of date.";
        case VK_ERROR_INCOMPATIBLE_DISPLAY_KHR:                     return "Display is incompatible with the swapchain.";
        case VK_ERROR_INVALID_SHADER_NV:                            return "One or more shaders failed to compile or link.";
        case VK_ERROR_OUT_OF_POOL_MEMORY:                           return "Pool memory allocation has failed.";
        case VK_ERROR_INVALID_EXTERNAL_HANDLE:                      return "External handle is not a valid handle.";
        case VK_ERROR_FRAGMENTATION:                                return "Could not create discriptor pool due to fragmentation.";
        case VK_ERROR_INVALID_DEVICE_ADDRESS_EXT:                   return "The requested address is not available.";
        case VK_ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT:          return "Full-screen exclusive mode lost or unavailable.";
        case VK_ERROR_VALIDATION_FAILED:                            return "Validation failed.";
        case VK_ERROR_COMPRESSION_EXHAUSTED_EXT:                    return "Compression resources were exhausted.";
        case VK_ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR:                return "Image Usage is unsupported.";
        case VK_ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR:       return "Picture Layout is not supported.";
        case VK_ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR:    return "Operation is not supported.";
        case VK_ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR:       return "Format is not supported.";
        case VK_ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR:        return "Codec is not supported.";
        case VK_ERROR_NOT_PERMITTED:                                return "Permission denied.";
        case VK_ERROR_NOT_ENOUGH_SPACE_KHR:                         return "Not enough space.";
    }
}