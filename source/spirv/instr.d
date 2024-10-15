/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    SPIR-V Instructions and tools to parse and generate them.
*/
module spirv.instr;
import spirv.spv;
import spirv;
import spirv.src;

import numem.collections;
import numem.io.endian;
import numem.string;
import numem.core.memory;
import numem.format;
import conv = numem.conv;

/**
    Gets the length of an opcode
*/
uint getOpCodeLength(SpirvID op) @nogc nothrow {
    return op >> WordCountShift;
}

/**
    Gets the opcode stored in a SPIR-V ID
*/
Op getOpCodeOnly(SpirvID op) @nogc nothrow {
    return cast(Op)(op & OpCodeMask);
}

/**
    Creates a combined SpirvID opcode + operand count
*/
SpirvID getCombinedOp(Op opcode, uint wordCount) @nogc nothrow {
    return (wordCount << WordCountShift) | (cast(SpirvID)opcode);
}

/**
    Fixes word in instruction stream to local endianess.
*/
uint fixWord(SpirvID word, Endianess endian) @nogc nothrow {
    return toEndianReinterpret(word, endian);
}

/**
    Parses a SPIR-V compliant string from a range of [SpirvID]s
*/
nstring fromSpirvString(T)(auto ref T ids) @nogc if (isCompatibleRange!(T, SpirvID)) {
    nstring str;
    char tmp;

    mainLoop: foreach(id; ids) {

        // Unroll this loop.
        static foreach(i; 0..SpirvID.sizeof) {
            tmp = cast(char)(id >> (i * 8));

            // No need to add null terminators.
            // Also, we can assume that SPIR-V strings
            // won't have null terminators in the middle
            // of a string, so should be fine.
            if (tmp == '\0')
                break mainLoop;
            
            str ~= tmp;
        }
    }

    return str;
}

size_t getSpirvStringLength(T)(auto ref T ids) @nogc nothrow if (isCompatibleRange!(T, SpirvID)) {
    size_t len = 0;
    foreach(id; ids) {
        bool hasNullTerminator = !(id | 0x000000FF && id | 0x0000FF00 && id | 0x00FF0000 && id | 0xFF000000);
        if (hasNullTerminator)
            break;
        
        len++;
    }
    return len+1;
}

/**
    Emits a SPIR-V compliant string from a nstring.
*/
vector!SpirvID toSpirvString(nstring str) @nogc nothrow {
    vector!SpirvID oStr;

    uint acc;
    SpirvID tmp;
    foreach(char c; str) {
        tmp |= (c << acc*8);
        acc++;

        if (acc == 4) {

            oStr ~= tmp;
            acc = 0;
            tmp = 0;
        }
    }
    oStr ~= tmp;
    return oStr;
}

/**
    A single SPIR-V instruction
*/
struct SpirvInstr {
@nogc:
private:
    Op opcode;
    vector!SpirvID operands;

public:

    ~this() nothrow {
        nogc_delete(operands);
    }

    /**
        Copy constructor
    */
    this(ref SpirvInstr rhs) {
        this.opcode = rhs.opcode.getOpCodeOnly();
        this.operands = vector!SpirvID(operands);
    }

    /**
        Instantiates the instruction
    */
    this(SpirvID[] source) {
        this.opcode = source[0].getOpCodeOnly();
        if (source.length > 1)
            this.operands = source[1..$];
    }

    /**
        Instantiates the instruction
    */
    this(Op opcode) {
        this.opcode = opcode.getOpCodeOnly();
        this.operands = vector!SpirvID(opcode.getMinLength());
    }

    /**
        Instantiates the instruction
    */
    this(T)(Op opcode, auto ref T ops) if (isCompatibleRange!(T, SpirvID)) {
        this.opcode = opcode.getOpCodeOnly();
        this.operands = vector!SpirvID(cast(SpirvID[])ops[]);
    }

    /**
        Gets the opcode for the instruction
    */
    Op getOpCode() {
        return opcode;
    }

    /**
        Gets the class of the instruction's opcode.
    */
    OpClass getOpClass() {
        return opcode.getClass();
    }

    /**
        Gets the total size of the instruction
    */
    size_t getSize() {
        return 1+operands.length; 
    }

    /**
        Gets whether the instruction is a type declaration.
    */
    bool isTypeDeclaration() {
        return opcode.isTypeDeclaration();
    }

    /**
        Pushes an operand to the operands
    */
    void push(SpirvID operand) {
        this.operands.pushBack(operand);
    }

    /**
        Pushes a string operand to the operands
    */
    void push(nstring str) {
        auto operand = toSpirvString(str);
        this.operands.pushBack(operand);
    }

    /**
        Inserts an operand at the specified offset
    */
    void insert(size_t offset, SpirvID operand) {
        this.operands.insert(offset, operand);
    }

    /**
        Inserts a string operand at the specified offset
    */
    void insert(size_t offset, nstring str) {
        auto operand = toSpirvString(str);
        this.operands.insert(offset, operand);
    }

    /**
        Removes operand(s) from the instruction
    */
    void remove(size_t offset, size_t length = 1) {
        this.operands.remove(offset, offset+length);
    }

    /**
        Clears all operands from the instruction
    */
    void clear() {
        this.operands.clear();
    }

    /**
        Resizes the operand list for the instruction.
    */
    void resize(size_t operandCount) {
        this.operands.resize(operandCount);
    }

    /**
        Gets the operands of the instruction
    */
    SpirvID[] getOperands() {
        return operands[];
    }

    /**
        Gets how many operands are stored in the instruction.
    */
    uint getOperandCount() {
        return cast(uint)operands.length;
    }

    /**
        Gets the operands of the instruction
    */
    SpirvID getOperand(size_t offset) {
        if (isOffsetInRange(offset))
            return operands[offset];
        return SPIRV_NO_ID;
    }

    /**
        Gets the string operand of the instruction
    */
    nstring getOperandString(size_t offset, size_t wordCount) {
        if (isOffsetInRange(offset) && isOffsetInRange(offset+wordCount))
            return fromSpirvString(operands[offset..offset+wordCount]);
        return nstring.init;
    }

    /**
        Gets the string operand of the instruction
    */
    nstring getOperandString(size_t offset) {
        if (isOffsetInRange(offset))
            return fromSpirvString(operands[offset..$]);
        return nstring.init;
    }

    /**
        Sets an operand
    */
    void setOperand(size_t offset, SpirvID id) {
        if (isOffsetInRange(offset))
            operands[offset] = id;
    }

    /**
        Whether the instruction has a result id.
    */
    bool hasResult() {
        return opcode.hasResult();
    }

    /**
        Gets the ID of the result.
        Returns [SPIRV_NO_ID] if instruction has no result.
    */
    SpirvID getResult() {
        if (this.hasResult())
            return operands[hasResultType()];
        else
            return SPIRV_NO_ID;
    }

    /**
        Sets the result ID if the opcode for the instruction
        has a result.
    */
    void setResult(SpirvID id) {
        if (this.hasResult())
            operands[hasResultType()] = id;
    }

    /**
        Whether the instruction has a result type id.
    */
    bool hasResultType() {
        return opcode.hasResultType();
    }

    /**
        Gets the ID of the result type.

        Returns [SPIRV_NO_ID] if instruction has no result type.
    */
    SpirvID getResultType() {
        if (hasResultType())
            return operands[0];
        else
            return SPIRV_NO_ID;
    }

    /**
        Sets the result type ID if the opcode for the 
        instruction has a result.
    */
    void setResultType(SpirvID id) {
        if (hasResultType())
            operands[0] = id;
    }

    /**
        Gets whether an operand offset is in range.
    */
    bool isOffsetInRange(size_t offset) {
        return offset < operands.length;
    }

    /**
        Gets whether the instruction has IDRef operands.
    */
    bool hasRefOperands() {
        if (hasArbitraryRefIndices())
            return true;
        
        auto operands = opcode.getIDRefIndices();
        auto optionalOperands = opcode.getOptionalIDRefIndices();
        return operands.length > 0 || optionalOperands.length > 0;
    }

    /**
        Whether the instruction has artibrary amount of IdRefs
        at the end of the instruction.
    */
    bool hasArbitraryRefIndices() {
        return opcode.getHasArbitraryRefIndices();
    }

    /**
        Gets where arbitrary indices start.
    */
    size_t getArbitraryIndiceStart() {
        return opcode.getMinLength();
    }

    /**
        Gets the offsets into the operands that required
        IDRefs reside.
    */
    vector!uint getRefOperandOffsets() {
        vector!uint tmp;
        tmp ~= opcode.getIDRefIndices();
        tmp ~= opcode.getOptionalIDRefIndices();
        return tmp;
    }

    /**
        Gets the offsets into the operands that required
        IDRefs reside.
    */
    vector!uint getRequiredRefOperandOffsets() {
        return opcode.getIDRefIndices();
    }

    /**
        Gets the offsets into the operands that required
        IDRefs reside.
    */
    vector!uint getOptionalRefOperandOffsets() {
        return opcode.getOptionalIDRefIndices();
    }

    /**
        Verifies that the operands of the instruction are well formed.
        This does not verify whether IDs are correct.
    */
    bool verify() {
        size_t opcount = operands.length;
        return opcount >= opcode.getMinLength() && opcount <= opcode.getMaxLength();
    }

    /**
        Emits the opcode
    */
    vector!SpirvID emit() {
        vector!SpirvID ret;
        ret ~= opcode.getCombinedOp(cast(uint)this.getSize());
        ret ~= operands;
        return ret;
    }

    /**
        Gets a string describing the instruction
    */
    nstring toString() {
        if (hasResult())
            return "%{0} = {1} ({2} args)".format(getResult(), conv.toString(opcode), operands.length-1);
        return "{0} ({1} args)".format(conv.toString(opcode), operands.length);
    }
}

/**
    A SPIR-V Pool allocation
*/
struct SpirvIDAllocation {

    /**
        Whether the ID is mapped to the source
    */
    bool mappedToSource;
    
    /**
        Original ID from source
    */
    SpirvID originalId;
    
    /**
        Virtual ID that has been allocated.
    */
    SpirvID virtualId;
}

/**
    An pool for allocating SpirvIDs
*/
class SpirvIDPool {
@nogc
private:
    SpirvID currentId = 1;
    bool canFinalize = false;
    vector!SpirvIDAllocation vIds;

    ptrdiff_t findOriginal(SpirvID id) {
        foreach(i, ref mapped; vIds) {
            if (mapped.originalId == id)
                return i;
        }
        
        return -1;
    }

    ptrdiff_t findVirtual(SpirvID id) {
        foreach(i, ref mapped; vIds) {
            if (mapped.virtualId == id)
                return i;
        }
        
        return -1;
    }

    /**
        Allocates an ID and creates a mapping for it.

        If a mapping for the original ID already exists,
        returns that instead.
    */
    SpirvID allocate(SpirvID originalId) {
        auto idx = this.findOriginal(originalId);
        if (idx == -1) {
            auto outId = this.next();

            vIds ~= SpirvIDAllocation(
                mappedToSource: true,
                originalId: originalId,
                virtualId: outId,
            );
            return outId;
        }
        return vIds[idx].virtualId;
    }

    // Gets the next ID and increments the ID
    SpirvID next() {
        return currentId++;
    }

public:

    void allocateAll(SpirvInstr*[] instructions) {
        foreach(i, ref instr; instructions) {
            if (instr.hasResult()) {
                this.allocate(instr.getResult());
            }
        }
    }

    /**
        Allocates a virtual ID without mapping it to
        a pre-existing ID.
    */
    SpirvID allocate() {
        auto outId = this.next();

        vIds ~= SpirvIDAllocation(
            mappedToSource: false,
            originalId: outId,
            virtualId: outId
        );
        return outId;
    }

    /**
        Gets whether an ID is allocated.
    */
    bool getAllocated(SpirvID virtualId) {
        return findVirtual(virtualId) != -1;
    }

    /**
        Gets an allocated ID by its virtual ID
    */
    SpirvIDAllocation getAllocation(SpirvID virtualId) {
        auto idx = this.findOriginal(virtualId);
        if (idx != -1)
            return vIds[idx];
        return SpirvIDAllocation.init;
    }

    /**
        Gets the original ID that was mapped to
        [virtualId].

        Otherwise returns the ID given.
    */
    SpirvID getVirtualId(SpirvID originalId) {
        auto idx = this.findOriginal(originalId);
        if (idx != -1)
            return vIds[idx].virtualId;
        return originalId;
    }

    /**
        Gets the original ID that was mapped to
        [virtualId].

        Otherwise returns the ID given.
    */
    SpirvID getOriginalId(SpirvID virtualId) {
        auto idx = this.findVirtual(virtualId);
        if (idx != -1 && vIds[idx].mappedToSource)
            return vIds[idx].originalId;
        return virtualId;
    }

    /**
        Gets the highest ID currently allocated by the pool
    */
    SpirvID getAllocated() {
        return currentId;
    }

    /**
        Finalizes initial pool setup, turning
        virtual IDs in to original IDs.
        
        This allows new remapping to occur
    */
    void finalize() {
        foreach(ref id; vIds) {
            id.mappedToSource = true;
            id.originalId = id.virtualId;
        }
    }

    void clear() {
        this.currentId = 1;
        vIds.clear();
    }
}