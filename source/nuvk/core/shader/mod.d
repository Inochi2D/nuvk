/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader.mod;
import nuvk.spirv.cross;
import nuvk.core.logging;
import nuvk.core.texture;
import nuvk.core.shader;
import nuvk.core.buffer;
import numem.all;
import inmath;

public import nuvk.spirv.cross.types;

import core.stdc.stdio;
import std.concurrency;

/**
    A single descriptor within a shader
*/
struct NuvkSpirvDescriptor {
@nogc:

    this(nstring name, SpvcResourceType type, uint set, uint binding) {
        this.name = name;
        this.type = type;
        this.set = set;
        this.binding = binding;
    }

    /// Name of the element
    nstring name;

    /// Type of the item
    SpvcResourceType type;

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

    // Spirv-Cross items
    SpvcContext context;
    SpvcParsedIr parsedIr;
    SpvcCompiler compiler;
    SpvcResources resources;

    // Parsing Information
    bool hasBeenParsed;
    map!(uint, vector!NuvkSpirvDescriptor) descriptors;
    vector!NuvkSpirvAttachment attachments;
    vector!NuvkSpirvVertexInput vertexInputs;

    // Bytecode
    weak_vector!uint bytecode;

    void verifyBytecodeLength(ptrdiff_t length) {
        nuvkEnforce(length >= 0, "Could not verify size of input stream!");
        nuvkEnforce((length % 4) == 0, "SPIR-V bytecode not aligned!");
    }
    
    void setData(ref uint[] data) {
        this.bytecode = weak_vector!uint(data);
    }
    
    void setData(ref ubyte[] data) {
        this.verifyBytecodeLength(data.length);
        this.bytecode = weak_vector!uint((cast(uint*)data.ptr)[0..data.length/4]);
    }

    void parseVtxInputs() {
        if (executionModel == ExecutionModel.Vertex) {
            auto resourceBindings = this.getResourceListForType(SpvcResourceType.stageInputs);
            size_t offset;
            size_t location;
            foreach(const(SpvcReflectedResource) binding; resourceBindings) {

                auto typeHandle = spvcCompilerGetTypeHandle(compiler, binding.typeId);
                size_t size = getTypeSize(typeHandle);
                size_t bitwidth = spvcTypeGetBitWidth(typeHandle);

                

                size_t locations = max(1, size/16);
                size_t subSize = size/locations;
                size_t elementCount = getElementCount(typeHandle);
                location = spvcCompilerGetDecoration(compiler, binding.id, Decoration.Location);
                foreach(i; 0..locations) {
                    NuvkSpirvVertexInput input;
                    input.name = nstring(binding.name);
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

    /**
        Gets the amount of elements in a type.
    */
    size_t getElementCount(SpvcType type) {
        uint columns = spvcTypeGetColumns(type);
        uint vectorSize = spvcTypeGetVectorSize(type);
        return columns * vectorSize;
    }

    size_t getBaseTypeSize(SpvcType type) {

        // Other base types
        switch(spvcTypeGetBaseType(type)) {
            default:
                return 4;

            case SpvcBaseType.struct_:
                auto members = spvcTypeGetNumMemberTypes(type);
                size_t structSize;
                foreach(i; 0..members) {
                    auto handle = spvcCompilerGetTypeHandle(compiler, spvcTypeGetMemberType(type, i));
                    structSize += getTypeSize(handle);
                }

                return structSize;
            
            case SpvcBaseType.boolean:
            case SpvcBaseType.uint8:
            case SpvcBaseType.int8:
                return 1;
            
            case SpvcBaseType.uint16:
            case SpvcBaseType.int16:
            case SpvcBaseType.fp16:
                return 2;
            
            case SpvcBaseType.uint32:
            case SpvcBaseType.int32:
            case SpvcBaseType.fp32:
                return 4;
            
            case SpvcBaseType.uint64:
            case SpvcBaseType.int64:
            case SpvcBaseType.fp64:
                return 8;
        }
    }

    size_t getTypeSize(SpvcType type) {

        // Vector and matrix handling
        uint columns = spvcTypeGetColumns(type);
        uint vectorSize = spvcTypeGetVectorSize(type);
        uint arrayDims = spvcTypeGetNumArrayDimensions(type);
        if (columns > 1) {
            return getBaseTypeSize(type) * columns;
        } else if (vectorSize > 1) {
            return getBaseTypeSize(type) * vectorSize;
        } else if (arrayDims > 0) {
            foreach(dim; 0..arrayDims) {
                auto size = getBaseTypeSize(type);
                bool isLiteral = spvcTypeArrayDimensionIsLiteral(type, dim);
                if (isLiteral) {
                    return size * spvcTypeGetArrayDimension(type, dim);
                } else {
                    nuvkLogError("Unsized arrays are not supported.");
                    return 0;
                }
            }
        }

        // Just a base type
        return getBaseTypeSize(type);
    }

    void parseDescriptors() {
        foreach(resourceType; SpvcResourceType.uniformBuffers..SpvcResourceType.max) {

            auto resourceBindings = this.getResourceListForType(resourceType);
            foreach(const(SpvcReflectedResource) binding; resourceBindings) {

                if (executionModel == ExecutionModel.Fragment && resourceType == SpvcResourceType.stageOutputs) {
                    uint location = spvcCompilerGetDecoration(compiler, binding.id, Decoration.Location);
                    NuvkSpirvAttachment attachment;
                    attachment.location = location;
                    attachment.name = nstring(binding.name);

                    auto typeHandle = spvcCompilerGetTypeHandle(compiler, binding.typeId);

                    uint columns = spvcTypeGetColumns(typeHandle);
                    uint vectorSize = spvcTypeGetVectorSize(typeHandle);
                    
                    // Unrelated output.
                    if (columns != 1) 
                        continue;

                    attachment.format = vectorSize.vecToFormat();
                    attachments ~= attachment;
                    continue;
                }

                uint set = spvcCompilerGetDecoration(compiler, binding.id, Decoration.DescriptorSet);
                uint bindingId = spvcCompilerGetDecoration(compiler, binding.id, Decoration.Binding);

                if (set !in descriptors) {
                    descriptors[set] = vector!(NuvkSpirvDescriptor)();
                }

                descriptors[set] ~= NuvkSpirvDescriptor(
                    nstring(binding.name),
                    resourceType,
                    set,
                    bindingId
                );
            }
        }

        this.parseVtxInputs();
    }

public:
    ~this() {
        nogc_delete(bytecode);

        if (context) 
            spvcContextDestroy(context);
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

    /**
        Reads every instruction in the bytecode and parses them.
        This allows for introspection.
    */
    final
    void parse() {
        if (!isSpirvCrossLoaded()) {
            nuvkEnforce(
                loadSpirvCross() == SpirvCrossSupport.yes,
                "Failed to initialize SPIRV-Cross"
            );
        }

        if (!hasBeenParsed) {
            this.hasBeenParsed = true;

            spvcContextCreate(&context);
            spvcContextParseSpirv(context, bytecode.data(), bytecode.size(), &parsedIr);
            spvcContextCreateCompiler(context, SpvcBackend.none, parsedIr, SpvcCaptureMode.captureModeCopy, &compiler);
            this.executionModel = spvcCompilerGetExecutionModel(compiler);

            const(SpvcEntryPoint)* entrypoints;
            size_t entrypointCount;
            spvcCompilerGetEntryPoints(compiler, &entrypoints, &entrypointCount);
            foreach(ep; entrypoints[0..entrypointCount]) {
                if (ep.executionModel == this.executionModel) {
                    this.entrypoint = nstring(ep.name);
                }
            }

            spvcCompilerCreateShaderResources(compiler, &resources);
            this.parseDescriptors();
        }
    }

    /**
        Gets a slice of the bytecode

        Memory is owned by the SpirvModule, do not delete.
    */
    final
    uint[] getBytecode() {
        return bytecode[];
    }

    /**
        Gets a list of resources for the type.
    */
    final
    const(SpvcReflectedResource)[] getResourceListForType(SpvcResourceType type) {

        // Not parsed.
        if (!hasBeenParsed)
            return null;
        
        const(SpvcReflectedResource)* resourceList;
        size_t resourceListLength;
        spvcResourcesGetResourceListForType(resources, type, &resourceList, &resourceListLength);
        return resourceList[0..resourceListLength];
    }

    /**
        Gets a list of builtin resources for the type.
    */
    final
    const(SpvcReflectedBuiltinResource)[] getBuiltinResourceListForType(SpvcBuiltinResourceType type) {

        // Not parsed.
        if (!hasBeenParsed)
            return null;
        
        const(SpvcReflectedBuiltinResource)* resourceList;
        size_t resourceListLength;
        spvcResourcesGetBuiltinResourceListForType(resources, type, &resourceList, &resourceListLength);
        return resourceList[0..resourceListLength];
    }

    /**
        Gets the size of the bytecode in bytes.
    */
    final
    uint getBytecodeSizeBytes() {
        return cast(uint)bytecode.size()*4;
    }

    
    /**
        Gets the capability flag
    */
    final
    const(Capability)[] getCapabilities() {

        // Not parsed.
        if (!hasBeenParsed)
            return null;

        const(Capability)* capabilities;
        size_t capabilityCount;
        spvcCompilerGetDeclaredCapabilities(compiler, &capabilities, &capabilityCount);
        return capabilities[0..capabilityCount];
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

        // Not parsed.
        if (!hasBeenParsed)
            return null;

        const(ExecutionMode)* executionModes;
        size_t executionModeCount;
        spvcCompilerGetExecutionModes(compiler, &executionModes, &executionModeCount);
        return executionModes[0..executionModeCount];
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