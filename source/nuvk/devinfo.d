module nuvk.devinfo;
import nuvk;
import numem.all;

/**
    Information about a device
*/
abstract
class NuvkDeviceInfo : NuvkObject {
@nogc:
public:

    /**
        Internal function used to discard
        devices which are not suitable for nuvk.
    */
    abstract bool isDeviceSuitable();

    /**
        Gets the name of the device
    */
    abstract string getDeviceName();

    /**
        Gets the type of the device
    */
    abstract NuvkDeviceType getDeviceType();

    /**
        Gets the device's features
    */
    abstract NuvkDeviceFeatures getDeviceFeatures();

    /**
        Gets the device's limits
    */
    abstract NuvkDeviceLimits getDeviceLimits();

    /**
        Gets information about the queues that can be
        instantiated by the device.
    */
    abstract NuvkQueueFamilyInfo[] getQueueFamilyInfos();

    /**
        Gets the index into `getQueueFamilyInfos` of the first queue family which 
        supports the provided specialisation(s).

        if `mostSpecific` is set to true, additionally will look for the queue
        that most specifically targets the provided specialisation.

        Returns -1 if a queue family wasn't found.
    */
    final
    ptrdiff_t getQueueFamilyIdxFor(NuvkQueueSpecialization specialization, bool mostSpecific=false) {
        if (mostSpecific) {

            // Boolean operations can be promoted to integers.
            // As such we just check the bitmask to get the amount
            // of specialisations it has.
            uint requiredCount;
            requiredCount += ((specialization & NuvkQueueSpecialization.graphics) > 0);
            requiredCount += ((specialization & NuvkQueueSpecialization.compute) > 0);
            requiredCount += ((specialization & NuvkQueueSpecialization.transfer) > 0);

            foreach(i, NuvkQueueFamilyInfo queue; this.getQueueFamilyInfos()) {
                uint hasCount;
                hasCount += ((queue.specialization & NuvkQueueSpecialization.graphics) > 0);
                hasCount += ((queue.specialization & NuvkQueueSpecialization.compute) > 0);
                hasCount += ((queue.specialization & NuvkQueueSpecialization.transfer) > 0);

                // The counts might match but the actual contents be mismatched.
                // This extra check prevents that.
                bool hasRequired = (queue.specialization & specialization) == specialization;

                if (hasRequired && hasCount == requiredCount)
                    return i;
            }
        }

        // Just find the first queue
        foreach(i, NuvkQueueFamilyInfo queue; this.getQueueFamilyInfos()) {
            if ((queue.specialization & specialization) == specialization)
                return i;
        }

        return -1;
    }
}


/**
    The type of a device.
*/
enum NuvkDeviceType {

    /**
        Device is an integrated GPU
    */
    integratedGPU,

    /**
        Device is an dedicated GPU
    */
    dedicatedGPU
}

/**
    Lists which features are available for the device.
*/
struct NuvkDeviceFeatures {

    /**
        Whether custom border colors are supported.
    */
    bool customBorderColors;

    /**
        Whether anisotropic filtering is supported.
    */
    bool anisotropicFiltering;

    /**
        Whether task shaders are supported.
    */
    bool taskShaders;

    /**
        Whether mesh shaders are supported.
    */
    bool meshShaders;

    /**
        Whether tile shading is supported
    */
    bool tileShading;

    /**
        Whether adjustable line width is supported.
    */
    bool wideLines;

    /**
        Whether adjustable point size is supported.
    */
    bool largePoints;

    /**
        Whether the BC family of texture compression formats
        is supported.
    */
    bool textureCompressionBC;

    /**
        Whether the ETC2 family of texture compression formats
        is supported.
    */
    bool textureCompressionETC2;

    /**
        Whether the ASTC family of texture compression formats
        is supported.
    */
    bool textureCompressionASTC;

    /**
        Whether raytracing is supported.
    */
    bool raytracing;

    /**
        Whether buffers can be mapped to the host.
    */
    bool hostMapBuffers;

    /**
        Whether buffers can be mapped to the host,
        without needing to explicitly synchronize
        it with the GPU.
    */
    bool hostMapCoherent;

    /**
        Whether device resources can be shared outside
        of the nuvk context.
    */
    bool sharing;
}

/**
    Contains the limits of the device.
*/
struct NuvkDeviceLimits {

    /**
        Maximum size of a 1D texture
    */
    uint maxTextureSize1D;
    
    /**
        Maximum size of a 2D texture
    */
    uint maxTextureSize2D;
    
    /**
        Maximum size of a 3D texture
    */
    uint maxTextureSize3D;
    
    /**
        Maximum size of a cubemap texture
    */
    uint maxTextureSizeCube;
    
    /**
        Maximum amount of array slices for a texture
    */
    uint maxTextureSlices;

    /**
        Maximum width of the framebuffer
    */
    uint maxFramebufferWidth;

    /**
        Maximum height of the framebuffer
    */
    uint maxFramebufferHeight;

    /**
        Maximum amount of color attachments
    */
    uint maxColorAttachments;

    /**
        Maximum anisotropy level
    */
    float maxAnisotropy;

    /**
        Maximum amount of LOD bias
    */
    float maxLodBias;

    /**
        Maximum number of samplers which can be bound to any
        shader stage.
    */
    uint maxShaderSamplers;

    /**
        Maximum number of uniform buffers which can be bound to any
        shader stage.
    */
    uint maxShaderUniformBuffers;

    /**
        Maximum number of storage buffers which can be bound to any
        shader stage.
    */
    uint maxShaderStorageBuffers;

    /**
        Maximum number of textures which can be bound to any
        shader stage.
    */
    uint maxShaderTextures;

    /**
        Maximum number of attributes that can be bound to a
        vertex shader.
    */
    uint maxVertexAttributes;

    /**
        Maximum number of bindings that can be bound to a
        vertex shader.
    */
    uint maxVertexBindings;

    /**
        Maximum offset that can be applied to a vertex buffer.
    */
    uint maxVertexOffset;

    /**
        Maximum stride that can be applied to a vertex buffer.
    */
    uint maxVertexStride;

    /**
        Maximum amount of output attachments that a vertex shader
        can write to.
    */
    uint maxVertexOutputs;

    /**
        Maximum dimension of input variables that can be provided
        to a fragment shader.
    */
    uint maxFragmentInputs;

    /**
        Maximum amount of output attachments that a fragment shader
        can write to.
    */
    uint maxFragmentOutputs;

    /**
        The most optimal memory alignment
    */
    ulong memoryAlignmentOptimal;

    /**
        The minimum required alignment
    */
    ulong memoryAlignmentMinimum;
}