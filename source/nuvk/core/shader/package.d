/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader;
import nuvk.core;
import numem.all;

public import nuvk.core.shader.program;
public import nuvk.core.shader.library;
import nuvk.core.shader.mod;

/**
    Shader stage flags.

    These can be OR'ed together to specify multiple stages at once.
*/
enum NuvkShaderStage {

    /**
        Invalid shader stage
    */
    none        = 0x00,

    /**
        A mesh shader
    */
    mesh        = 0x01,

    /**
        A vertex shader
    */
    vertex      = 0x02,

    /**
        A fragment shader
    */
    fragment    = 0x04,

    /**
        A compute shader
    */
    compute     = 0x08,

    /**
        All graphics stages
    */
    graphics = mesh | vertex | fragment,

    /**
        All stages
    */
    all = mesh | vertex | fragment | compute,
}

/**
    Shader types.
*/
enum NuvkShaderType {

    /**
        A mesh shader
    */
    mesh,

    /**
        A vertex shader
    */
    vertex,

    /**
        A fragment shader
    */
    fragment,

    /**
        A compute shader
    */
    compute
}

/**
    Converts a shader type into a shader stage.
*/
NuvkShaderStage toStage(NuvkShaderType type) @nogc {
    final switch(type) {
        case NuvkShaderType.mesh:
            return NuvkShaderStage.mesh;

        case NuvkShaderType.vertex:
            return NuvkShaderStage.vertex;

        case NuvkShaderType.fragment:
            return NuvkShaderStage.fragment;

        case NuvkShaderType.compute:
            return NuvkShaderStage.compute;
    }
}

/**
    An individual shader
*/
class NuvkShader : NuvkObject {
@nogc:
private:
    NuvkSpirvModule module_;
    NuvkShaderType type;

    void loadAndParse(uint[] spirv) {
        this.module_ = nogc_new!NuvkSpirvModule(spirv);
        this.module_.parse();

        this.type = module_.getType();
        this.setName("{0} ({1})".format(module_.getEntrypoint(), this.type.toString()));
    }

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(module_);
    }

    /**
        Creates shader from SPIRV
    */
    this(uint[] spirv) {
        this.loadAndParse(spirv);
    }

    /**
        Creates shader from SPIRV
    */
    this(ubyte[] spirv) {
        this.loadAndParse(cast(uint[])spirv);
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
        Gets what type of shader this is.
    */
    NuvkShaderType getType() {
        return type;
    }

    /**
        Gets the shader stage this shader is bound to
    */
    NuvkShaderStage getStage() {
        return type.toStage();
    }

    /**
        Gets whether this shader is a graphics shader
    */
    bool isGraphicsShader() {
        return (type.toStage() & NuvkShaderStage.graphics) > 0;
    }
}