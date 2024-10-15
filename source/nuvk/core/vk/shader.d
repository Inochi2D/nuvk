/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.shader;
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
    VkPipelineLayout pipelineLayout;
    
    vector!VkVertexInputBindingDescription2EXT   inputBindings;
    vector!VkVertexInputAttributeDescription2EXT inputAttributes;


    void generatePipelineLayoutVk() {
        auto device = this.getOwner().getHandle!VkDevice;

        VkPipelineLayoutCreateInfo createInfo = VkPipelineLayoutCreateInfo(
            setLayoutCount: 1,
            pSetLayouts: &shaderLayout
        );

        nuvkEnforce(
            vkCreatePipelineLayout(device, &createInfo, null, &pipelineLayout) == VK_SUCCESS,
            "Vulkan pipeline layout creation failed!"
        );
    }

    void generateDescriptorSetVk() {
        auto device = this.getOwner().getHandle!VkDevice;

        VkDescriptorSetLayoutCreateInfo descriptorSetLayoutCreateInfo;
        vector!VkDescriptorSetLayoutBinding bindings;

        // Iterate over every shader and get their bindings
        foreach(ref NuvkSpirvDescriptor descriptor; this.getDescriptors()) {
            VkDescriptorSetLayoutBinding binding;
            binding.binding = descriptor.binding;
            binding.descriptorCount = 1;
            binding.stageFlags = descriptor.stage.toVkShaderStage();
            binding.descriptorType = descriptor.kind.toVkDescriptorType();
            bindings ~= binding;
        }

        // Sets the bindings
        descriptorSetLayoutCreateInfo.bindingCount = cast(uint)bindings.length;
        descriptorSetLayoutCreateInfo.pBindings = bindings.ptr;
        nuvkEnforce(
            vkCreateDescriptorSetLayout(device, &descriptorSetLayoutCreateInfo, null, &shaderLayout) == VK_SUCCESS,
            "Vulkan descriptor set layout creation failed!"
        );
    }

    void generateInputsVk() {
        VkVertexInputBindingDescription2EXT binding;

        binding.binding = 0;
        binding.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;
        binding.divisor = 1;
        
        
        foreach(ref input; this.getVertexInputs()) {
            VkVertexInputAttributeDescription2EXT attribute;
            
            attribute.binding = 0;
            attribute.location = input.location;
            attribute.format = input.format.toVkFormat();
            attribute.offset = input.offset;
            binding.stride = input.stride;
            
            inputAttributes ~= attribute;
        }
        
        inputBindings ~= binding;
    }

    bool generateShaderObjectsVk(NuvkShader[] shaders) {
        auto device = this.getOwner().getHandle!VkDevice;
        this.shaderObjects.resize(shaders.length);
        
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
                    nuvkLogError("Shader '{0}' failed linking step!", shaders[i].getName());
                else
                    vkDestroyShaderEXT(device, shader, null);
            }

            shaderStageFlags.clear();
            return false;
        }
        return true;
    }

    VkShaderCreateInfoEXT generateInfoFor(NuvkShader shader) {
        VkShaderCreateInfoEXT shaderCreateInfo;
        shaderCreateInfo.codeType = VK_SHADER_CODE_TYPE_SPIRV_EXT;
        shaderCreateInfo.codeSize = shader.getBytecodeSize();
        shaderCreateInfo.pCode = shader.getBytecode().ptr;
        shaderCreateInfo.stage = shader.getStage().toVkShaderStage();
        shaderCreateInfo.pName = shader.getEntryPoint().ptr;

        shaderCreateInfo.setLayoutCount = 1;
        shaderCreateInfo.pSetLayouts = &shaderLayout;
        shaderCreateInfo.pushConstantRangeCount = 0;

        return shaderCreateInfo;
    }

    weak_vector!VkShaderStageFlagBits shaderStageFlags;

protected:

    override
    bool onLink(NuvkShader[] shaders) {

        // Create the shader layout
        this.generateInputsVk();
        this.generateDescriptorSetVk();
        this.generatePipelineLayoutVk();
        return this.generateShaderObjectsVk(shaders);
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

    /**
        Gets the descriptor set layout for the shader.
    */
    final
    VkDescriptorSetLayout getDescriptorSetLayout() {
        return shaderLayout;
    }

    /**
        Gets the pipeline layout for the shader.
    */
    final
    VkPipelineLayout getPipelineLayout() {
        return pipelineLayout;
    }
}
