module nuvk.core.vk.shader;
import nuvk.core.vk;
import nuvk.spirv;
import nuvk.core;
import numem.all;


/**
    Converts shader stage to vulkan shader stage
*/
VkShaderStageFlagBits toVkShaderStage(NuvkShaderStage stage) @nogc {
    VkShaderStageFlagBits outStage;

    if (stage & NuvkShaderStage.vertex)
        outStage |= VK_SHADER_STAGE_VERTEX_BIT;

    if (stage & NuvkShaderStage.fragment)
        outStage |= VK_SHADER_STAGE_FRAGMENT_BIT;

    if (stage & NuvkShaderStage.compute)
        outStage |= VK_SHADER_STAGE_COMPUTE_BIT;

    return outStage;
}


/**
    An individual shader
*/
class NuvkVkShader : NuvkShader {
@nogc:
private:
    VkShaderModule shaderModule;
    nstring entrypoint;

    void initializeShader() {
        auto owner = cast(VkDevice)this.getOwner().getHandle();

        VkShaderModuleCreateInfo shaderCreateInfo;
        shaderCreateInfo.codeSize = this.getBytecodeSize();
        shaderCreateInfo.pCode = this.getBytecode().ptr;

        enforce(
            vkCreateShaderModule(owner, &shaderCreateInfo, null, &shaderModule) == VK_SUCCESS,
            nstring("Shader module creation failed!")
        );

        this.setHandle(shaderModule);
    }

    void parseInfo(NuvkSpirvModule module_, NuvkShaderStage stage) {
        module_.parse();
        auto entrypoint_ = module_.getEntrypoint();
        if (entrypoint_.length > 0)
            this.entrypoint = nstring(entrypoint_);
        else
            this.entrypoint = nstring(stage.getEntrypointFromStage()[]);
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
    string getEntrypoint() {
        return cast(string)entrypoint[];
    }
}
