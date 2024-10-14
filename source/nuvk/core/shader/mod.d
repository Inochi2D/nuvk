/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader.mod;
import spirv;
import nuvk.core.logging;
import nuvk.core.texture;
import nuvk.core.shader;
import nuvk.core.buffer;
import numem.all;
import inmath;

import core.stdc.stdio;
import std.concurrency;

/**
    A single descriptor within a shader
*/
struct NuvkSpirvDescriptor {
@nogc:

    /// Name of the element
    nstring name;

    /// Variable kind of the descriptor.
    SpirvVarKind kind;

    /// The set it belongs to
    uint set;

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
    A SPIR-V module
*/
class NuvkSpirvModule {
@nogc:
private:
    // Module info
    ExecutionModel executionModel;
    nstring entrypoint;
    SpirvModule module_;

    // Parsing Information
    bool hasBeenParsed;
    map!(uint, vector!NuvkSpirvDescriptor) descriptors;
    vector!NuvkSpirvAttachment attachments;
    vector!NuvkSpirvVertexInput vertexInputs;

    void doParse(uint[] data) {
        module_ = nogc_new!SpirvModule(data);
        this.executionModel = module_.getExecutionModel();
        this.entrypoint = module_.getEntryPoints()[0].getName();
        this.parseDescriptors();
    }

    void verifyBytecodeLength(ptrdiff_t length) {
        nuvkEnforce(length >= 0, "Could not verify size of input stream!");
        nuvkEnforce((length % 4) == 0, "SPIR-V bytecode not aligned!");
    }
    
    void setData(ref uint[] data) {
        this.doParse(data);
    }
    
    void setData(ref ubyte[] data) {
        this.verifyBytecodeLength(data.length);
        this.doParse((cast(uint*)data.ptr)[0..data.length/4]);
    }

    void parseVtxInputs() {
        if (executionModel == ExecutionModel.Vertex) {
            auto variables = module_.getVariablesForKind(SpirvVarKind.stageInput);

            size_t offset;
            size_t location;
            foreach(ref SpirvVariable var; variables) {

                auto type = var.getType();
                size_t size = type.getSize();
                size_t bitwidth = type.getWidth();

                size_t locations = max(1, size/16);
                size_t subSize = size/locations;
                size_t elementCount = type.getComponents();
                location = module_.getDecorationArgFor(var.getId(), Decoration.Location);
                foreach(i; 0..locations) {
                    NuvkSpirvVertexInput input;
                    input.name = var.getName();
                    input.location = cast(uint)(location+i);
                    input.offset = cast(uint)offset;
                    input.size = cast(uint)subSize;
                    input.format = createVertexFormat(cast(uint)elementCount, cast(uint)bitwidth);

                    offset += subSize;
                    vertexInputs ~= input;
                }
            }

            foreach(ref input; vertexInputs) {
                input.stride = cast(uint)offset;
            }
        }
    }

    void parseDescriptors() {
        
        foreach(ref SpirvVariable variable; module_.getVariables()) {
            switch(variable.getStorageClass()) {
                case StorageClass.Uniform:
                case StorageClass.StorageBuffer:
                    uint set = module_.getDecorationArgFor(variable.getId(), Decoration.DescriptorSet);
                    uint bindingId = module_.getDecorationArgFor(variable.getId(), Decoration.Binding);
                    
                    if (set !in descriptors)
                        descriptors[set] = vector!(NuvkSpirvDescriptor)();
                    
                    descriptors[set] ~= NuvkSpirvDescriptor(
                        name: nstring(variable.getName()),
                        kind: variable.getVarKind(),
                        set: set,
                        binding: bindingId,
                    );
                    break;

                default:
                    break;
            }
        }

        this.parseVtxInputs();
    }

public:
    ~this() {
        nogc_delete(module_);
    }
    
    /**
        Constructor
    */
    this(uint[] bytecode) {
        this.setData(bytecode);
    }

    /**
        Constructor
    */
    this(ubyte[] binaryData) {
        this.setData(binaryData);
    }

    /**
        Constructor

        NOTE: SpirvModule does not close the stream.
    */
    this(Stream stream) {
        ptrdiff_t streamLength = stream.length();
        this.verifyBytecodeLength(streamLength);
        auto streamData = weak_vector!ubyte(streamLength);
        ubyte[] streamDataByteView = streamData[0..$];
        uint[] streamDataView = (cast(uint*)streamData.data())[0..streamLength/4];

        // Seek to start, just in case.
        ptrdiff_t originalPos = stream.tell();
        stream.seek(0);
            stream.read(streamDataByteView);
        stream.seek(originalPos);

        // Set data
        this.setData(streamDataView);
    }

    final
    void emit() {
        module_.emit();
    }

    /**
        Gets a slice of the bytecode

        Memory is owned by the SpirvModule, do not delete.
    */
    final
    uint[] getBytecode() {
        return module_.getBytecode();
    }

    /**
        Gets the size of the bytecode in bytes.
    */
    final
    uint getBytecodeSizeBytes() {
        return cast(uint)module_.getBytecode().length*4;
    }

    
    /**
        Gets the capability flag
    */
    final
    const(Capability)[] getCapabilities() {
        return module_.getCapabilities();
    }

    /**
        Gets the execution model of the module
    */
    final
    ExecutionModel getExecutionModel() {
        return executionModel;
    }

    /**
        Gets the execution mode of the module
    */
    final
    const(ExecutionMode)[] getExecutionModes() {
        return module_.getExecutionModes();
    }

    /**
        Gets a list of descriptors for the specified set.
    */
    final
    NuvkSpirvDescriptor[] getDescriptors(uint set) {
        return descriptors[set][0..$];
    }

    /**
        Gets the (output) attachments for this module.
    */
    final
    NuvkSpirvAttachment[] getAttachments() {
        return attachments[];
    }

    /**
        Gets the input vertex descriptions
    */
    final
    NuvkSpirvVertexInput[] getVertexInputs() {
        return vertexInputs[];
    }

    /**
        Gets iterator over descriptor set.
    */
    final
    auto getSetIter() {
        return descriptors.byKey();
    }

    /**
        Gets the entrypoint of the module
    */
    final
    string getEntrypoint() {
        return cast(string)entrypoint[];
    }

    /**
        Gets the type of the module
    */
    final
    NuvkShaderType getType() {
        return executionModel.toShaderType();
    }
}