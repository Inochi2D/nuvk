module nuvk.spirv;
import nuvk.spirv.reflection;
import nuvk.spirv.spv;
import numem.all;

import core.stdc.stdio : printf;

/**
    A SPIR-V instruction
*/
struct NuvkSpirvInstruction {
@nogc:
public:
    /**
        The opcode
    */
    Op opcode;

    /**
        The operands
    */
    weak_vector!uint operands;
}

/**
    A SPIR-V module
*/
class NuvkSpirvModule {
@nogc:
private:
    // Module info
    Capability capability;
    SourceLanguage sourceLanguage;
    ExecutionModel executionModel;
    AddressingModel addressingModel;
    MemoryModel memoryModel;
    ExecutionMode executionMode;

    nstring entrypoint;
    weak_vector!nstring extensions;
    weak_map!(uint, nstring) extendedInstructions;

    bool hasBeenParsed;

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


    // Instructions
    weak_vector!NuvkSpirvInstruction instructions;

    const(char)* getOffsetCString(uint offset, ref weak_vector!uint opcodes) {
        return (cast(const(char)*)opcodes.data)+(offset*4);
    }

    void preParseInstructions() {
        union tmp {
            uint alignedOp;
            struct {
                ushort enumerant;
                ushort wordCount;
            }
        }

        tmp tmp_;
        size_t bytecodeSize = bytecode.size();
        size_t idx = 5;
        while(idx < bytecodeSize) {
            instructions.resize(instructions.size()+1);

            // Load opcode info
            tmp_.alignedOp = bytecode[idx++];
            auto actualWordCount = tmp_.wordCount-1;

            // Set opcode of instruction
            instructions[$-1].opcode = cast(Op)tmp_.enumerant;

            // Reading data
            instructions[$-1].operands = 
                weak_vector!uint(bytecode[idx..idx+actualWordCount]);

            idx += actualWordCount;
        }
    }

    void parseInstructions() {
        foreach(ref NuvkSpirvInstruction instruction; instructions) {
            switch(instruction.opcode) {

                case Op.OpCapability:
                    this.capability = cast(Capability)instruction.operands[0];
                    break;
                
                case Op.OpExtension:
                    this.extensions ~= 
                        nstring(this.getOffsetCString(0, instruction.operands));
                    break;
                
                case Op.OpExtInstImport:
                    this.extendedInstructions[instruction.operands[0]] = 
                        nstring(this.getOffsetCString(1, instruction.operands));
                    break;
                
                case Op.OpMemoryModel:
                    this.addressingModel = cast(AddressingModel)instruction.operands[0];
                    this.memoryModel = cast(MemoryModel)instruction.operands[1];
                    break;
                
                case Op.OpEntryPoint:
                    this.executionModel = cast(ExecutionModel)instruction.operands[0];
                    this.entrypoint = 
                        nstring(this.getOffsetCString(2, instruction.operands));
                    break;

                case Op.OpExecutionMode:
                    this.executionMode = cast(ExecutionMode)instruction.operands[1];
                    break;


                default:
                    break;
            }
        }
    }

    // Mappings
    weak_map!(uint, NuvkSpirvInstruction*) mappings;
    void parseSSAMappings() {
        foreach(ref NuvkSpirvInstruction instruction; instructions) {
            bool iHasResult = instruction.opcode.hasResult();
            bool iHasResultType = instruction.opcode.hasResultType();

            if (iHasResult) {
                size_t idx = iHasResultType ? 1 : 0;
                mappings[instruction.operands[idx]] = &instruction;
            }
        }
    }

public:
    ~this() {
        nogc_delete(bytecode);
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
        if (!hasBeenParsed) {
            this.hasBeenParsed = true;
            this.preParseInstructions();
            this.parseSSAMappings();
            this.parseInstructions();
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
        Gets the size of the bytecode in bytes.
    */
    uint getBytecodeSizeBytes() {
        return cast(uint)bytecode.size()*4;
    }

    /**
        Gets a slice of the parsed instructions

        Memory is owned by the SpirvModule, do not delete.
    */
    NuvkSpirvInstruction[] getInstructions() {
        return instructions[];
    }

    
    /**
        Gets the capability flag
    */
    Capability getCapability() {
        return capability;
    }

    /**
        Gets the source language of the module
    */
    SourceLanguage getSourceLanguage() {
        return sourceLanguage;
    }

    /**
        Gets the execution model of the module
    */
    ExecutionModel getExecutionModel() {
        return executionModel;
    }

    /**
        Gets the adressing model of the module
    */
    AddressingModel getAddressingModel() {
        return addressingModel;
    }

    /**
        Gets the memory model of the module
    */
    MemoryModel getMemoryModel() {
        return memoryModel;
    }

    /**
        Gets the execution mode of the module
    */
    ExecutionMode getExecutionMode() {
        return executionMode;
    }

    /**
        Gets how many SSA mappings exist in the module.
    */
    uint getMappingCount() {
        return cast(uint)mappings.length();
    }

    /**
        Gets an iterator over the SSA mappings
    */
    auto getMappingKeys() {
        return mappings.byKey();
    }

    /**
        Gets a slice of the parsed instructions

        Memory is owned by the SpirvModule, do not delete.
    */
    NuvkSpirvInstruction* getInstructionById(uint ssaId) {
        if (ssaId in mappings) {
            return mappings[ssaId];
        }
        return null;
    }

    /**
        Gets the entrypoint of the module
    */
    string getEntrypoint() {
        return cast(string)entrypoint[];
    }

    /**
        Gets the amount of extensions loaded
    */
    uint getExtensionCount() {
        return cast(uint)extensions.size();
    }

    /**
        Gets the name of a loaded extension
    */
    string getExtensionName(uint index) {
        if (index <= extensions.size()) {
            return cast(string)extensions[index][];
        }
        return null;
    }

    /**
        Gets an iterator over the extended instructions
    */
    auto getExtendedInstructionKeys() {
        return extendedInstructions.byKey();
    }

    /**
        Gets the amount of extended instructions
    */
    auto getExtendedInstructionCount() {
        return extendedInstructions.length();
    }

    /**
        Gets an extended instruction
    */
    string getExtendedInstructionImport(uint ssaId) {
        if (ssaId in extendedInstructions) {
            return cast(string)extendedInstructions[ssaId][];
        }
        return null;
    }
}