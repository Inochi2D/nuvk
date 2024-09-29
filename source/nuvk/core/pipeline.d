/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.pipeline;
import nuvk.core.shader;
import nuvk.core;
import numem.all;

/**
    The kind of a pipeline
*/
enum NuvkPipelineKind {

    /**
        Graphics pipeline
    */
    graphics,
    
    /**
        Compute pipeline
    */
    compute
}

/**
    Input rate
*/
enum NuvkInputRate {
    /**
        Input is per-vertex
    */
    vertex,

    /**
        Input is per-instance
    */
    instance
}

/**
    A vertex attribute
*/
struct NuvkVertexAttribute {

    /**
        Binding point
    */
    uint binding;

    /**
        Byte-offset of attribute
    */
    uint offset;

    /**
        Location that the attribute is bound to
    */
    uint location;

    /**
        The format of the attribute
    */
    NuvkVertexFormat format;
}

struct NuvkVertexBinding {

    /**
        Binding point
    */
    uint binding;

    /**
        Stride 
    */
    uint stride;

    /**
        InputRate 
    */
    NuvkInputRate inputRate;
}

/**
    Creation information for a graphics pipeline
*/
struct NuvkGraphicsPipelineDescriptor {
@nogc:
    /**
        Vertex shader
    */
    NuvkShader vertexShader;

    /**
        Fragment shader
    */
    NuvkShader fragmentShader;

    /**
        Vertex bindings

        May be empty if no vertex shader is specified.
    */
    vector!NuvkVertexBinding bindings;

    /**
        Vertex attributes

        May be empty if no vertex shader is specified.
    */
    vector!NuvkVertexAttribute attributes;

    /**
        Copy constructor
    */
    this(ref NuvkGraphicsPipelineDescriptor createInfo) nothrow {
        this.vertexShader = createInfo.vertexShader;
        this.fragmentShader = createInfo.fragmentShader;
        this.bindings = vector!NuvkVertexBinding(createInfo.bindings[]);
        this.attributes = vector!NuvkVertexAttribute(createInfo.attributes[]);
    }
}

/**
    Creation information for a compute pipeline
*/
struct NuvkComputePipelineDescriptor {
    NuvkShader shader;
}

/**
    A pipeline
*/
abstract
class NuvkPipeline : NuvkDeviceObject {
@nogc:
private:
    NuvkPipelineKind pipelineKind;

public:
    
    /**
        Creates a graphics pipeline
    */
    this(NuvkDevice owner, NuvkGraphicsPipelineDescriptor descriptor) {
        super(owner);
        this.pipelineKind = NuvkPipelineKind.graphics;
    }

    /**
        Creates a compute pipeline
    */
    this(NuvkDevice owner, NuvkComputePipelineDescriptor descriptor) {
        super(owner);
        this.pipelineKind = NuvkPipelineKind.compute;
    }

    /**
        Gets which kind of pipeline this is.
    */
    final
    NuvkPipelineKind getPipelineKind() {
        return pipelineKind;
    }
}