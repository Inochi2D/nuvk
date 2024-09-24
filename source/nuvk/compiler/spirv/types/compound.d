module nuvk.compiler.spirv.types.compound;
import nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.defs;
import numem.all;



final
class SpirvPointerType : SpirvType {
@nogc:
private:
    SpirvType to;

public:
    /**
        Destructor

        NOTE: Pointer types do NOT free their target type!
    */
    ~this() { }

    /**
        Constructor
    */
    this(SpirvType to) {
        this.to = to;
    }

    /**
        Gets the type of the target
    */
    SpirvType getTargetType() {
        return to;
    }
}

final
class SpirvStructType : SpirvType {
@nogc:
private:
    struct SpirvStructMember {
    @nogc:
        nstring name;
        SpirvType type;
        weak_vector!SpirvDecoration decorations;

        ~this() {
            nogc_delete(decorations);

            // Delete sub-type if it's not a managed type.
            if (!type.isManaged()) {
                nogc_delete(type);
            }
        }
    }

    // Members of the struct
    weak_vector!SpirvStructMember members;

    // Gets position of member
    ptrdiff_t getMemberIndex(nstring name) {
        foreach(i, member; members) {
            if (member.name == name) return i;
        }
        return -1;
    }

protected:

    /**
        Returns whether this type may be decorated with the provided value
    */
    override
    bool canDecorateWith(SpirvDecoration decoration) {
        switch(decoration) {
            case SpirvDecoration.block:
            case SpirvDecoration.glslShared:
            case SpirvDecoration.glslPacked:
            case SpirvDecoration.cPacked:
                return true;

            default:
                return false;
        }
    }

public:

    /**
        Constructs a base type
    */
    this() {
        super(type);
    }

    /**
        Adds a member to the struct
    */
    void addMember(SpirvType type, nstring name) {
        ptrdiff_t idx = getMemberIndex(name);
        if (idx >= 0) {
            SpirvStructMember member;
            member.type = type;
            member.name = name;
            members ~= member;
        }
    }

    /**
        Gets the type of a member
    
        Returns null if member wasn't found
    */
    SpirvType getMemberType(nstring name) {
        ptrdiff_t idx = getMemberIndex(name);
        if (idx >= 0) {
            return members[idx].type;
        }
        return null;
    }

    /**
        Gets the decorations of a member
    */
    SpirvDecoration[] getMemberDecorations(nstring name) {
        if (name in members) {
            return members[name].decorations[];
        }

        return null;
    }

    /**
        Gets the decorations of a member
    */
    uint getMemberOffset(nstring name) {
        ptrdiff_t idx = getMemberIndex(name);
        if (idx >= 1) {

            // Count size of members reaching up this this member.
            uint size = 0;
            foreach(i; 0..idx) {
                size += members[name].getSize();   
            }

            return size;
        }
        return 0;
    }

    /**
        Adds a decoration to a member of the struct
    */
    void addDecorationToMember(nstring name, SpirvDecoration decor) {
        if (name in members) {
            members[name].decorations ~= decor;
        }
    }

    /**
        Gets the size of the type
    */
    override
    uint getSize() {
        uint size;
        foreach(member; members.byValue()) {
            size += member.getSize();
        }

        return size;
    }
}