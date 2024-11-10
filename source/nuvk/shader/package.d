/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.shader;
import nuvk;
import numem.all;

public import nuvk.shader.program;
public import nuvk.shader.library;
import spirv;

/**
    An individual shader
*/
class NuvkShader : NuvkObject {
@nogc:
private:
    nstring entrypoint;
    SpirvModule module_;
    NuvkShaderType type;

    void loadAndParse(uint[] spirv) {
        this.module_ = nogc_new!SpirvModule(spirv);
        this.reparse();
    }

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(module_);
    }

    /**
        Creates a shader from a reflected module.

        This will trigger an emit on the module.
    */
    this(SpirvModule mod) {
        this.module_ = mod;
        this.reparse();
        this.emit();
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
        Gets the underlying SPIR-V module
    */
    final
    SpirvModule getModule() {
        return module_;
    }

    /**
        Creates a unique NuvkShader from this shader.
    */
    final
    NuvkShader toUnique() {
        auto newModule = nogc_new!SpirvModule(module_.getBytecode());
        return nogc_new!NuvkShader(newModule);
    }  

    /**
        Gets the size of the bytecode in bytes.
    */
    final
    size_t getBytecodeSize() {
        return module_.getBytecode().length * SpirvID.sizeof;
    }

    /**
        Gets a slice of the bytecode.
    */
    final
    uint[] getBytecode() {
        return module_.getBytecode();
    }

    /**
        Gets the name of the first entrypoint.
    */
    final
    string getEntryPoint() {
        return cast(string)entrypoint[];
    }

    /**
        Re-emits the shader.
    */
    final
    void reparse() {
        this.module_.reparse();

        this.type = module_.getExecutionModel().toShaderType();
        this.entrypoint = nstring(module_.getEntryPoints()[0].getName());
        this.setName("{0} ({1})".format(entrypoint, this.type.toString()));
    }

    /**
        Re-emits the shader.
    */
    final
    void emit() {
        this.module_.emit();
    }

    /**
        Gets what type of shader this is.
    */
    final
    NuvkShaderType getType() {
        return type;
    }

    /**
        Gets the shader stage this shader is bound to
    */
    final
    NuvkShaderStage getStage() {
        return type.toStage();
    }

    /**
        Gets whether this shader is a graphics shader
    */
    final
    bool isGraphicsShader() {
        return (type.toStage() & NuvkShaderStage.graphics) > 0;
    }  
}

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

/**
    A vertex binding
*/
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
    A single descriptor within a shader
*/
struct NuvkSpirvDescriptor {
@nogc:
    /// Stage the descriptor applies to
    NuvkShaderStage stage;

    /// Name of the element
    nstring name;

    /// Variable kind of the descriptor.
    SpirvVarKind kind;

    /// The binding it belongs to
    uint binding;
}

/**
    A color output attachment (of a fragment shader)
*/
struct NuvkSpirvAttachment {
@nogc:

    /// Name of the attachment
    nstring name;

    /// Location of the attachment
    uint location;

    /// Format of the attachment
    NuvkTextureFormat format;
}

/**
    Vertex shader input
*/
struct NuvkSpirvVertexInput {

    /**
        Name of the input attachment
    */
    nstring name;

    /**
        Location of the input attachment
    */
    uint location;

    /**
        Size of the input attachment
    */
    uint size;

    /**
        Stride of the input attachment
    */
    uint stride;

    /**
        Offset of the input attachment
    */
    uint offset;

    /**
        Vertex format
    */
    NuvkVertexFormat format;
}

/**
    Converts a spirv execution model to a nuvk shader type.
*/
NuvkShaderType toShaderType(ExecutionModel model) @nogc {
    switch(model) {
        default:
            assert(0);
        case ExecutionModel.MeshEXT:
            return NuvkShaderType.mesh;
        case ExecutionModel.Vertex:
            return NuvkShaderType.vertex;
        case ExecutionModel.Fragment:
            return NuvkShaderType.fragment;
        case ExecutionModel.Kernel:
        case ExecutionModel.GLCompute:
            return NuvkShaderType.compute;
    }
}

/**
    Turns SPIRV vector and gets a nuvk texture format from it.
*/
NuvkTextureFormat vecToFormat(uint vecsize) @nogc {
    switch(vecsize) {
        default:
            return NuvkTextureFormat.undefined;
        
        case 1:
            return NuvkTextureFormat.a8UnormSRGB;
        
        case 2:
            return NuvkTextureFormat.rg8UnormSRGB;
        
        case 3:
        case 4:
            return NuvkTextureFormat.bgra8UnormSRGB;
    }
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