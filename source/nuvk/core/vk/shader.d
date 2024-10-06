/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.vk.shader;
import nuvk.core.vk;
import nuvk.spirv;
import nuvk.core;
import numem.all;


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

bool shouldBeInDescriptor(SpvcResourceType type) @nogc {
    switch(type) {
        case SpvcResourceType.separateSamplers:
        case SpvcResourceType.sampledImages:
        case SpvcResourceType.separateImages:
        case SpvcResourceType.storageImages:
        case SpvcResourceType.uniformBuffers:
        case SpvcResourceType.storageBuffers:
        case SpvcResourceType.accelerationStructure:
            return true;

        default:
            return false;
    }
}

VkDescriptorType toVkDescriptorType(SpvcResourceType type) @nogc {
    switch(type) {
        case SpvcResourceType.separateSamplers:
            return VK_DESCRIPTOR_TYPE_SAMPLER;
        case SpvcResourceType.sampledImages:
            return VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
        case SpvcResourceType.separateImages:
            return VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
        case SpvcResourceType.storageImages:
            return VK_DESCRIPTOR_TYPE_STORAGE_IMAGE;
        case SpvcResourceType.uniformBuffers:
            return VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
        case SpvcResourceType.storageBuffers:
            return VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
        case SpvcResourceType.accelerationStructure:
            return VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_KHR;

        default:
            return VK_DESCRIPTOR_TYPE_MAX_ENUM;
    }
}

/**
    An individual shader
*/
class NuvkVkShader : NuvkShader {
@nogc:
private:
    VkShaderModule shaderModule;
    VkDescriptorSetLayout descriptorSetLayout;

    vector!VkDescriptorSetLayoutBinding layoutBindings;
    nstring entrypoint;

    void initializeShader() {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkShaderModuleCreateInfo shaderCreateInfo;
        shaderCreateInfo.codeSize = this.getBytecodeSize();
        shaderCreateInfo.pCode = this.getBytecode().ptr;

        nuvkEnforce(
            vkCreateShaderModule(device, &shaderCreateInfo, null, &shaderModule) == VK_SUCCESS,
            "Shader module creation failed!"
        );

        this.setHandle(shaderModule);
    }

    void parseInfo(NuvkSpirvModule module_, NuvkShaderStage stage) {
        module_.parse();
        
        // Entrypoint
        {
            auto entrypoint_ = module_.getEntrypoint();
            if (entrypoint_.length > 0)
                this.entrypoint = nstring(entrypoint_);
            else
                this.entrypoint = nstring(stage.getEntrypointFromStage()[]);
        }

        // Descriptor
        {
            auto device = cast(VkDevice)this.getOwner().getHandle();

            foreach(uint set; module_.getSetIter()) {
                NuvkSpirvDescriptor[] descriptors = module_.getDescriptors(set);
                
                foreach(ref NuvkSpirvDescriptor descriptor; descriptors) {
                    if (descriptor.type.shouldBeInDescriptor()) {
                        VkDescriptorSetLayoutBinding binding;
                        binding.binding = descriptor.binding;
                        binding.descriptorCount = 1;
                        binding.stageFlags = stage.toVkShaderStage();
                        binding.descriptorType = descriptor.type.toVkDescriptorType();
                        layoutBindings ~= binding;
                    }
                }
            }

            VkDescriptorSetLayoutCreateInfo descriptorLayoutCreateInfo;
            descriptorLayoutCreateInfo.bindingCount = cast(uint)layoutBindings.size();
            descriptorLayoutCreateInfo.pBindings = layoutBindings.data();

            nuvkEnforce(
                vkCreateDescriptorSetLayout(device, &descriptorLayoutCreateInfo, null, &descriptorSetLayout) == VK_SUCCESS,
                "Vulkan descriptor set layout creation failed!"
            );
        }
    }

public:

    ~this() {
        auto owner = cast(VkDevice)this.getOwner().getHandle();

        if (shaderModule != VK_NULL_HANDLE) {
            vkDestroyShaderModule(owner, shaderModule, null);
        }
    }


    /**
        Creates shader
    */
    this(NuvkDevice device, NuvkSpirvModule module_, NuvkShaderStage stage) {
        super(device, module_, stage);
        this.parseInfo(module_, stage);
        this.initializeShader();
    }

    /**
        Gets the entrypoint of the shader
    */
    final
    string getEntrypoint() {
        return cast(string)entrypoint[];
    }

    /**
        Gets the descriptor set layout
    */
    final
    VkDescriptorSetLayout getDescriptorSetLayout() {
        return descriptorSetLayout;
    }
}
