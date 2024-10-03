/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.spirv;
import nuvk.spirv.cross;
import nuvk.core.texture;
import numem.all;

public import nuvk.spirv.cross.types;

import core.stdc.stdio;

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

    // Bytecode
    weak_vector!uint bytecode;

    void verifyBytecodeLength(ptrdiff_t length) {
        enforce(
            length >= 0,
            nstring("Could not verify size of input stream!")
        );
        enforce(
            (length % 4) == 0,
            nstring("SPIR-V bytecode not aligned!")
        );
    }
    
    void setData(ref uint[] data) {
        this.bytecode = weak_vector!uint(data);
    }
    
    void setData(ref ubyte[] data) {
        this.verifyBytecodeLength(data.length);
        this.bytecode = weak_vector!uint((cast(uint*)data.ptr)[0..data.length/4]);
    }

    void parseDescriptors() {
        foreach(resourceType; SpvcResourceType.uniformBuffers..SpvcResourceType.max) {

            auto resourceBindings = this.getResourceListForType(resourceType);
            foreach(const(SpvcReflectedResource) binding; resourceBindings) {
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
    void parse() {
        if (!isSpirvCrossLoaded()) {
            enforce(
                loadSpirvCross() == SpirvCrossSupport.yes,
                nstring("Failed to initialize SPIRV-Cross")
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
    uint[] getBytecode() {
        return bytecode[];
    }

    /**
        Gets a list of resources for the type.
    */
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
    uint getBytecodeSizeBytes() {
        return cast(uint)bytecode.size()*4;
    }

    
    /**
        Gets the capability flag
    */
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
    ExecutionModel getExecutionModel() {
        return executionModel;
    }

    /**
        Gets the execution mode of the module
    */
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
    NuvkSpirvDescriptor[] getDescriptors(uint set) {
        return descriptors[set][0..$];
    }

    /**
        Gets iterator over descriptor set.
    */
    auto getSetIter() {
        return descriptors.byKey();
    }

    /**
        Gets the entrypoint of the module
    */
    string getEntrypoint() {
        return cast(string)entrypoint[];
    }
}