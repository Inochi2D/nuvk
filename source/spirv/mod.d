/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module spirv.mod;
import spirv.spv;
import spirv;
import spirv.src;

import nuvk.core.logging;

import numem.all;
import std.file;
import std.traits : EnumMembers;

class SpirvModule {
@nogc:
private:
    SpirvParsedModule parsed;

public:
    ~this() {
        nogc_delete(parsed);
    }

    /**
        Parses SPIR-V source and instantiates a new SpirvModule.
    */
    this(U)(auto ref U source) if (isCompatibleRange!(U, SpirvID)) {
        parsed = nogc_new!SpirvParsedModule(cast(SpirvID[])source[0..$], this);
    }

    /**
        Finds a variant by its ID.
    */
    SpirvVariant find(SpirvID id) {
        foreach(ref variant; parsed.variants) {
            foreach(ref item; variant) {
                if (item.getId() == id)
                    return item;
            }
        }
        return null;
    }

    /**
        Finds a type by its ID.
    */
    SpirvType findType(SpirvID id) {
        foreach(type; this.getTypes()) {
            if (type.getId() == id)
                return cast(SpirvType)type;
        }
        return null;
    }

    /**
        Finds all decorations for an ID.
    */
    weak_vector!SpirvDecoration findDecorationsFor(SpirvID id) {
        weak_vector!SpirvDecoration decorations;
        foreach(ref decor; this.getDecorations()) {
            if (decor.getTargetId() == id)
                decorations ~= decor;
        }
        return decorations;
    }

    /**
        Gets the specified decoration for the type id.
    */
    SpirvDecoration getDecorationFor(SpirvID id, Decoration decoration) {
        foreach(ref decor; this.getDecorations()) {
            if (decor.getTargetId() == id && decor.getDecoration() == decoration)
                return decor;
        }
        return null;
    }

    /**
        Sets the specified decoration for the type id.
    */
    SpirvDecoration setDecorationFor(SpirvID id, Decoration decoration) {
        if (auto decor = this.getDecorationFor(id, decoration)) {
            return decor;
        }

        // Create instruction before emitting it.
        SpirvInstr instr = SpirvInstr(Op.OpDecorate);
        instr.setOperand(0, id);             // Target ID
        instr.setOperand(1, decoration);     // Decoration type
        instr.push(0);                       // Decoration value 0


        // Make sure we're applying it to a variable.
        parsed.insertNear(Op.OpDecorate, instr);
        parsed.parse();
        return this.getDecorationFor(id, decoration);
    }

    /**
        Gets the first decoration argument for the specified ID
        and decoration type.

        If not declared, returns 0.
    */
    SpirvID getDecorationArgFor(SpirvID id, Decoration decoration) {
        if (auto decor = this.getDecorationFor(id, decoration))
            return decor.getArguments[0];
        return 0;
    }

    /**
        Sets the first decoration argument for the specified ID
        and decoration type.

        If decoration doesn't exist, creates it.
        If this for some reason fails, returns SPIRV_NO_ID
        Otherwise returns the value that was set.
    */
    SpirvID setDecorationArgFor(SpirvID id, Decoration decoration, SpirvID value, size_t offset = 0) {
        if (auto decor = this.setDecorationFor(id, decoration)) {
            decor.setArgument(offset, value);
            return value;
        }
        return SPIRV_NO_ID;
    }

    /**
        Gets all the declared variables in the module.
    */
    SpirvVariable[] getVariables() {
        return cast(SpirvVariable[])parsed.variants[SpirvVariantKind.kVariable][];
    }

    /**
        Finds a variable with the given ID.
    */
    SpirvVariable findVariable(SpirvID id) {
        foreach(ref SpirvVariable var; this.getVariables())
            if (var.getId() == id)
                return var;
        return null;
    }

    /**
        Gets all the declared variables in the module for the specified class.
    */
    weak_vector!SpirvVariable getVariablesForClass(StorageClass class_) {
        weak_vector!SpirvVariable tmp;
        foreach(ref SpirvVariable var; this.getVariables())
            if (var.getStorageClass() == class_)
                tmp ~= var;
        return tmp;
    }

    /**
        Gets all the declared variables in the module for the specified class.
    */
    weak_vector!SpirvVariable getVariablesForKind(SpirvVarKind kind) {
        weak_vector!SpirvVariable tmp;
        foreach(ref SpirvVariable var; this.getVariables())
            if (var.getVarKind() == kind)
                tmp ~= var;
        return tmp;
    }

    /**
        Gets all the declared types in the module.
    */
    final
    SpirvType[] getTypes() {
        return cast(SpirvType[])parsed.variants[SpirvVariantKind.kType][];
    }

    /**
        Gets all the declared decorations in the module.
    */
    final
    SpirvDecoration[] getDecorations() {
        return cast(SpirvDecoration[])parsed.variants[SpirvVariantKind.kDecoration][];
    }

    /**
        Gets all the variants of which a more specific type could not
        be determined.
    */
    final
    SpirvVariant[] getVariants() {
        return parsed.variants[SpirvVariantKind.kBasic][];
    }

    /**
        Gets all the entrypoints declared for this module.
    */
    final
    SpirvEntryPoint[] getEntryPoints() {
        return cast(SpirvEntryPoint[])parsed.variants[SpirvVariantKind.kEntryPoint][];
    }

    /**
        Gets the declared execution model for the module.
    */
    final
    ExecutionModel getExecutionModel() {
        return parsed.getExecutionModel();
    }

    /**
        Gets the declared execution modes for the module.
    */
    final
    ExecutionMode[] getExecutionModes() {
        return parsed.getExecutionModes();
    }

    /**
        Gets the declared capabilties for the module.
    */
    final
    Capability[] getCapabilities() {
        return parsed.getCapabilities();
    }

    /**
        Makes the module re-parse all of the instructions in the stream.
    */
    final
    void reparse() {
        parsed.parse();
    }

    /**
        Emits the SPIR-V that has been modified.

        Returns a slice of the newly emiited bytecode.
        If you just need to get the bytecode after emitting, see [getBytecode]
    */
    final
    SpirvID[] emit() {
        parsed.emit();
        return parsed.getBytecode();
    }

    /**
        Gets the currently stored bytecode in the internal parser.

        This will NOT emit any changes.
    */
    final
    SpirvID[] getBytecode() {
        return parsed.getBytecode();
    }
}

/**
    A parser which parses an entire SPIR-V module
    
    This parser is meant for reflection and basic
    instruction emitting.
*/
class SpirvParsedModule : SpirvSource {
@nogc:
private:
    SpirvModule parent;
    vector!(SpirvVariant)[SpirvVariantKindCount] variants;
    
    SpirvVariant findVariant(SpirvID id) {
        foreach(kind; 0..cast(size_t)SpirvVariantKindCount) {
            if (auto found = this.findVariant(cast(SpirvVariantKind)kind, id)) {
                return found;
            }
        }
        return null;
    }

    SpirvVariant findVariant(SpirvVariantKind kind, SpirvID id) {
        foreach(ref variant; variants[kind][]) {
            if (variant.getId() == id)
                return variant;
        }
        return null;
    }

protected:

    override
    void onParseBegin() {
        static foreach(kind; EnumMembers!SpirvVariantKind) {
            variants[kind].clear();
        }
    }

    override
    void onParse(SpirvInstr* instr) {
        auto opcode = instr.getOpCode();
        if (opcode == Op.OpEntryPoint) {
            variants[SpirvVariantKind.kEntryPoint] ~= nogc_new!SpirvEntryPoint(parent, instr);
            return;
        }

        switch(opcode.getClass()) {

            case OpClass.cTypeDeclaration:
                variants[SpirvVariantKind.kType] ~= nogc_new!SpirvType(parent, instr);
                return;
                
            case OpClass.cMemory:
                if (opcode == Op.OpVariable)
                    variants[SpirvVariantKind.kVariable] ~= nogc_new!SpirvVariable(parent, instr);
                else 
                    goto default;
                return;
                
            case OpClass.cAnnotation:
                variants[SpirvVariantKind.kDecoration] ~= nogc_new!SpirvDecoration(parent, instr);
                return;

            default:

                // Fallback
                variants[SpirvVariantKind.kBasic] ~= nogc_new!SpirvVariant(parent, instr);
                return;
        }
        
    }
    
    override
    void onParseFinalize() {

        mainLoop: foreach(ref instr; this.getInstructions()) {
            switch(instr.getOpCode()) {

                case Op.OpName:
                    if (instr.getOperands().length == 1)
                        continue mainLoop;

                    if (auto target = this.findVariant(instr.getOperand(0))) {
                        nstring str = nstring(instr.getOperandString(1)[]);
                        target.setName(str);
                    }
                    continue mainLoop;

                default:
                    continue mainLoop;
            }
        }
    }

    override
    void onRemapBegin() { }

    override
    void onRemap(SpirvID oldId, SpirvID newId) { }

    override
    void onRemapEnd() {
        foreach(kind; 0..cast(size_t)SpirvVariantKindCount) {
            foreach(ref variant; variants[kind][]) {
                variant.onRemap();
            }
        }
    }

public:
    this(SpirvID[] source, SpirvModule parent) {
        this.parent = parent;
        super(source);
    }
}