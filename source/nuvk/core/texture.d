module nuvk.core.texture;
import nuvk.core;

/**
    Texture formats
*/
enum NuvkTextureFormat {

    /**
        Format with one 8-bit normalized unsigned integer component.
    */
    a8Unorm,

    /**
        Format with one 8-bit normalized unsigned integer component, 
        with automatic conversion between sRGB and linear.
    */
    a8UnormSRGB,

    /**
        Format with two 8-bit normalized unsigned integer components.
    */
    rg8Unorm,

    /**
        Format with two 8-bit normalized unsigned integer components, 
        with automatic conversion between sRGB and linear.
    */
    rg8UnormSRGB,

    /**
        RGBA Format with normalized unsigned integer components.
    */
    rgba8Unorm,

    /**
        RGBA Format with normalized unsigned integer components,
        with automatic conversion between sRGB and linear.
    */
    rgba8UnormSRGB,

    /**
        BGRA Format with normalized unsigned integer components.
    */
    bgra8Unorm,

    /**
        BGRA Format with normalized unsigned integer components,
        with automatic conversion between sRGB and linear.
    */
    bgra8UnormSRGB,

    /**
        RGBA Format with 32 bit floating point components.
    */
    rgba32Float,

    /**
        Depth + stencil buffer format
    */
    depthStencil,
}

/**
    Type of the texture
*/
enum NuvkTextureType {

    /**
        Texture is one-dimensional
    */
    texture1d,
    
    /**
        Texture is two-dimensional
    */
    texture2d,

    /**
        Texture is two-dimensional and multi-sampled
    */
    texture2dMultisampled,
    
    /**
        Texture is three-dimensional
    */
    texture3d,
}

/**
    The texture tiling mode
*/
enum NuvkTextureTiling {
    
    /**
        Image is stored linearly in memory
    */
    linear,
    
    /**
        Image is stored in memory in whichever way 
        is most optimal for the GPU.
    */
    optimal,
}

/**
    Various ways a sampler can address an image
*/
enum NuvkSamplerAddressMode {

    /**
        Texture coordinates are clamped between 0.0 to 1.0 (inclusive).
    */
    clampToEdge,
    
    /**
        Between -1.0 to 1.0 the texture is mirrored across the axis.
        Outside -1.0 to 1.0 the texture coordinate is clamped.
    */
    mirrorClampToEdge,

    /**
        Texture coordinates wrap around infinitely in all directions.
    */
    repeat,

    /**
        Texture coordinates wrap around infinitely in all directions,
        the texture coordinates are additionally mirrored in the negative axis.
    */
    mirrorRepeat,

    /**
        Texture coordinates outside of 0.0 to 1.0 use the specified 
        border color instead.
    */
    clampToBorderColor
}

/**
    A filter used during texture sampling
*/
enum NuvkSamplerTextureFilter {

    /**
        Nearest-neighbour filter

        Also called point filtering.
    */
    nearest,

    /**
        Linear filter
    */
    linear
}

/**
    A filter used during texture sampling
*/
enum NuvkSamplerMipmapFilter {

    /**
        Sampler should not use mipmapping
    */
    notMipmapped,

    /**
        The nearest mipmap is selected
    */
    nearest,

    /**
        Linearly interpolates between mipmaps.
    */
    linear
}

/**
    The comparison function used when doing a sample compare
    operation on a depth texture
*/
enum NuvkSamplerCompFunc {

    /**
        Test never passes
    */
    never,

    /**
        Test passes if the value in the buffer is less
        than the incoming value
    */
    less,

    /**
        Test passes if the value in the buffer is equal 
        to the incoming value
    */
    equal,

    /**
        Test passes if the value in the buffer is less than 
        or equal to the incoming value.
    */
    lessEqual,

    /**
        Test passes if the value in the buffer is greater 
        than the incoming value
    */
    greater,

    /**
        Test passes if the value in the buffer is not equal 
        to the incoming value
    */
    notEqual,

    /**
        Test passes if the value in the buffer is greater than 
        or equal to the incoming value.
    */
    greaterEqual,
    
    /**
        Test always passes
    */
    always
}

/**
    Descriptor used to create a texture
*/
struct NuvkTextureDescriptor {
    NuvkDeviceSharing deviceSharing;
    NuvkTextureFormat format;
    NuvkTextureType type;
    NuvkTextureTiling tiling;

    NuvkExtent3D!uint extents = NuvkExtent3D!uint(1, 1, 1);
    int samples = 1;
    uint mipLevels = 1;
    uint arrayLayers = 1;
}

/**
    Descriptor used to create a texture view
*/
struct NuvkTextureViewDescriptor {
    NuvkTextureFormat format;
    NuvkTextureType type;
    NuvkRange!int mipLevels;
    NuvkRange!int arraySlices;
}

/**
    Descriptor used to create a sampler
*/
struct NuvkSamplerDescriptor {
    /**
        Addressing mode for the horizontal texture coordinate.
    */
    NuvkSamplerAddressMode addressModeU;

    /**
        Addressing mode for the vertical texture coordinate.
    */
    NuvkSamplerAddressMode addressModeV;

    /**
        Addressing mode for the depth texture coordinate.
    */
    NuvkSamplerAddressMode addressModeW;

    /**
        The border color used during clampToBorderColor clamping modes.
    */
    NuvkColor borderColor;

    /**
        Minification filter
    */
    NuvkSamplerTextureFilter minFilter;
    
    /**
        Magnification filter
    */
    NuvkSamplerTextureFilter magFilter;

    /**
        Mipmapping filter
    */
    NuvkSamplerMipmapFilter mipFilter;

    /**
        Comparison function
    */
    NuvkSamplerCompFunc compareFunc;

    /**
        Range that mipmap LODs should be clamped to.
    */
    NuvkRange!float lodClamp = NuvkRange!float(0, float.max);

    /**
        Maximum level of anisotropy.
    */
    int maxAnisotropy;

    /**
        Whether texture coordinates should be normalized.
    */
    bool normalizeCoordinates;
}

/**
    A texture.

    Textures store graphical data.
*/
abstract
class NuvkTexture : NuvkDeviceObject {
@nogc:
private:
    NuvkTextureDescriptor descriptor;
    NuvkDeviceSharing deviceSharing;

protected:

    /**
        Gets the descriptor used to create this texture.
    */
    final
    ref NuvkTextureDescriptor getDescriptor() {
        return descriptor;
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureDescriptor descriptor, NuvkDeviceSharing deviceSharing, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.deviceSharing = deviceSharing;
        this.descriptor = descriptor;
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureFormat format, NuvkDeviceSharing deviceSharing, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.deviceSharing = deviceSharing;
        this.descriptor.format = format;
        this.descriptor.samples = 1;
        this.descriptor.deviceSharing = NuvkDeviceSharing.deviceLocal;
        this.descriptor.type = NuvkTextureType.texture2d;
    }

    /**
        Creates a texture view
    */
    abstract NuvkTextureView createTextureView(NuvkTextureViewDescriptor descriptor);

    /**
        Gets the sharing mode of the texture
    */
    final
    NuvkDeviceSharing getDeviceSharing() {
        return deviceSharing;
    }

    /**
        Gets the format of the texture
    */
    final
    NuvkTextureFormat getFormat() {
        return descriptor.format;
    }

    /**
        Gets the type of the texture
    */
    final
    NuvkTextureType getType() {
        return descriptor.type;
    }

    /**
        Gets the tiling mode of the texture
    */
    final
    NuvkTextureTiling getTilingMode() {
        return descriptor.tiling;
    }

    /**
        Gets how many samples are taken in multi-sampling.
    */
    final
    int getSampleCount() {
        return descriptor.samples;
    }
}

/**
    A texture view.

    Texture views are used to reinterpret the data stored in a NuvkTexture
*/
abstract
class NuvkTextureView : NuvkDeviceObject {
@nogc:
private:
    NuvkTexture texture;
    NuvkTextureViewDescriptor descriptor;

protected:

    /**
        Gets the descriptor used to create this texture view.
    */
    final
    ref NuvkTextureViewDescriptor getDescriptor() {
        return descriptor;
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTexture texture, NuvkTextureViewDescriptor descriptor) {
        super(device, NuvkProcessSharing.processLocal);
        this.texture = texture;
        this.descriptor = descriptor;
    }

    /**
        Gets the texture this is a view into.
    */
    ref NuvkTexture getTexture() {
        return texture;
    }

    /**
        Gets the format of the texture view
    */
    final
    NuvkTextureFormat getFormat() {
        return descriptor.format;
    }

    /**
        Gets the type of the texture view
    */
    final
    NuvkTextureType getType() {
        return descriptor.type;
    }
}

/**
    A texture sampler.

    Samplers are used to read textures.
*/
abstract
class NuvkSampler : NuvkDeviceObject {
@nogc:
private:
    NuvkSamplerDescriptor descriptor;

protected:

    /**
        Gets the descriptor used to create this sampler
    */
    final
    ref NuvkSamplerDescriptor getDescriptor() {
        return descriptor;
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkSamplerDescriptor descriptor) {
        super(device, NuvkProcessSharing.processLocal);
        this.descriptor = descriptor;
    }

}

