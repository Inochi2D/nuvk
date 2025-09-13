/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module spirv.variant;
import spirv;

import nulib.collections;
import nulib.string;

/**
    Variant kinds
*/
enum SpirvVariantKind {
    basic      = 0,
    type       = 1,
    variable   = 2,
    decoration = 3,
    constant   = 4,
    entryPoint = 5,
}

/**
    Gets the amount of variants in the SpirvVariantKind enum
*/
enum SpirvVariantKindCount = __traits(allMembers, SpirvVariantKind).length;

/**
    Variant containing specialised information about an instruction.
*/
class SpirvVariant {
@nogc:
private:
    SpirvModule mod;
    SpirvVariantKind kind;
    nstring name;

protected:

    /**
        Constructor
    */
    this(SpirvModule mod, SpirvInstr* instr, SpirvVariantKind kind) {
        this.mod = mod;
        this.instr = instr;
        this.kind = kind;
        this.onIntrospect(this.instr.getOpCode());
    }

    /**
        The source instruction for this variant.
    */
    SpirvInstr* instr;

    /**
        Called by implementation to introspect based on the opcode.
    */
    void onIntrospect(Op opcode) { }

public:

    /**
        Allows constructing a variant without any extra info.
    */
    this(SpirvModule mod, SpirvInstr* instr) {
        this(mod, instr, SpirvVariantKind.basic);
    }

    /**
        Called by implementation when a remapping occurs.
    */
    final
    void onRemap() {
        this.onIntrospect(instr.getOpCode());
    }

    /**
        Gets the ID of the variant.

        Will be [SPIRV_NO_ID] if this variant has no ID mapping.
    */
    final
    SpirvID getId() {
        return instr.getResult();
    }

    /**
        Gets the name assigned to this variant
    */
    final
    string getName() {
        return name.toDString();
    }

    /**
        Sets the name assigned to this variant
    */
    final
    void setName(nstring str) {
        this.name = str;
    }

    /**
        Gets a slice containing the operands for this instruction.
    */
    final
    SpirvID[] getOperands() {
        return instr.getOperands();
    }

    /**
        Gets what kind of variant this is.
    */
    final
    SpirvVariantKind getKind() {
        return kind;
    }

    /**
        Gets the module this variant belongs to.
    */
    final
    SpirvModule getModule() {
        return mod;
    }
}

/**
    Type kind
*/
enum SpirvTypeKind : SpirvID {
    void_,
    boolean,
    uint_,
    int_,
    fp,
    vector,
    array,
    matrix,
    struct_,
    function_,
    opaque,
    image,
    sampler,
    sampledImage,
    event,
    deviceEvent,
    queue,
    reserveId,
    pipe,
    pointer,
    fwdPointer,
    unknown,
}

/**
    A SPIR-V Type
*/
class SpirvType : SpirvVariant {
@nogc:
private:
    SpirvTypeKind typeKind;

    StorageClass storageClass;
    uint components;
    uint width;

    SpirvID baseType;
    SpirvID returnType;
    vector!SpirvID members;

protected:

    override
    void onIntrospect(Op opcode) {
        this.components = 1;
        this.baseType = this.getId();
        
        switch(opcode) {
            case Op.OpTypeVoid:
                this.typeKind = SpirvTypeKind.void_;
                break;
            
            case Op.OpTypeBool:
                this.typeKind = SpirvTypeKind.boolean;
                break;

            case Op.OpTypeInt:
                this.typeKind = instr.getOperand(2) == 1 ? SpirvTypeKind.int_ : SpirvTypeKind.uint_;
                this.width = instr.getOperand(1);
                break;

            case Op.OpTypeFloat:
                this.typeKind = SpirvTypeKind.fp;
                this.width = instr.getOperand(1);
                break;

            case Op.OpTypeVector:
                this.typeKind = SpirvTypeKind.vector;
                this.baseType = instr.getOperand(1);
                this.components = instr.getOperand(2);
                break;

            case Op.OpTypeMatrix:
                this.typeKind = SpirvTypeKind.matrix;
                this.baseType = instr.getOperand(1);
                this.components = instr.getOperand(2);
                break;
                
            case Op.OpTypeImage:
                this.typeKind = SpirvTypeKind.image;
                break;

            case Op.OpTypeSampler:
                this.typeKind = SpirvTypeKind.sampler;
                break;

            case Op.OpTypeSampledImage:
                this.typeKind = SpirvTypeKind.sampledImage;
                break;

            case Op.OpTypeArray:
                this.typeKind = SpirvTypeKind.array;
                this.components = instr.getOperand(2);
                break;
                
            case Op.OpTypeRuntimeArray:
                this.typeKind = SpirvTypeKind.array;
                this.baseType = instr.getOperand(1);
                break;

            case Op.OpTypeStruct:
                this.typeKind = SpirvTypeKind.struct_;
                this.members ~= instr.getOperands()[1..$];
                break;

            case Op.OpTypeOpaque:
                this.typeKind = SpirvTypeKind.opaque;
                nstring str = fromSpirvString(this.getOperands[1..$]);
                this.setName(str);
                break;

            case Op.OpTypePointer:
                this.typeKind = SpirvTypeKind.pointer;
                this.storageClass = cast(StorageClass)instr.getOperand(1);
                this.baseType = instr.getOperand(2);
                break;

            case Op.OpTypeFunction:
                this.typeKind = SpirvTypeKind.function_;
                this.returnType = instr.getOperand(1);
                this.members ~= instr.getOperands()[2..$];
                break;

            case Op.OpTypeEvent:
                this.typeKind = SpirvTypeKind.event;
                break;
                
            case Op.OpTypeDeviceEvent:
                this.typeKind = SpirvTypeKind.deviceEvent;
                break;

            case Op.OpTypeReserveId:
                this.typeKind = SpirvTypeKind.reserveId;
                break;

            case Op.OpTypeQueue:
                this.typeKind = SpirvTypeKind.queue;
                break;

            case Op.OpTypePipe:
                this.typeKind = SpirvTypeKind.pipe;
                break;

            case Op.OpTypeForwardPointer:
                this.typeKind = SpirvTypeKind.fwdPointer;
                this.storageClass = cast(StorageClass)instr.getOperand(1);
                break;

            default:
                this.typeKind = SpirvTypeKind.unknown;
                break;
        }
        
    }

public:


    /**
        Instantiates a Spirv type
    */
    this(SpirvModule mod, SpirvInstr* instr) {
        super(mod, instr, SpirvVariantKind.type);
    }

    /**
        Gets what kind of type this is.
    */
    final
    SpirvTypeKind getTypeKind() {
        return typeKind;
    }

    /**
        Gets the bottom basic type of the type if any.
    */
    final
    SpirvType getBasicType() {
        if (baseType == this.getId())
            return this;
        
        return this.getBaseType().getBasicType();
    }

    /**
        Gets the base type of the type if any.
    */
    final
    SpirvType getBaseType() {
        if (baseType == this.getId())
            return this;
        
        return mod.findType(baseType);
    }

    /**
        Gets the first base type with a size, if any.
    */
    final
    SpirvType getBaseSizedType() {
        if (baseType == this.getId())
            return this;

        if (this.getSize() > 0)
            return this;
        
        return this.getBaseType().getBaseSizedType();
    }

    /**
        Gets the storage class of the type.
    */
    final
    StorageClass getStorageClass() {
        return storageClass;
    }

    /**
        Gets the bit width of the type.

        Returns 0 if the type doesn't have an implicit width.
    */
    final
    size_t getWidth() {
        switch(typeKind) {
            case SpirvTypeKind.boolean:
                return 8;

            case SpirvTypeKind.fp:
            case SpirvTypeKind.uint_:
            case SpirvTypeKind.int_:
                return width;

            // Pointers don't have sizes themselves.
            // But might as well return the size of their children.
            case SpirvTypeKind.pointer:
            case SpirvTypeKind.vector:
            case SpirvTypeKind.array:
            case SpirvTypeKind.matrix:
                return this.getBaseType().getWidth();
                
            default:
                return 0;
        }
    }

    /**
        Gets the size of the type in bytes
    */
    final
    size_t getSize() {
        switch(typeKind) {
            case SpirvTypeKind.boolean:
                return 1;

            case SpirvTypeKind.fp:
            case SpirvTypeKind.uint_:
            case SpirvTypeKind.int_:
                return (width/8);

            // Pointers don't have sizes themselves.
            // But might as well return the size of their children.
            case SpirvTypeKind.pointer:
                return this.getBaseType().getSize();

            case SpirvTypeKind.vector:
            case SpirvTypeKind.array:
            case SpirvTypeKind.matrix:
                return this.getBaseType().getSize() * components;
                
            case SpirvTypeKind.struct_:
                size_t size;
                foreach(member; members) {
                    size += this.getBaseType().getSize();
                }
                return size;

            default:
                return 0;
        }
    }

    /**
        Returns the amount of components in the type (if any)
    */
    final
    size_t getComponents() {
        if (this.isPointer()) {
            return this.getBaseType().getComponents();
        }
        return components;
    }

    /**
        Gets the member types of this type, if it's a struct or function.

        You are responsible for freeing the members list.
    */
    final
    SpirvType[] getMembers() {
        if (this.isPointer()) {
            return this.getBaseType().getMembers();
        }

        vector!SpirvType membersOut;
        foreach(member; members) {
            membersOut ~= mod.findType(member);
        }

        // TODO: Fix the issue causing this.
        return membersOut.take();
    }

    /**
        Gets whether the type has components
    */
    final
    bool hasComponents() {
        switch(typeKind) {
            case SpirvTypeKind.vector:
            case SpirvTypeKind.array:
            case SpirvTypeKind.matrix:
                return true;

            default:
                if (this.isPointer()) {
                    return this.getBaseType().hasComponents();
                }

                return false;
        }
    }

    /**
        Gets whether the type is a pointer.

        Pointers are handled specially to inherit
        the properties of what they point to.
    */
    final
    bool isPointer() {
        return 
            typeKind == SpirvTypeKind.pointer || 
            typeKind == SpirvTypeKind.fwdPointer;
    }

    /**
        Gets whether the type is an array
    */
    final
    bool isArray() {
        return typeKind == SpirvTypeKind.array;
    }

    /**
        Gets whether the type is a vector
    */
    final
    bool isVector() {
        return typeKind == SpirvTypeKind.vector;
    }

    /**
        Gets whether the type is a matrix
    */
    final
    bool isMatrix() {
        return typeKind == SpirvTypeKind.matrix;
    }

    /**
        Gets whether the type is a matrix
    */
    final
    bool isStruct() {
        return typeKind == SpirvTypeKind.struct_;
    }
}

/**
    The kind of a variable.
*/
enum SpirvVarKind {
    builtin,
    stageInput,
    stageOutput,
    sampler,
    image,
    sampledImage,
    storageBuffer,
    uniformBuffer,
    accelStruct,
    unknown
}

/**
    A SPIR-V Variable
*/
class SpirvVariable : SpirvVariant {
@nogc:
private:
    StorageClass storageClass;
    SpirvID baseType;

protected:

    override
    void onIntrospect(Op opcode) {
        assert(opcode == Op.OpVariable);

        this.baseType = instr.getResultType();
        this.storageClass = cast(StorageClass)instr.getOperand(2);
    }

public:


    /**
        Instantiates a Spirv Variable
    */
    this(SpirvModule mod, SpirvInstr* instr) {
        super(mod, instr, SpirvVariantKind.variable);
    }


    /**
        Gets the storage class of the variable.
    */
    final
    StorageClass getStorageClass() {
        return storageClass;
    }

    /**
        Gets the type of the variable
    */
    final
    SpirvType getType() {
        return mod.findType(baseType);
    }

    /**
        Gets the base type of the variable
    */
    final
    SpirvType getBaseType() {
        return this.getType().getBaseSizedType();
    }

    /**
        Gets whether this variable is builtin
    */
    final
    bool isBuiltIn() {
        return mod.getDecorationFor(this.getId(), Decoration.BuiltIn) !is null;
    }

    /**
        Gets what kind of BuiltIn this is.
    */
    final
    BuiltIn getBuiltIn() {
        return cast(BuiltIn)mod.getDecorationArgFor(this.getId(), Decoration.BuiltIn);
    }

    /**
        Gets what kind of variable this is.
    */
    final
    SpirvVarKind getVarKind() {
        
        // Handle builtins differently.
        if (this.isBuiltIn())
            return SpirvVarKind.builtin;
        
        switch(storageClass) {

            case StorageClass.Input:
                return SpirvVarKind.stageInput;

            case StorageClass.Output:
                return SpirvVarKind.stageOutput;

            case StorageClass.Image:
                return SpirvVarKind.image;

            case StorageClass.UniformConstant:
                SpirvType type = this.getBaseType();
                switch(type.getTypeKind()) {
                    case SpirvTypeKind.sampledImage:
                        return SpirvVarKind.sampledImage;
                    
                    case SpirvTypeKind.image:
                        return SpirvVarKind.image;
                    
                    case SpirvTypeKind.sampler:
                        return SpirvVarKind.sampler;

                    default:
                      break;  
                }
                goto default;

            case StorageClass.Uniform:
                return SpirvVarKind.uniformBuffer;

            case StorageClass.StorageBuffer:
                return SpirvVarKind.storageBuffer;

            default:
                return SpirvVarKind.unknown;
        }
    }

    /**
        Gets the type of the variable

        Returns null if the type has no initializer.
    */
    final
    SpirvVariant getInitializer() {
        auto id = instr.getOperand(3);
        if (id != SPIRV_NO_ID)
            return mod.find(id);
        return null;
    }

    /**
        Gets the size of the variable in bytes.
    */
    size_t getSize() {
        auto type = this.getBaseType();
        return type.getSize();
    }
}

/**
    A SPIR-V Decoration
*/
class SpirvDecoration : SpirvVariant {
@nogc:
private:

    // Normal decorate.
    SpirvID target;
    Decoration decoration;

    // Member decorate
    bool isMemberDecoration_;
    uint offset = 0;
    size_t argOffset = 0;

    bool canEdit;

protected:

    override
    void onIntrospect(Op opcode) {
        switch(opcode) {
            
            case Op.OpDecorate:
                this.canEdit = true;
                this.isMemberDecoration_ = false;
                this.target = instr.getOperand(0);
                this.decoration = cast(Decoration)instr.getOperand(1);
                this.argOffset = 2;
                break;

            case Op.OpMemberDecorate:
                this.canEdit = true;
                this.isMemberDecoration_ = true;
                this.target = instr.getOperand(0);
                this.offset = instr.getOperand(1);
                this.decoration = cast(Decoration)instr.getOperand(2);
                this.argOffset = 3;
                break;
            
            case Op.OpDecorateString:
                this.canEdit = false;
                this.isMemberDecoration_ = false;
                this.target = instr.getOperand(0);
                this.decoration = cast(Decoration)instr.getOperand(1);
                this.argOffset = 2;
                break;

            case Op.OpDecorateId:
                this.canEdit = false;
                this.isMemberDecoration_ = false;
                this.target = instr.getOperand(0);
                this.decoration = cast(Decoration)instr.getOperand(1);
                this.argOffset = 2;
                break;

            case Op.OpMemberDecorateString:
                this.canEdit = false;
                this.isMemberDecoration_ = true;
                this.target = instr.getOperand(0);
                this.offset = instr.getOperand(1);
                this.decoration = cast(Decoration)instr.getOperand(2);
                this.argOffset = 3;
                break;
        
            default:
                assert(0, "Invalid opcode!");
        }
    }

public:

    /**
        Instantiates a Spirv Decoration
    */
    this(SpirvModule mod, SpirvInstr* instr) {
        super(mod, instr, SpirvVariantKind.decoration);
    }

    /**
        Gets the target of a decoration
    */
    final
    SpirvID getTargetId() {
        return target;
    }


    /**
        Gets the target of a decoration
    */
    final
    SpirvVariant getTarget() {
        return mod.find(target);
    }

    /**
        Returns the member offset being decorated.

        If this decoration does not affecta struct member returns -1.
    */
    final
    ptrdiff_t getTargetOffset() {
        if (isMemberDecoration_)
            return offset;
        return -1;
    }

    /**
        Gets the decoration.
    */
    final
    Decoration getDecoration() {
        return decoration;
    }
    
    /**
        Sets the decoration.
    */
    final
    void setDecoration(Decoration decoration) {
        if (canEdit)
            instr.setOperand(argOffset-1, decoration);
    }

    /**
        Gets the arguments used fore decorating.
    */
    final
    SpirvID[] getArguments() {
        return instr.getOperands()[this.argOffset..$];
    }

    /**
        Sets an argument for the decoration.

        Resizes the argument list if need be.
    */
    final
    void setArgument(size_t offset, SpirvID value) {
        if (canEdit) {
            if (!instr.isOffsetInRange(argOffset+offset))
                this.setArgumentCount(argOffset+offset+1);
            
            instr.setOperand(argOffset+offset, value);
        }
    }

    /**
        Sets how many arguments are in the decoration.
    */
    final
    void setArgumentCount(size_t count) {
        if (canEdit) {
            instr.resize(argOffset+count);
        }
    }
}

/**
    An entrypoint.
*/
class SpirvEntryPoint : SpirvVariant {
@nogc:
private:
    ExecutionModel executionModel;
    SpirvID funcId;

protected:
    override
    void onIntrospect(Op opcode) {
        assert(opcode == Op.OpEntryPoint);

        this.executionModel = cast(ExecutionModel)instr.getOperand(0);
        this.funcId = instr.getOperand(1);
        this.setName(instr.getOperandString(2));
    }
public:

    /**
        Instantiates a Spirv Decoration
    */
    this(SpirvModule mod, SpirvInstr* instr) {
        super(mod, instr, SpirvVariantKind.entryPoint);
    }

    /**
        Gets the execution model of the entrypoint.
    */
    final
    ExecutionModel getExecutionModel() {
        return executionModel;
    }

    /**
        Gets the function id of the entrypoint.
    */
    final
    SpirvID getFunctionId() {
        return funcId;
    }
}