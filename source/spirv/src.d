/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module spirv.src;
import spirv;
import spirv.reflection;
import nuvk.core.logging;

import numem.all;

/**
    A parser for SPIR-V modules
*/
abstract
class SpirvSource {
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
            bytecode.length > SpirvHeaderSize,
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

    void parseBytecode() {

        // NOTE: reparseClean may call this again,
        // As such clear the instruction stream.
        this.instructions.clear();

        size_t i = SpirvHeaderSize;
        do {
            uint length = bytecode[i].getOpCodeLength();
            auto instr = nogc_new!SpirvInstr(this.verify(i, length));

            instructions ~= instr;
            
            i += length;
        } while (i < bytecode.length);

        this.parseModInfo();
    }

    void parseModInfo() {
        this.executionModes.clear();
        this.capabilities.clear();

        foreach(ref instr; instructions) {
            switch(instr.getOpCode()) {
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
        Called when the instruction stream is modified.
    */
    void onModified() {
        this.parseModInfo();
        this.parse();
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
        }

        // This happens in 2 steps since there may be back references.
        foreach(ref instr; instructions) {

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
        Instantiates the source.

        This will fix the SPIR-V endianess, verify it, then parse it.
    */
    this(SpirvID[] source) {
        this.pool = nogc_new!SpirvIDPool();
        this.bytecode = vector!SpirvID(source);
        this.fixupEndian();
        this.verify();
        this.reparseClean();
    }


    /**
        Instantiates the source.

        This creates a blank SPIR-V shader which needs to be filled out
        with instructions.
    */
    this() {
        this.pool = nogc_new!SpirvIDPool();
        this.bytecode = vector!SpirvID(SpirvHeaderSize);
        this.bytecode[0] = MagicNumber;
        this.setGenerator(SpirvGeneratorMagicNumber);
        this.setBound(0);
        this.setSchema(0);
        this.reparseClean();
    }

    /**
        Does a full clean re-parse of the bytecode.

        This will destroy any non-emitted instructions
        added to the stream.
    */
    final
    void reparseClean() {
        this.parseBytecode();
        this.parse();
    }

    /**
        Parses the provided source
    */
    final
    void parse() {
        this.remap();

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
        Gets the version of the document.
    */
    final
    void setVersion(uint version_) {
        this.bytecode[1] = version_;
    }

    /**
        Gets the generator used to emit the document.
    */
    final
    uint getGenerator() {
        return bytecode[2];
    }

    /**
        Sets the generator used to emit the document.
    */
    final
    void setGenerator(uint generatorId) {
        this.bytecode[2] = generatorId;
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
        Sets the SPIR-V schema, currently pointless.
    */
    final
    void setSchema(SpirvID schema) {
        this.bytecode[4] = schema;
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
        Gets all of the instructions in the instruction stream.
    */
    final
    SpirvInstr*[] getInstructions() {
        return instructions[];
    }

    /**
        Removes an instruction at an offset.

        This will invalidate and free the instruction.
    */
    final
    void remove(size_t offset) {
        if (offset < instructions.length) {
            instructions.remove(offset);
            this.onModified();
        }
    }
    
    /**
        Removes an instruction from the module.

        This will invalidate and free the instruction.
    */
    final
    void remove(SpirvInstr* instr) {
        auto idx = this.findInstruction(instr);
        if (idx != -1)
            this.remove(idx);
    }

    /**
        Allocates a new instruction for the specified opcode and puts it
        at the specified offset.

        Additionally automatically sets the result ID if applicable.
    */
    final
    SpirvInstr* insert(size_t offset, Op opcode) {
        SpirvInstr* instr = nogc_new!SpirvInstr(opcode);
        if (instr.hasResult())
            instr.setResult(pool.allocate());
        
        instructions.insert(offset, instr);
        this.onModified();
        return instr;
    }

    /**
        Inserts an instruction at the given offset.

        Additionally automatically sets the result ID if applicable.
    */
    final
    SpirvInstr* insert(size_t offset, SpirvInstr toAdd) {
        SpirvInstr* instr = nogc_new!SpirvInstr(toAdd);
        if (instr.hasResult())
            instr.setResult(pool.allocate());
        
        instructions.insert(offset, instr);
        this.onModified();
        return instr;
    }

    /**
        Allocates a new instruction for the specified opcode and puts it at the
        end of the file.
        
        Additionally automatically sets the result ID if applicable.
    */
    final
    SpirvInstr* pushBack(Op opcode) {
        SpirvInstr* instr = nogc_new!SpirvInstr(opcode);
        if (instr.hasResult())
            instr.setResult(pool.allocate());

        instructions.pushBack(instr);
        this.onModified();
        return instr;
    }

    /**
        Allocates a new instruction for the specified opcode and puts it at the
        end of the file.
        
        Additionally automatically sets the result ID if applicable.
    */
    final
    SpirvInstr* pushBack(SpirvInstr toAdd) {
        SpirvInstr* instr = nogc_new!SpirvInstr(toAdd);
        if (instr.hasResult())
            instr.setResult(pool.allocate());

        instructions.pushBack(instr);
        this.onModified();
        return instr;
    }

    /**
        Finds the first instance of a given instruction.
    */
    final
    SpirvInstr* findFirstOf(Op opcode) {
        ptrdiff_t offset = findFirstOfOffset(opcode);
        if (offset != -1)
            return instructions[offset];
        return null;
    }

    /**
        Finds the first instance of a given instruction.
    */
    final
    ptrdiff_t findFirstOfOffset(Op opcode) {
        foreach(i, instr; instructions) {
            if (instr.getOpCode() == opcode) {
                return i;
            }
        }
        return -1;
    }

    /**
        Finds the first instance of a given instruction class.
    */
    final
    SpirvInstr* findFirstOf(OpClass class_) {
        ptrdiff_t offset = findFirstOfOffsetForClass(class_);
        if (offset != -1)
            return instructions[offset];
        return null;
    }

    /**
        Finds the first instance of a given instruction class.
    */
    final
    ptrdiff_t findFirstOfOffsetForClass(OpClass class_) {
        foreach(i, instr; instructions) {
            if (instr.getOpClass() == class_) {
                return i;
            }
        }
        return -1;
    }

    /**
        Allocates a new instruction for the specified opcode.
        The opcode will be inserted at the nearest instruction of the same type.
        If there's no such instruction, it will try to put it near the first instruction
        of the same instruction class.
        Finally if that fails, it will be put at the last instruction before the first 
        OpFunction or at the end of the file.

        Additionally automatically sets the result ID if applicable.
    */
    final
    SpirvInstr* insertNear(Op opcode, SpirvInstr instr) {

        // Try to find the first instance of opcode.
        ptrdiff_t offset = this.findFirstOfOffset(opcode);
        if (offset != -1) 
            return this.insert(offset, instr);
        
        // Try finding any related instructions
        offset = this.findFirstOfOffsetForClass(opcode.getClass());
        if (offset != -1) 
            return this.insert(offset-1, instr);

        // That failed, try to find OpFunction and insert behind that.
        offset = this.findFirstOfOffset(Op.OpFunction);
        if (offset != -1) 
            return this.insert(offset-1, instr);

        // That failed, insert at end of file.
        return this.pushBack(instr);
    }

    /**
        Finds a instruction by its result id.
    */
    final
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
        Finds a instruction by its result id.
    */
    final
    ptrdiff_t findInstruction(SpirvInstr* toFind) {
        foreach(i, instr; instructions) {
            if (instr == toFind) {
                return i;
            }
        }
        return -1;
    }

    /**
        Emits any modifications made to the bytecode.
    */
    final
    void emit() {

        // Remap IDs before emitting.
        this.remap();
        this.parseModInfo();
        this.bytecode.resize(SpirvHeaderSize);

        // Since we've emitted code now, set all these variables.
        this.setGenerator(SpirvGeneratorMagicNumber);
        this.setBound(pool.getAllocated());

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