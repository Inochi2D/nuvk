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
    Creation information for a graphics pipeline
*/
struct NuvkGraphicsPipelineDescriptor {
@nogc:
    /**
        The shader stages
    */
    weak_vector!NuvkShader shaders;

    /**
        Copy constructor
    */
    this(ref NuvkGraphicsPipelineDescriptor createInfo) nothrow {
        this.shaders = weak_vector!NuvkShader(createInfo.shaders[]);
    }

    /**
        Destructor
    */
    ~this() nothrow {
        nogc_delete(this.shaders);
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