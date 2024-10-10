/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader.program;
import numem.all;
import nuvk.core;

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
        List of formats for the fragment output.

        If this list is empty nuvk will attempt to guess
        the texture formats of outputs from the fragment shader.
    */
    vector!NuvkTextureFormat fragmentOutputs;

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
}

/**
    A linked shader program
*/
class NuvkShaderProgram : NuvkDeviceObject {
@nogc:
private:
    size_t linked = 0;
    NuvkShaderStage stages;
    weak_vector!NuvkShader shaders;

    bool isGraphicsProgram() {
        return stages == 0 || (stages & NuvkShaderStage.graphics) > 0;
    }

    bool hasStage(NuvkShaderStage stage) {
        return (stages & stage) > 0;
    }

    /*
        Gets whether the specified shader is compatible with this program.
    */
    bool isShaderCompatible(NuvkShader shader) {
        return
            !this.hasStage(shader.getStage()) &&
            ((this.isGraphicsProgram() && shader.isGraphicsShader()) ||
            (stages == 0 || !this.isGraphicsProgram() && shader.getStage() == NuvkShaderStage.compute));
    }

protected:

    /**
        Implementation for linking the provided shaders together.
    */
    abstract bool onLink(NuvkShader[] shaders);

public:

    /**
        Creates a new empty shader program.

        Use add to add shaders to the program.
    */
    this(NuvkDevice device) {
        super(device);
    }

    /**
        Creates a program from a nuvk shader library

        The library needs to be linkable, see [NuvkShaderLibrary.canDirectLink]
    */
    this(NuvkDevice device, NuvkShaderLibrary library) {
        super(device);
        nuvkEnforce(
            library.canDirectLink(),
            "Library is not linkable!"
        );

        // Add all shaders and link.
        auto shaders = library.getShaders();
        foreach(shader; shaders) {
            this.add(shader);
        }
        this.link();
    }

    /**
        Adds a shader to the program.
    */
    final
    ref auto add(NuvkShader shader) {
        nuvkEnforce(
            this.isShaderCompatible(shader),
            "Shader '{0}' is not compatible with this program.", shader.getName()
        );

        nuvkEnforce(
            linked == 0,
            "Program is already linked!"
        );

        // Add shader.
        shaders ~= shader;
        stages |= shader.getStage();

        return this;
    }

    /**
        Links the specified shaders into a program. once linked
    */
    final
    void link() {
        nuvkEnforce(
            linked == 0,
            "Program is already linked!"
        );

        if (this.onLink(shaders[])) {
            this.linked = shaders.length;
            shaders.clear();
        }
    }

    /**
        Gets the stages in this shader.
    */
    final
    NuvkShaderStage getStages() {
        return stages;
    }

    /**
        Gets the amount of shaders linked.
    */
    final
    size_t getLinkedCount() {
        return linked;
    }
}