/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.texture;
import nuvk.core;
import inmath;

/**
    Texture formats
*/
enum NuvkTextureFormat {

    /**
        Undefined texture format.
    */
    undefined,

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
enum NuvkSamplerCompareOp {

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
    Texture layout
*/
enum NuvkTextureLayout {

    /**
        Texture layout is undefined, data can be anything.
    */
    undefined,

    /**
        Texture layout is general-use
    */
    general,

    /**
        Texture layout is meant to be a shader attachment
    */
    attachment,

    /**
        Texture layout is meant to be used for presentation
    */
    presentation,

    /**
        Texture can be used as a transfer source
    */
    transferSrc,

    /**
        Texture can be used as a transfer destination
    */
    transferDst,
}

/**
    Descriptor used to create a texture
*/
struct NuvkTextureDescriptor {
    NuvkTextureFormat format;
    NuvkTextureType type;
    NuvkTextureTiling tiling = NuvkTextureTiling.linear;

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
    NuvkRange!int mipLevels = NuvkRange!int(0, 1);
    NuvkRange!int arraySlices = NuvkRange!int(0, 1);
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
    NuvkSamplerCompareOp compareOp = NuvkSamplerCompareOp.always;

    /**
        Range that mipmap LODs should be clamped to.
    */
    NuvkRange!float lodClamp = NuvkRange!float(0, float.max);

    /**
        Maximum level of anisotropy.
    */
    int maxAnisotropy = 1;

    /**
        Whether texture coordinates should be normalized.
    */
    bool normalizeCoordinates = true;
}

/**
    A texture.

    Textures store graphical data.
*/
abstract
class NuvkTexture : NuvkResource {
@nogc:
private:
    NuvkTextureDescriptor descriptor;
    NuvkTextureLayout layout;

protected:

    /**
        Gets the descriptor used to create this texture.
    */
    final
    ref NuvkTextureDescriptor getDescriptor() {
        return descriptor;
    }

    /**
        Sets the texture mode.
    */
    final
    void setTextureLayout(NuvkTextureLayout layout) {
        this.layout = layout;
    }

public:

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureDescriptor descriptor, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.descriptor = descriptor;
        this.layout = NuvkTextureLayout.undefined;
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkTextureFormat format, NuvkProcessSharing processSharing) {
        super(device, processSharing);
        this.descriptor.format = format;
        this.descriptor.samples = 1;
        this.descriptor.type = NuvkTextureType.texture2d;
        this.layout = NuvkTextureLayout.undefined;
    }

    /**
        Uploads texture data to the GPU.
        The format of the data should match the result of `getFormat()`!

        Parameters:  
            `region` - The region to replace in the texture
            `mipmapLevel` - The mipmap level to replace
            `arrayLayer` - The array layer to replace
            `source` - The source buffer to copy from
            `rowStride` - The byte stride of a single row of pixels.
            `size` - The amount of bytes in the data.
    */
    final
    void upload(void[] source, uint rowStride, recti region, uint arraySlice = 0, uint mipmapLevel = 0) {
        auto staging = this.getOwner().getStagingBuffer();
        staging.transfer(source, rowStride, this, region, arraySlice, mipmapLevel);
    }

    
    /**
        Downloads texture data from the GPU.
        The data returned will be in the format described by `getFormat()`!
    
        This method will immediately download data from the GPU without any synchronisation.
        This should be called after all render operations to the texture are completed.

        Parameters:  
            `destination` - The destination buffer to copy into.
            `rowStride` - The byte stride of a single row of pixels.
            `from` - The region to read from the texture.
            `mipmapLevel` - The mipmap level to replace.
            `arrayLayer` - The array layer to replace.
    */
    final
    void download(ref void[] destination, uint rowStride, recti from, uint mipmapLevel, uint arrayLayer) {

    }

    /**
        Creates a texture view
    */
    abstract NuvkTextureView createTextureView(NuvkTextureViewDescriptor descriptor);

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

    /**
        Gets the width of the texture
    */
    final
    uint getWidth() {
        return descriptor.extents.width;
    }

    /**
        Gets the height of the texture
    */
    final
    uint getHeight() {
        return descriptor.extents.height;
    }

    /**
        Gets the depth of the texture.
    */
    final
    uint getDepth() {
        return descriptor.extents.depth;
    }

    /**
        Gets the layout of the texture.
    */
    final
    NuvkTextureLayout getLayout() {
        return layout;
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
        super(device);
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
        super(device);
        this.descriptor = descriptor;
    }

}

