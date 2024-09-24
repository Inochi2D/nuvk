module nuvk.core.vk.pipeline;
import nuvk.core.vk;
import nuvk.core;
import nuvk.spirv;
import numem.all;

import core.stdc.stdio : printf;

private {
    const VkDynamicState[] nuvkVkDynamicState = [
        VK_DYNAMIC_STATE_BLEND_CONSTANTS,
        VK_DYNAMIC_STATE_VIEWPORT,
        VK_DYNAMIC_STATE_SCISSOR,
        VK_DYNAMIC_STATE_CULL_MODE,
        VK_DYNAMIC_STATE_FRONT_FACE,
        VK_DYNAMIC_STATE_PRIMITIVE_RESTART_ENABLE,
        VK_DYNAMIC_STATE_PRIMITIVE_TOPOLOGY,
        VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE,
        VK_DYNAMIC_STATE_VERTEX_INPUT_EXT
    ];
}
/**
    A pipeline
*/
class NuvkVkPipeline : NuvkPipeline {
@nogc:
private:
    VkPipeline pipeline;

    void createGraphicsPipeline(ref NuvkGraphicsPipelineDescriptor graphicsInfo) {
        VkGraphicsPipelineCreateInfo graphicsPipelineCreateInfo;
        auto device = cast(VkDevice)this.getOwner().getHandle();
        
        // Shader state
        weak_vector!VkPipelineShaderStageCreateInfo shaderStates;
        foreach(shader; graphicsInfo.shaders) {

            if (auto vkshader = cast(NuvkVkShader)shader) {
                VkPipelineShaderStageCreateInfo shaderStageInfo;
                shaderStageInfo.module_ = cast(VkShaderModule)vkshader.getHandle();
                shaderStageInfo.pName = vkshader.getEntrypoint().ptr;
                shaderStageInfo.stage = shader.getStage().toVkShaderStage();

                shaderStates ~= shaderStageInfo;
            }
        }
        graphicsPipelineCreateInfo.stageCount = cast(uint)shaderStates.size();
        graphicsPipelineCreateInfo.pStages = shaderStates.data();

        // Input assembly state
        VkPipelineInputAssemblyStateCreateInfo inputAssemblyStateInfo;
        inputAssemblyStateInfo.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
        inputAssemblyStateInfo.primitiveRestartEnable = VK_FALSE;
        graphicsPipelineCreateInfo.pInputAssemblyState = &inputAssemblyStateInfo;

        // Tessellation state
        VkPipelineTessellationStateCreateInfo tessellationStateInfo;
        tessellationStateInfo.patchControlPoints = 0;
        graphicsPipelineCreateInfo.pTessellationState = &tessellationStateInfo;

        // Viewport state
        VkPipelineViewportStateCreateInfo viewportStateInfo;
        viewportStateInfo.viewportCount = 1;
        viewportStateInfo.scissorCount = 1;
        graphicsPipelineCreateInfo.pViewportState = &viewportStateInfo;

        // Rasterizer state
        VkPipelineRasterizationStateCreateInfo rasterizationStateInfo;
        rasterizationStateInfo.depthClampEnable = VK_FALSE;
        rasterizationStateInfo.rasterizerDiscardEnable = VK_FALSE;
        rasterizationStateInfo.polygonMode = VK_POLYGON_MODE_FILL;
        graphicsPipelineCreateInfo.pRasterizationState = &rasterizationStateInfo;

        // Multisample state
        VkPipelineMultisampleStateCreateInfo multisampleStateInfo;
        multisampleStateInfo.sampleShadingEnable = VK_FALSE;
        multisampleStateInfo.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;
        multisampleStateInfo.minSampleShading = 1.0f;
        multisampleStateInfo.pSampleMask = null;
        multisampleStateInfo.alphaToCoverageEnable = VK_FALSE;
        multisampleStateInfo.alphaToOneEnable = VK_FALSE;
        graphicsPipelineCreateInfo.pMultisampleState = &multisampleStateInfo;

        // Color blending state
        VkPipelineColorBlendStateCreateInfo colorBlendStateInfo;
        graphicsPipelineCreateInfo.pColorBlendState = &colorBlendStateInfo;

        // Dynamic state
        VkPipelineDynamicStateCreateInfo dynamicStateInfo;
        dynamicStateInfo.dynamicStateCount = cast(uint)nuvkVkDynamicState.length;
        dynamicStateInfo.pDynamicStates = nuvkVkDynamicState.ptr;
        graphicsPipelineCreateInfo.pDynamicState = &dynamicStateInfo;
        
        // Render create info
        VkPipelineRenderingCreateInfo renderCreateInfo;
        renderCreateInfo.viewMask = 0;
        graphicsPipelineCreateInfo.pNext = &renderCreateInfo;

        // Final stuff
        graphicsPipelineCreateInfo.layout = VK_NULL_HANDLE;
        graphicsPipelineCreateInfo.renderPass = VK_NULL_HANDLE;

        enforce(
            vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, &graphicsPipelineCreateInfo, null, &pipeline) == VK_SUCCESS,
            nstring("Failed to create graphics pipeline!")
        );
    }

    void createComputePipeline(ref NuvkComputePipelineDescriptor computeInfo) {

    }

public:
    
    /**
        Creates a graphics pipeline
    */
    this(NuvkDevice owner, ref NuvkGraphicsPipelineDescriptor graphicsInfo) {
        super(owner, graphicsInfo);
        this.createGraphicsPipeline(graphicsInfo);
    }

    /**
        Creates a compute pipeline
    */
    this(NuvkDevice owner, ref NuvkComputePipelineDescriptor computeInfo) {
        super(owner, computeInfo);
        this.createComputePipeline(computeInfo);
    }

}