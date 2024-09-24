module nuvk.compiler.spirv.types.instr;
import nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.defs;
import numem.all;

/**
    Type of Spirv instruction operand
*/
enum SpirvOperandType {
    none,

    literalInt,
    literalText,
    blockRef,
    basicRef,
    instrRef,
}

/**
    Operand passed to spirv function
*/
struct SpirvOperand {
@nogc:
private:
    SpirvOperandType type;
    union {
        uint literalInt;
        nstring literalText;
        SpirvBasicBlock blockRef;
        SpirvType basicRef;
        SpirvInstruction* instrRef;
    }

public:

    /**
        Destructor
    */
    ~this() {
        final switch(type) {

            // Do not free these.
            case SpirvOperandType.none:
            case SpirvOperandType.literalInt:
            case SpirvOperandType.basicRef:
            case SpirvOperandType.blockRef:
            case SpirvOperandType.instrRef:
                return;

            // Do free these.
            case SpirvOperandType.literalText:
                nogc_delete(literalText);

        }
    }

    /**
        Constructs an operand
    */
    this(uint literalInt) {
        this.type = SpirvOperandType.literalInt;
        this.literalInt = literalInt;
    }

    /**
        Constructs an operand
    */
    this(nstring text) {
        this.type = SpirvOperandType.literalText;
        this.literalText = nstring(literalText);
    }

    /**
        Constructs an operand
    */
    this(SpirvBasicBlock blockRef) {
        this.type = SpirvOperandType.blockRef;
        this.blockRef = blockRef;
    }

    /**
        Constructs an operand
    */
    this(SpirvType basicRef) {
        this.type = SpirvOperandType.basicRef;
        this.basicRef = basicRef;
    }

    /**
        Constructs an operand
    */
    this(SpirvInstruction instrRef) {
        this.type = SpirvOperandType.instrRef;
        this.instrRef = instrRef;
    }

    /**
        Gets the type of the operand
    */
    SpirvOperandType getType() {
        return type;
    }

    /**
        Gets the contents of the operand
    */
    T get(T)() {
        final switch(type) {

            // Empty.
            case SpirvOperandType.none:
                break;

            case SpirvOperandType.literalInt:
                static if(is(T == uint))
                    return literalInt;
                else break;

            case SpirvOperandType.basicRef:
                static if(is(T == SpirvType))
                    return basicRef;
                else break;

            case SpirvOperandType.blockRef:
                static if(is(T == SpirvBasicBlock))
                    return blockRef;
                else break;

            case SpirvOperandType.instrRef:
                static if(is(T* == SpirvInstruction*))
                    return instrRef;

            case SpirvOperandType.literalText:
                static if(is(T == nstring))
                    return literalText;
                else break;

        }
        return T.init;
    }

    /**
        Gets the size of the operand in the spirv stream
    */
    uint getSize() {
        switch(operand.type) {
            
            case SpirvOperandType.none:
                return 0;

            case SpirvOperandType.literalText:
                uint textLength = text.size();

                // Text padded to closest word
                return textLength + (4-(text.size()%4));

            default:
                return 1;
        }
    }

    /**
        Gets whether the operand contains valid data.
    */
    bool isValid() {
        return type != SpirvOperandType.none;
    }
}

/**
    An instruction
*/
struct SpirvInstruction {
@nogc:
public:
    /**
        OpCode of instruction
    */
    SpirvOpCode opcode;

    /**
        Return type, null if no return value
    */
    SpirvType resultType;

    /**
        Whether the instruction has a result
    */
    SpirvOperand result;

    /**
        Operands to pass to instruction
    */
    weak_vector!SpirvOperand operands;

    /**
        Construct an instruction with no operands
    */
    this(SpirvOpCode opcode) {
        this.opcode = opcode;
    }

    /**
        Construct an instruction with no operands
    */
    this(SpirvOpCode opcode, SpirvType resultType, SpirvOperand result) {
        this.opcode = opcode;
        this.resultType = resultType;
        this.result = result;
    }

    /**
        Construct an instruction with no operands
    */
    this(SpirvOpCode opcode, SpirvType resultType, bool returnsValue=true) {
        this.opcode = opcode;
        this.resultType = resultType;

        // Add self as return operand
        if (returnsValue && resultType !is null) {
            result = SpirvOperand(&this);
        }
    }

    /**
        Adds an operand to the instruction
    */
    ref SpirvInstruction addOperand(SpirvOperand operand) {
        this.operands ~= operand;
        return this;
    }

    /**
        Gets the size of the instruction in words
    */
    uint getSize() {

        // Operands can be multiple words long,
        // as such it's best to get the size
        // from the operands themselves.
        uint operandSize = 0;
        foreach(ref operand; operands) {
            operandSize += operand.getSize();
        }

        return 
            // Opcode
            1 + 

            // Return type (if any)
            (returnType ? 1 : 0) +

            // Return value (if any)
            result.getSize() +

            // Operands
            operandSize;
    }
}