/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.defs;
import nuvk.compiler.spirv.mod;
import numem.all;

public import nuvk.compiler.spirv.types.func;
public import nuvk.compiler.spirv.types.instr;
public import nuvk.compiler.spirv.types.compound;


/**
    A spirv type
*/
abstract
class SpirvType {
@nogc:
private:
    weak_vector!SpirvDecoration decorations;
    SpirvTypeKind id;
    nstring name;
    bool managed;

protected:

    /**
        Returns whether this type may be decorated with the provided value
    */
    bool canDecorateWith(SpirvDecoration decoration) {
        return false;
    }

    /**
        Constructs a Spirv type
    */
    this(SpirvTypeKind id, nstring name, bool managed) {
        this.id = id;
        this.name = name;
        this.managed = managed;
    }

    /**
        Constructs a Spirv type
    */
    this(SpirvTypeKind id) {
        super(id, nstring(0), false);
    }

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(decorations);
        nogc_delete(name);
    }

    /**
        Add a decoration to the type
    */
    final
    void addDecoration(SpirvDecoration decoration) {
        nuvkEnforce(canDecorateWith(decoration), "Decoration could not be applied to this type!");
        decorations ~= decoration;
    }

    /**
        Gets the decorations applied to the type
    */
    final
    SpirvDecoration[] getDecorations() {
        return decorations[];
    }

    /**
        Gets the type's ID
    */
    final
    SpirvTypeKind getTypeId() {
        return id;
    }

    /**
        Gets the name of the type (for debugging)
    */
    final
    nstring getName() {
        return this.name;
    }

    /**
        Gets whether the type is managed by the compiler.

        If the type is managed by the compiler it should not be freed
        by the end user.
    */
    final
    bool isManaged() {
        return managed;
    }

    /**
        Gets the size of the type in bytes
    */
    final
    uint getByteSize() {
        return getSize() == 0 ? 0 : getSize()/8;
    }

    /**
        Gets the size of the type
    */
    uint getSize() {
        return 0;
    }
}

private {
    __gshared SpirvBaseType voidType;

    __gshared SpirvBaseType bool_;

    __gshared SpirvBaseType i32;
    __gshared SpirvBaseType i64;

    __gshared SpirvBaseType u32;
    __gshared SpirvBaseType u64;

    __gshared SpirvBaseType f16;
    __gshared SpirvBaseType f32;
    __gshared SpirvBaseType f64;

    __gshared map!(SpirvTCType, SpirvVectorType) vectorTypes;
    __gshared map!(SpirvTCType, SpirvMatrixType) matrixTypes;

    struct SpirvTCType {
        SpirvType baseType;
        uint components;
    }
}

/**
    Gets the void type
*/
SpirvBaseType nuvkSpirvGetVoid() {
    return void_;
}

/**
    Gets the boolean type
*/
SpirvBaseType nuvkSpirvGetBool() {
    return bool_;
}

/**
    Gets the int type
*/
SpirvBaseType nuvkSpirvGetInt32() {
    return i32;
}

/**
    Gets the long type
*/
SpirvBaseType nuvkSpirvGetInt64() {
    return i64;
}

/**
    Gets the uint type
*/
SpirvBaseType nuvkSpirvGetUInt32() {
    return u32;
}

/**
    Gets the ulong type
*/
SpirvBaseType nuvkSpirvGetUInt64() {
    return u64;
}

/**
    Gets the half-precision float type
*/
SpirvBaseType nuvkSpirvGetFloat16() {
    return f16;
}

/**
    Gets the single-precision float type
*/
SpirvBaseType nuvkSpirvGetFloat32() {
    return f32;
}

/**
    Gets the double-precision float type
*/
SpirvBaseType nuvkSpirvGetFloat64() {
    return f64;
}

/**
    Class for base types
*/
final
class SpirvBaseType : SpirvType {
@nogc:
private:
    uint size;
    bool signed;

    /**
        Constructs a base type
    */
    this(SpirvTypeKind type, uint size, bool signed, string name) {
        super(type, nstring(name), true);
        this.size = size;
        this.signed = signed;
    }

public:

    /**
        Gets the size of the type
    */
    override
    uint getSize() {
        return size;
    }

    /**
        Gets whether the type is signed
    */
    bool getSigned() {
        return signed;
    }
}

/**
    Gets the a vector type from the specified base type
*/
SpirvVectorType nuvkSpirvGetVector(SpirvBaseType baseType, uint components) {
    nuvkEnforce(components >= 2 && components <= 4);
    nuvkEnforce(
        baseType.getTypeId() == SpirvTypeKind.typeFloat || 
        baseType.getTypeId() == SpirvTypeKind.typeInt   || 
        baseType.getTypeId() == SpirvTypeKind.typeBool,
        nstring("Can't make vectors out of non-numeric types!")
    );

    SpirvTCType tct;
    tct.baseType = baseType;
    tct.components = components;
    if (tct !in vectorTypes) {
        vectorTypes[tct] = nogc_new!SpirvVectorType(baseType, components);
    }
    return vectorTypes[tct];
}

/**
    Class for vector types
*/
final
class SpirvVectorType : SpirvType {
@nogc:
private:
    uint componentCount;
    SpirvBaseType baseType;

    /**
        Constructs a base type
    */
    this(SpirvBaseType type, uint componentCount) {
        super(type, nstring(name), true);
        this.componentCount = componentCount;
    }

public:

    /// Can only contain managed types
    ~this() { }

    /**
        Gets the amount of components in the vector
    */
    uint getComponentCount() {
        return componentCount;
    }

    /**
        Gets the base type of the vector
    */
    SpirvBaseType getBaseType() {
        return baseType;
    }

    /**
        Gets the size of the type
    */
    override
    uint getSize() {
        return baseType.getSize()*componentCount;
    }
}

/**
    Gets the a matrix type from the specified base type
*/
SpirvVectorType nuvkSpirvGetMatrix(SpirvVectorType baseType, uint columns) {
    nuvkEnforce(columns >= 2 && columns <= 4);

    SpirvTCType tct;
    tct.baseType = baseType;
    tct.components = columns;
    if (tct !in matrixTypes) {
        matrixTypes[tct] = nogc_new!SpirvMatrixType(baseType, columns);
    }

    return matrixTypes[tct];
}

/**
    Class for matrix types.
    
*/
final
class SpirvMatrixType : SpirvType {
@nogc:
private:
    uint columnCount;
    SpirvVectorType baseType;

    /**
        Constructs a base type
    */
    this(SpirvVectorType type, uint columnCount) {
        super(type, nstring(name), true);
        this.columnCount;
    }

protected:

    /**
        Returns whether this type may be decorated with the provided value
    */
    override
    bool canDecorateWith(SpirvDecoration decoration) {
        switch(decoration) {
            case SpirvDecoration.rowMajor:
            case SpirvDecoration.colMajor:
            case SpirvDecoration.matrixStride:
                return true;

            default:
                return false;
        }
    }

public:

    /// Can only contain managed types
    ~this() { }

    /**
        Gets the amount of columns in the matrix
    */
    uint getColumnCount() {
        return columnCount;
    }

    /**
        Gets the base type of the matrix
    */
    SpirvVectorType getBaseType() {
        return baseType;
    }

    /**
        Gets the size of the type
    */
    override
    uint getSize() {
        return baseType.getSize()*columnCount;
    }
}


package(nuvk) {
    void nuvkSpirvInitCompilerTypes() @nogc {

        void_ = nogc_new!SpirvBaseType(SpirvTypeKind.typeVoid, 0, false, "void");

        bool_ = nogc_new!SpirvBaseType(SpirvTypeKind.typeBool, 8, false, "bool");

        i32 = nogc_new!SpirvBaseType(SpirvTypeKind.typeInt, 32, true, "i32");
        i64 = nogc_new!SpirvBaseType(SpirvTypeKind.typeInt, 64, true, "i64");

        u32 = nogc_new!SpirvBaseType(SpirvTypeKind.typeInt, 32, false, "u32");
        u64 = nogc_new!SpirvBaseType(SpirvTypeKind.typeInt, 64, false, "u64");

        f16 = nogc_new!SpirvBaseType(SpirvTypeKind.typeFloat, 16, false, "f16");
        f32 = nogc_new!SpirvBaseType(SpirvTypeKind.typeFloat, 32, false, "f32");
        f64 = nogc_new!SpirvBaseType(SpirvTypeKind.typeFloat, 64, false, "f64");
    }

    void nuvkSpirvCleanupCompilerTypes() @nogc {
        nogc_delete(void_);

        nogc_delete(bool_);

        nogc_delete(i32);
        nogc_delete(i64);

        nogc_delete(u32);
        nogc_delete(u64);

        nogc_delete(f16);
        nogc_delete(f32);
        nogc_delete(f64);
        
        nogc_delete(vectorTypes);
        nogc_delete(matrixTypes);
    }
}