/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module spirv.parser;
import spirv;
import nuvk.core.logging;

import numem.all;

/**
    A parser for SPIR-V modules
*/
abstract
class SpirvParserBase {
@nogc:
private:
    SpirvIDPool pool;
    vector!SpirvID bytecode;
    vector!(SpirvInstr*) instructions;

    // Information gotten while parsing.
    ExecutionModel executionModel;
    weak_vector!ExecutionMode executionModes;
    weak_vector!Capability capabilities;

    void fixupEndian() {
        if (bytecode.length == 0)
            return;

        // Flip endianess of entire source
        // if neccesary.
        if (bytecode[0] != MagicNumber) {
            foreach(ref op; bytecode) {
                op.fixWord(ALT_ENDIAN);
            }
        }
    }

    void verify() {
        nuvkEnforce(
            bytecode.length > 5,
            "Not SPIR-V source! (too short)"
        );

        nuvkEnforce(
            bytecode[0] == MagicNumber,
            "Not SPIR-V source! (Invalid magic number)"
        );
    }

    SpirvID[] verify(size_t offset, size_t length) {
        nuvkEnforce(
            offset+length <= bytecode.length,
            "Opcode out of bounds!"
        );
        return bytecode[offset..offset+length];
    }

    // Gets the total size of the bytecode stored in
    // instructions list.
    size_t getCodeSize() {
        size_t size;
        foreach(ref instr; instructions) {
            size += instr.getSize();
        }
        return size;
    }

    void preparse() {

        // Instruction stream starts a byte 5.
        size_t i = 5;
        do {
            uint length = getOpLength(bytecode[i]);
            auto instr = nogc_new!SpirvInstr(this.verify(i, length));

            instructions ~= instr;
            
            i += length;
        } while (i < bytecode.length);

        this.parseModInfo();
    }

    void parseModInfo() {
        foreach(ref instr; instructions) {
            switch(instr.getOpcode()) {
                case Op.OpEntryPoint:
                    this.executionModel = cast(ExecutionModel)instr.getOperand(0);
                    break;

                case Op.OpExecutionModeId:
                case Op.OpExecutionMode:
                    this.executionModes ~= cast(ExecutionMode)instr.getOperand(1);
                    break;
                
                case Op.OpCapability:
                    this.capabilities ~= cast(Capability)instr.getOperand(0);
                    break;
                
                default:
                    break;
            }
        }
    }

protected:

    /**
        Called at the beginning of parsing.
    */
    abstract void onParseBegin();

    /**
        Called by the implementing parser to parse an instruction in the stream.
    */
    abstract void onParse(SpirvInstr* instr);

    /**
        Called at the end of parsing.
    */
    abstract void onParseFinalize();

    /**
        Called when a remapping pass begins.
    */
    abstract void onRemapBegin();

    /**
        Called when an item is remapped.
    */
    abstract void onRemap(SpirvID oldId, SpirvID newId);

    /**
        Called when a remapping pass ends.
    */
    abstract void onRemapEnd();

    /**
        Gets an instruction by its result id
    */
    final
    bool get(SpirvID id, ref SpirvInstr* instr) {
        foreach(ref instr_; instructions) {
            if (instr.getResult() == id) {
                instr = instr_;
                return true;
            }
        }
        return false;
    }

    final
    SpirvInstr*[] getInstructions() {
        return instructions[];
    }

public:

    /**
        Remaps all the SPIR-V IDs in the instruction stream.
    */
    void remap() {
        pool.clear();

        // First add all existing results
        // To the mapping list.
        this.onRemapBegin();
        pool.allocateAll(instructions[]);

        // Then update all the IDs.
        foreach(ref instr; instructions) {

            if (instr.hasResult()) {
                auto oldId = instr.getResult();
                auto newId = pool.getVirtualId(oldId);
                instr.setResult(newId);
                this.onRemap(oldId, newId);
            }

            // Make type refer to the correct IDs
            if (instr.hasResultType()) {
                auto resultTypeId = instr.getResultType();
                instr.setResultType(pool.getVirtualId(resultTypeId));
            }

            auto refOperands = instr.getRefOperandOffsets();
            foreach(offset; refOperands) {
                if (instr.isOffsetInRange(offset)) {
                    auto refId = instr.getOperand(offset);
                    instr.setOperand(offset, pool.getVirtualId(refId));
                }
            }

            if (instr.hasArbitraryRefIndices()) {
                foreach(offset; instr.getArbitraryIndiceStart()..instr.getOperandCount()) {
                    auto refId = instr.getOperand(offset);
                    instr.setOperand(offset, pool.getVirtualId(refId));
                }
            }
        }

        pool.finalize();
        this.onRemapEnd();
    }

    ~this() {
        nogc_delete(bytecode);
        nogc_delete(instructions);
    }

    /**
        Instantiates the parser.

        This will fix the SPIR-V endianess and verify it.
    */
    this(SpirvID[] source) {
        this.pool = nogc_new!SpirvIDPool();
        this.bytecode = vector!SpirvID(source);
        this.fixupEndian();
        this.verify();
    }

    /**
        Parses the provided source
    */
    final
    void parse() {

        this.preparse();
        this.remap();
        this.emit();

        // We call the implementor afterwards,
        // This allows the parser to look up IDs
        this.onParseBegin();

            foreach(ref instr; instructions) {
                this.onParse(instr);
            }

        this.onParseFinalize();
    }

    /**
        Gets the version of the document.
    */
    final
    uint getVersion() {
        return bytecode[1];
    }

    /**
        Gets the generator used to emit the document.
    */
    final
    uint getGenerator() {
        return bytecode[2];
    }

    /**
        Gets how many IDs the document reports having
        bound.
    */
    final
    uint getBound() {
        return bytecode[3];
    }

    /**
        Sets the bound in the spirv code.
    */
    final
    void setBound(uint bound) {
        bytecode[3] = bound;
    }

    /**
        Reserved SPIR-V schema, currently pointless.
    */
    final
    uint getSchema() {
        return bytecode[4];
    }

    /**
        Gets the declared execution model for the module.
    */
    final
    ExecutionModel getExecutionModel() {
        return executionModel;
    }

    /**
        Gets the declared execution modes for the module.
    */
    final
    ExecutionMode[] getExecutionModes() {
        return executionModes[];
    }

    /**
        Gets the declared capabilties for the module.
    */
    final
    Capability[] getCapabilities() {
        return capabilities[];
    }

    /**
        Allocates a new instruction for the specified opcode.
        Additionally automatically sets the result ID if applicable.
    */
    SpirvInstr* insert(SpirvID offset, Op opcode) {
        SpirvInstr* instr = nogc_new!SpirvInstr(opcode);
        if (instr.hasResult())
            instr.setResult(pool.allocate());
        
        instructions.insert(offset, instr);
        return instr;
    }

    /**
        Finds a instruction by its result id.
    */
    SpirvInstr* findInstruction(SpirvID id) {
        foreach(instr; instructions) {
            if (instr.hasResult()) {
                if (instr.getResult() == id)
                    return instr;
            }
        }
        return null;
    }


    /**
        Emits any modifications made to the bytecode.
    */
    final
    ref vector!uint emit() {

        // Remap IDs before emitting.
        this.remap();
        
        // First resize to fit all of our instructions
        this.bytecode.resize(5);

        // Write every single instruction in our instruction list in.
        // Instruction is also verified before being written.
        foreach(ref SpirvInstr* instr; instructions) {
            nuvkEnforce(
                instr.verify(),
                "Malformed SPIR-V instruction {0}!",
                instr.toString()[] // TODO: Fix this.
            );

            this.bytecode ~= instr.emit();
        }
        return bytecode;
    }

    /**
        Gets the bytecode as it is currently.

        This will NOT emit any bytecode that has been modified.
        To emit bytecode see [emit]
    */
    final
    SpirvID[] getBytecode() {
        return this.bytecode[];
    }
}