module nuvk.compiler.spirv.builder;
import nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.defs;
import nuvk.compiler.spirv.mod;
import numem.all;

/**
    A builder which builds bytecode
*/
class SpirvBuilder {
@nogc:
private:
    SpirvModule module_;
    SpirvFunction function_;
    SpirvBasicBlock target;
    vector!(ubyte)* targetBuffer;

    void finalizeTarget() {
        target.finalize();
        target = null;
        targetBuffer = null;
    }

public:

    /**
        Creates a builder for a module
    */
    this(SpirvModule module_, SpirvFunction function_) {
        this.module_ = module_;
        this.function_ = function_;
    }

    /**
        Targets the specified block for writing.
    */
    void targetBlock(nstring name) {
        enforce(!function_.getBasicBlock(name).isFinalized(), "Can't append to finalized basic block!");

        target = function_.getBasicBlock(name);
        targetBuffer = &target.getInstructions();
    }

    /**
        This has no semantic impact and can safely be removed from a module.
    */
    void buildNOP() {
        if (!target) return;

        targetBuffer ~= SpirvInstruction(SpirvOpCode.opNOP);
    }

    /**
        Make an intermediate object whose value is undefined.
    */
    void buildUndef(SpirvType type) {
        if (!target) return;

        targetBuffer ~= SpirvInstruction(SpirvOpCode.opUndef, type);
    }

    /**
        Computes the run-time size of the type pointed to by Pointer
    */
    void buildSizeOf(SpirvOperand item) {
        if (!target) return;

        targetBuffer ~= 
            SpirvInstruction(SpirvOpCode.opSizeOf, nuvkSpirvCreateUInt32())
            .addOperand(item);
    }

    /**
        Execute an instruction in an imported set of extended instructions.
    */
    void buildExtInst(SpirvType type, SpirvOperand set, uint instruction, SpirvOperand[] operands) {
        if (!target) return;

        SpirvInstruction instr = SpirvInstruction(SpirvOpCode.opExtInst, type)
            .addOperand(set)
            .addOperand(SpirvOperand(instruction));
        
        foreach(operand; operands) {
            instr.addOperand(operand);
        }
        targetBuffer ~= instr;
    }

    /**
        Branch to basic block.
    */
    void buildBranch(SpirvBasicBlock block) {
        if (!target) return;

        enforce(block.getFunction() == target.getFunction(), 
            nstring("Can't jump to basic block in other function!")
        );

        targetBuffer ~= 
            SpirvInstruction(SpirvOpCode.opBranch)
            .addOperand(SpirvOperand(block));
        this.finalizeTarget();
    }

    /**
        Branch to basic block.
    */
    void buildBranch(SpirvOperand condition, SpirvBasicBlock onTrue, SpirvBasicBlock onFalse) {
        if (!target) return;

        enforce(onTrue.getFunction() == target.getFunction(), 
            nstring("Can't jump to basic block in other function!")
        );

        enforce(onFalse.getFunction() == target.getFunction(), 
            nstring("Can't jump to basic block in other function!")
        );

        targetBuffer ~= 
            SpirvInstruction(SpirvOpCode.opBranchConditional)
            .addOperand(condition)
            .addOperand(onTrue)
            .addOperand(onFalse);
        this.finalizeTarget();
    }

    /**
        Discards fragment
    */
    void buildDiscard() {
        if (!target) return;

        targetBuffer ~= SpirvInstruction(SpirvOpCode.opKill);
        this.finalizeTarget();
    }
}