/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

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
        VK_DYNAMIC_STATE_DEPTH_BIAS,
        VK_DYNAMIC_STATE_LINE_WIDTH
    ];
}

VkPipelineBindPoint toVkPipelineBindPoint(NuvkPipelineKind kind) @nogc {
    final switch(kind) {
        
        case NuvkPipelineKind.compute:
            return VK_PIPELINE_BIND_POINT_COMPUTE;

        case NuvkPipelineKind.graphics:
            return VK_PIPELINE_BIND_POINT_GRAPHICS;
    }
}

VkFormat toVkFormat(NuvkVertexFormat vertexFormat) @nogc {
    final switch(vertexFormat) {
        case NuvkVertexFormat.invalid:
            return VK_FORMAT_UNDEFINED;
        
        case NuvkVertexFormat.float32:
            return VK_FORMAT_R32_SFLOAT;
        
        case NuvkVertexFormat.vec2:
            return VK_FORMAT_R32G32_SFLOAT;
        
        case NuvkVertexFormat.vec3:
            return VK_FORMAT_R32G32B32_SFLOAT;
        
        case NuvkVertexFormat.vec4:
            return VK_FORMAT_R32G32B32A32_SFLOAT;
    }
}

VkVertexInputRate toVkInputRate(NuvkInputRate rate) @nogc {
    final switch(rate) {
        case NuvkInputRate.vertex:
            return VK_VERTEX_INPUT_RATE_VERTEX;
        case NuvkInputRate.instance:
            return VK_VERTEX_INPUT_RATE_INSTANCE;
    }
}

/**
    A pipeline
*/
class NuvkVkPipeline : NuvkPipeline {
@nogc:
private:
    weak_vector!VkDescriptorSetLayout descriptorSetLayouts;
    VkPipelineLayout pipelineLayout;
    VkPipeline pipeline;

    void createGraphicsPipeline(ref NuvkGraphicsPipelineDescriptor graphicsInfo) {
        auto device = cast(VkDevice)this.getOwner().getHandle();

        VkGraphicsPipelineCreateInfo graphicsPipelineCreateInfo;
        weak_vector!VkPipelineShaderStageCreateInfo shaderStates;

        weak_vector!VkVertexInputBindingDescription   bindingDescriptions;
        weak_vector!VkVertexInputAttributeDescription attributeDescriptions;
        
        // Shader state
        {
            if (auto vertex = cast(NuvkVkShader)graphicsInfo.vertexShader) {
                enforce(
                    vertex.getStage() == NuvkShaderStage.vertex,
                    nstring("Shader is not a vertex shader!")
                );

                VkPipelineShaderStageCreateInfo shaderStageInfo;
                shaderStageInfo.stage = vertex.getStage().toVkShaderStage();
                shaderStageInfo.module_ = cast(VkShaderModule)vertex.getHandle();
                shaderStageInfo.pName = vertex.getEntrypoint().ptr;

                shaderStates ~= shaderStageInfo;
                descriptorSetLayouts ~= vertex.getDescriptorSetLayout();
            }

            if (auto fragment = cast(NuvkVkShader)graphicsInfo.fragmentShader) {
                enforce(
                    fragment.getStage() == NuvkShaderStage.fragment,
                    nstring("Shader is not a fragment shader!")
                );

                VkPipelineShaderStageCreateInfo shaderStageInfo;
                shaderStageInfo.stage = fragment.getStage().toVkShaderStage();
                shaderStageInfo.module_ = cast(VkShaderModule)fragment.getHandle();
                shaderStageInfo.pName = fragment.getEntrypoint().ptr;

                shaderStates ~= shaderStageInfo;
                descriptorSetLayouts ~= fragment.getDescriptorSetLayout();
            }
        }

        // Pipeline Layout
        {
            VkPipelineLayoutCreateInfo pipelineLayoutInfo;

            pipelineLayoutInfo.setLayoutCount = cast(uint)descriptorSetLayouts.size();
            pipelineLayoutInfo.pSetLayouts = descriptorSetLayouts.data();

            enforce(
                vkCreatePipelineLayout(device, &pipelineLayoutInfo, null, &pipelineLayout) == VK_SUCCESS,
                nstring("Failed to create Vulkan graphics pipeline layout!")
            );
        }

        // Pipeline attributes and bindings
        {
            foreach(ref binding; graphicsInfo.bindings) {
                VkVertexInputBindingDescription bdesc;
                bdesc.binding = binding.binding;
                bdesc.stride = binding.stride;
                bdesc.inputRate = binding.inputRate.toVkInputRate();

                bindingDescriptions ~= bdesc;
            }

            foreach(i, ref attribute; graphicsInfo.attributes) {
                VkFormat fmt = cast(VkFormat)(attribute.format.toVkFormat() | VK_FORMAT_FEATURE_VERTEX_BUFFER_BIT);

                VkVertexInputAttributeDescription adesc;
                adesc.binding = attribute.binding;
                adesc.format = fmt;
                adesc.location = attribute.location;
                adesc.offset = attribute.offset;

                attributeDescriptions ~= adesc;
            }
        }

        // Pipeline
        {
            graphicsPipelineCreateInfo.stageCount = cast(uint)shaderStates.size();
            graphicsPipelineCreateInfo.pStages = shaderStates.data();

            // Input assembly state
            VkPipelineInputAssemblyStateCreateInfo inputAssemblyStateInfo;
            inputAssemblyStateInfo.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
            inputAssemblyStateInfo.primitiveRestartEnable = VK_TRUE;
    
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
            multisampleStateInfo.sampleShadingEnable        = VK_FALSE;
            multisampleStateInfo.rasterizationSamples       = VK_SAMPLE_COUNT_1_BIT;
            multisampleStateInfo.minSampleShading           = 1.0f;
            multisampleStateInfo.pSampleMask                = null;
            multisampleStateInfo.alphaToCoverageEnable      = VK_FALSE;
            multisampleStateInfo.alphaToOneEnable           = VK_FALSE;
            graphicsPipelineCreateInfo.pMultisampleState    = &multisampleStateInfo;

            // Color blending state
            VkPipelineColorBlendStateCreateInfo colorBlendStateInfo;
            graphicsPipelineCreateInfo.pColorBlendState = &colorBlendStateInfo;

            // Dynamic state
            VkPipelineDynamicStateCreateInfo dynamicStateInfo;
            dynamicStateInfo.dynamicStateCount          = cast(uint)nuvkVkDynamicState.length;
            dynamicStateInfo.pDynamicStates             = nuvkVkDynamicState.ptr;
            graphicsPipelineCreateInfo.pDynamicState    = &dynamicStateInfo;
            
            VkPipelineVertexInputStateCreateInfo vertexInput;
            vertexInput.vertexAttributeDescriptionCount     = cast(uint)attributeDescriptions.size();
            vertexInput.vertexBindingDescriptionCount       = cast(uint)bindingDescriptions.size();
            vertexInput.pVertexAttributeDescriptions        = attributeDescriptions.data();
            vertexInput.pVertexBindingDescriptions          = bindingDescriptions.data();
            graphicsPipelineCreateInfo.pVertexInputState    = &vertexInput;

            // Render create info
            VkPipelineRenderingCreateInfo renderCreateInfo;
            renderCreateInfo.viewMask = 0;
            graphicsPipelineCreateInfo.pNext = &renderCreateInfo;

            // Final stuff
            graphicsPipelineCreateInfo.layout = pipelineLayout;
            graphicsPipelineCreateInfo.renderPass = VK_NULL_HANDLE;

            enforce(
                vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, &graphicsPipelineCreateInfo, null, &pipeline) == VK_SUCCESS,
                nstring("Failed to create graphics pipeline!")
            );
        }
        
        this.setHandle(pipeline);
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

    /**
        Gets the descriptor set layouts
    */
    VkDescriptorSetLayout[] getLayouts() {
        return descriptorSetLayouts[];
    }

    /**
        Gets the descriptor set layouts
    */
    VkPipelineLayout getPipelineLayout() {
        return pipelineLayout;
    }

}