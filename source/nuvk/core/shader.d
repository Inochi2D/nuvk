/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader;
import nuvk.spirv;
import nuvk.core;
import numem.all;

/**
    Shader stages
*/
enum NuvkShaderStage {

    /**
        Invalid shader stage
    */
    none        = 0x00,

    /**
        A vertex shader
    */
    vertex      = 0x01,

    /**
        A fragment shader
    */
    fragment    = 0x02,

    /**
        A compute shader
    */
    compute     = 0x04,

    /**
        Vertex and fragment stage
    */
    vertexAndFragment = vertex | fragment,

    /**
        Vertex and fragment stage
    */
    fragmentAndCompute = fragment | compute,

    /**
        All stages
    */
    all = vertex | fragment | compute,
}

/**
    Gets the name of entry points from the stage.
*/
nstring getEntrypointFromStage(NuvkShaderStage stage) @nogc {
    switch(stage) {
        case NuvkShaderStage.vertex:
            return nstring("vertex");

        case NuvkShaderStage.fragment:
            return nstring("fragment");

        case NuvkShaderStage.compute:
            return nstring("compute");

        // Okay, just main in this case.
        // Your shader is probably screwed though.
        default:
            return nstring("main");
    }
}

/**
    An individual shader
*/
abstract
class NuvkShader : NuvkDeviceObject {
@nogc:
private:
    NuvkSpirvModule module_;
    NuvkShaderStage stage;

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(module_);
    }

    /**
        Creates shader
    */
    this(NuvkDevice device, NuvkSpirvModule module_, NuvkShaderStage stage) {
        super(device, NuvkProcessSharing.processLocal);
        this.module_ = module_;
        this.stage = stage;
    }

    /**
        Gets the size of the bytecode in bytes.
    */
    size_t getBytecodeSize() {
        return module_.getBytecodeSizeBytes();
    }

    /**
        Gets a slice of the bytecode.
    */
    uint[] getBytecode() {
        return module_.getBytecode();
    }

    /**
        Gets the SPIRV module loaded
    */
    NuvkSpirvModule getSpirvModule() {
        return module_;
    }

    /**
        Gets the shader stage this shader is bound to
    */
    NuvkShaderStage getStage() {
        return stage;
    }
}
