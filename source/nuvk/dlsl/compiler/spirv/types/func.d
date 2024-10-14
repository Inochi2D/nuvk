/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.compiler.spirv.types.func;
import nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.types.instr;
import nuvk.compiler.spirv.defs;
import nuvk.compiler.spirv.mod;
import numem.all;

/**
    A spirv function
*/
class SpirvFunction : SpirvType {
@nogc:
private:
    SpirvModule parent;
    nstring name;
    map!(nstring, SpirvBasicBlock) blocks;
    SpirvExecutionModel model;

    weak_vector!SpirvType parameterTypes;
    SpirvType returnType;

public:
    ~this() {
        nogc_delete(blocks);
    }


    /**
        Creates a function with set parameters
    */
    this(SpirvModule parent, nstring name) {
        super(SpirvTypeKind.typeFunction);
        this.parent = parent;
        this.name = name;

        // Might as well register void with parent.
        this.setReturnType(nuvkSpirvGetVoid());
    }

    /**
        Sets the return type of the function
    */
    final
    SpirvFunction setReturnType(SpirvType returnType) {
        parent.registerType(returnType);
        this.returnType = returnType;
        return this;
    }

    /**
        Sets the return type of the function
    */
    final
    SpirvFunction setParameters(SpirvType[] parameterTypes) {
        foreach(param; parameterTypes) {
            parent.registerType(param);
        }
        
        this.parameterTypes = weak_vector!SpirvType(parameterTypes);
        return this;
    }

    /**
        Gets the return type
    */
    final
    SpirvType getReturnType() {
        return returnType;
    }

    /**
        Gets the parameter types
    */
    final
    SpirvType[] getParameterTypes() {
        return parameterTypes[];
    }

    /**
        Gets or creates a basic block within this function
    */
    final
    SpirvBasicBlock getBasicBlock(nstring name) {
        if (name !in blocks) {
            auto block = nogc_new!SpirvBasicBlock(this);
            blocks[name] = block;
        }
        return blocks[name];
    }

    /**
        Removes a basic block from this function
    */
    final
    void removeBasicBlock(nstring name) {
        if (name in blocks) {
            blocks.remove(name);
        }
    }
}

/**
    A spirv basic block
*/
class SpirvBasicBlock {
@nogc:
private:
    SpirvFunction parent;
    weak_vector!SpirvInstruction instructions;
    bool isFinalized_;

    // To prevent SpirvBasicBlock from attempting
    // to delete its parent function,
    ~this() { }

    this(SpirvFunction parent) {
        this.parent = parent;
        isFinalized_ = false;
    }


public:
    
    /**
        Gets the raw bytecode stream

        You *should* use a bytecode builder to handle
        adding instructions to this.
    */
    ref vector!SpirvInstruction getInstructions() {
        return data;
    }

    /**
        Gets the parent function
    */
    SpirvFunction getFunction() {
        return parent;
    }

    /**
        Whether the block is finalized.
    */
    bool isFinalized() {
        return isFinalized_;
    }

    /**
        Finalize the basic block.

        This marks it as read-only for bytecode emitters.
    */
    void finalize() {
        isFinalized_ = true;
    }
}