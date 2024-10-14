/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.shader;
import nuvk.core.shader.mod;
import nuvk.core.vk;
import nuvk.core;
import numem.all;
import spirv;


/**
    Converts shader stage to vulkan shader stage
*/
VkShaderStageFlagBits toVkShaderStage(NuvkShaderStage stage) @nogc {
    // NOTE: VkShaderStageFlagBits's minimum value is *1*
    // Therefore we use a uint here.
    uint outStage = 0;

    if (stage & NuvkShaderStage.vertex)
        outStage |= VK_SHADER_STAGE_VERTEX_BIT;

    if (stage & NuvkShaderStage.fragment)
        outStage |= VK_SHADER_STAGE_FRAGMENT_BIT;

    if (stage & NuvkShaderStage.compute)
        outStage |= VK_SHADER_STAGE_COMPUTE_BIT;

    return cast(VkShaderStageFlagBits)outStage;
}

bool shouldBeInDescriptor(SpirvVarKind kind) @nogc {
    switch(kind) {
        case SpirvVarKind.sampledImage:
        case SpirvVarKind.sampler:
        case SpirvVarKind.image:
        case SpirvVarKind.uniformBuffer:
        case SpirvVarKind.storageBuffer:
        case SpirvVarKind.accelStruct:
            return true;

        default:
            return false;
    }
}

VkDescriptorType toVkDescriptorType(SpirvVarKind kind) @nogc {
    switch(kind) {
        case SpirvVarKind.sampler:
            return VK_DESCRIPTOR_TYPE_SAMPLER;
        case SpirvVarKind.sampledImage:
            return VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
        case SpirvVarKind.image:
            return VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
        case SpirvVarKind.uniformBuffer:
            return VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
        case SpirvVarKind.storageBuffer:
            return VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
        case SpirvVarKind.accelStruct:
            return VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_KHR;

        default:
            return VK_DESCRIPTOR_TYPE_MAX_ENUM;
    }
}

VkFormat toVkFormat(NuvkVertexFormat format) @nogc {
    final switch(format) {

        // These formats don't map to anything.
        case NuvkVertexFormat.undefined:
        case NuvkVertexFormat.base:
        case NuvkVertexFormat.vector2:
        case NuvkVertexFormat.vector3:
        case NuvkVertexFormat.vector4:
        case NuvkVertexFormat.undefined8:
        case NuvkVertexFormat.undefined16:
        case NuvkVertexFormat.undefined32:
        case NuvkVertexFormat.undefined64:
            return VK_FORMAT_UNDEFINED;

        case NuvkVertexFormat.uint8:
            return VK_FORMAT_R8_UNORM;

        case NuvkVertexFormat.uvec2b:
            return VK_FORMAT_R8G8_UNORM;

        case NuvkVertexFormat.uvec3b:
            return VK_FORMAT_R8G8B8_UNORM;

        case NuvkVertexFormat.uvec4b:
            return VK_FORMAT_R8G8B8A8_UNORM;

        case NuvkVertexFormat.fp16:
            return VK_FORMAT_R16_SFLOAT;

        case NuvkVertexFormat.vec2h:
            return VK_FORMAT_R16G16_SFLOAT;

        case NuvkVertexFormat.vec3h:
            return VK_FORMAT_R16G16B16_SFLOAT;

        case NuvkVertexFormat.vec4h:
            return VK_FORMAT_R16G16B16A16_SFLOAT;

        case NuvkVertexFormat.fp32:
            return VK_FORMAT_R32_SFLOAT;

        case NuvkVertexFormat.vec2:
            return VK_FORMAT_R32G32_SFLOAT;

        case NuvkVertexFormat.vec3:
            return VK_FORMAT_R32G32B32_SFLOAT;

        case NuvkVertexFormat.vec4:
            return VK_FORMAT_R32G32B32A32_SFLOAT;

        case NuvkVertexFormat.fp64:
            return VK_FORMAT_R64_SFLOAT;

        case NuvkVertexFormat.vec2d:
            return VK_FORMAT_R64G64_SFLOAT;

        case NuvkVertexFormat.vec3d:
            return VK_FORMAT_R64G64B64_SFLOAT;

        case NuvkVertexFormat.vec4d:
            return VK_FORMAT_R64G64B64A64_SFLOAT;
    }
}

/**
    An individual shader
*/
class NuvkShaderProgramVk : NuvkShaderProgram {
@nogc:
private:
    weak_vector!VkShaderEXT shaderObjects;
    VkDescriptorSetLayout shaderLayout;
    
    vector!VkVertexInputBindingDescription2EXT   inputBindings;
    vector!VkVertexInputAttributeDescription2EXT inputAttributes;

    VkDescriptorSetLayout generateCombinedDescriptorSetFor(NuvkShader[] shaders) {
        auto device = this.getOwner().getHandle!VkDevice;

        VkDescriptorSetLayout layout;
        VkDescriptorSetLayoutCreateInfo descriptorSetLayoutCreateInfo;
        vector!VkDescriptorSetLayoutBinding bindings;

        foreach(shader; shaders) {

            // Iterate over every shader and get their bindings
            NuvkSpirvModule module_ = shader.getSpirvModule();
            foreach(uint set; module_.getSetIter()) {
                NuvkSpirvDescriptor[] descriptors = module_.getDescriptors(set);
                
                foreach(ref NuvkSpirvDescriptor descriptor; descriptors) {
                    if (descriptor.kind.shouldBeInDescriptor()) {
                        VkDescriptorSetLayoutBinding binding;
                        binding.binding = descriptor.binding;
                        binding.descriptorCount = 1;
                        binding.stageFlags = shader.getStage().toVkShaderStage();
                        binding.descriptorType = descriptor.kind.toVkDescriptorType();
                        bindings ~= binding;
                    }
                }
            }
        }

        //
        descriptorSetLayoutCreateInfo.bindingCount = cast(uint)bindings.length;
        descriptorSetLayoutCreateInfo.pBindings = bindings.ptr;
        nuvkEnforce(
            vkCreateDescriptorSetLayout(device, &descriptorSetLayoutCreateInfo, null, &layout) == VK_SUCCESS,
            "Vulkan descriptor set layout creation failed!"
        );

        return layout;
    }

    VkShaderCreateInfoEXT generateInfoFor(NuvkShader shader) {
        NuvkSpirvModule module_ = shader.getSpirvModule();

        VkShaderCreateInfoEXT shaderCreateInfo;
        shaderCreateInfo.codeType = VK_SHADER_CODE_TYPE_SPIRV_EXT;
        shaderCreateInfo.codeSize = shader.getBytecodeSize();
        shaderCreateInfo.pCode = shader.getBytecode().ptr;
        shaderCreateInfo.stage = shader.getStage().toVkShaderStage();
        shaderCreateInfo.pName = module_.getEntrypoint().ptr;

        shaderCreateInfo.setLayoutCount = 1;
        shaderCreateInfo.pSetLayouts = &shaderLayout;
        shaderCreateInfo.pushConstantRangeCount = 0;

        if (shader.getType() == NuvkShaderType.vertex) {
            this.generateInputs(module_);
        }

        return shaderCreateInfo;
    }

    void generateInputs(NuvkSpirvModule module_) {
        foreach(ref NuvkSpirvVertexInput input; module_.getVertexInputs()) {
            VkVertexInputBindingDescription2EXT binding;
            VkVertexInputAttributeDescription2EXT attribute;

            binding.binding = 0;
            binding.stride = input.stride;
            binding.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;
            binding.divisor = 1;
            
            attribute.binding = 0;
            attribute.location = input.location;
            attribute.format = input.format.toVkFormat();
            attribute.offset = input.offset;
            
            inputBindings ~= binding;
            inputAttributes ~= attribute;
        }
    }

    weak_vector!VkShaderStageFlagBits shaderStageFlags;

protected:

    override
    bool onLink(NuvkShader[] shaders) {
        auto device = this.getOwner().getHandle!VkDevice;

        // Create the shader layout
        shaderLayout = generateCombinedDescriptorSetFor(shaders);

        shaderObjects.resize(shaders.length);
        
        // Generate shader info
        vector!VkShaderCreateInfoEXT shaderInfos;
        foreach(shader; shaders) {
            shaderInfos ~= this.generateInfoFor(shader);
            shaderStageFlags ~= shaderInfos[$-1].stage;
        }

        VkResult result = vkCreateShadersEXT(device, cast(uint)shaderInfos.length, shaderInfos.ptr, null, shaderObjects.ptr);
        if (result != VK_SUCCESS) {
            nuvkLogError("Failed to link shaders!");
            foreach(i, shader; shaderObjects) {
                if (shader == VK_NULL_HANDLE)
                    nuvkLogError("Shader {0} bound to stage '{1}' failed!", i, shaders[i].getType().toString());
                else
                    vkDestroyShaderEXT(device, shader, null);
            }

            shaderStageFlags.clear();
            return false;
        }
        return true;
    }

public:

    /**
        Destructor
    */
    ~this() {
        auto device = this.getOwner().getHandle!VkDevice;

        foreach(shaderObject; shaderObjects) 
            vkDestroyShaderEXT(device, shaderObject, null);

        vkDestroyDescriptorSetLayout(device, shaderLayout, null);
    }

    /**
        Constructor
    */
    this(NuvkDevice device) {
        super(device);
    }

    /**
        Constructor
    */
    this(NuvkDevice device, NuvkShaderLibrary library) {
        super(device, library);
    }

    /**
        Gets the objects within the shader program.
    */
    final
    VkShaderEXT[] getObjects() {
        return shaderObjects[];
    }

    /**
        Gets the shader stages
    */
    final
    VkShaderStageFlagBits[] getVkStages() {
        return shaderStageFlags[];
    }

    /**
        Returns a list of input bindings
    */
    final
    VkVertexInputBindingDescription2EXT[] getInputBindings() {
        return inputBindings[];
    }

    /**
        Returns a list of input attributes
    */
    final
    VkVertexInputAttributeDescription2EXT[] getInputAttributes() {
        return inputAttributes[];
    }

}
