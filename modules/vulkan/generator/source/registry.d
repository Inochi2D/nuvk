module registry;

import std.algorithm;
import std.range;
import std.typecons;

import omap;


class VkRegistry {
    string name;

    /** Registered platforms. */
    VkPlatform[] platforms;

    /** Registered vendors. */
    OMap!(string, VkVendor) vendors;

    /** Registered constants. */
    string[string] constants;

    /** Registered types. */
    VkType[string] types;

    /** Registered defines */
    OMap!(string, VkDefineType) defines;

    /** Registered base types */
    OMap!(string, VkBasetypeType) basetypes;

    /** Registered bitmasks */
    OMap!(string, VkBitmaskType) bitmasks;

    /** Registered handles. */
    OMap!(string, VkHandleType) handles;

    /** Registered enums. */
    OMap!(string, VkEnumType) enums;

    /** Registered structs. */
    OMap!(string, VkStructType) structs;

    /** Registered unions. */
    OMap!(string, VkUnionType) unions;

    /** Registered function pointers. */
    OMap!(string, VkFuncPtrType) funcptrs;

    /** Registered commands. */
    OMap!(string, VkCommand) commands;

    /** Registered features */
    VkFeature[] features;

    /** Registered extensions */
    OMap!(int, VkExtension) extensions;
}

struct VkPlatform {
    string name;
    string comment;
    string protect;
}

struct VkVendor {
    string ext;
    string author;
    string contact;
}

struct VkType {
    string name;
    VkTypeCategory category;
}

struct VkDefineType {
    VkType base;
    string value;
    string[] api;

    alias base this;

    @property bool funclike() => value.empty;
    @property bool commented() => value.startsWith("//");
}

struct VkBasetypeType {
    VkType base;
    string type;

    alias base this;
}

struct VkBitmaskType {
    VkType base;
    string requires;
    string backing;

    alias base this;
}

struct VkHandleType {
    VkType base;
    string alias_;

    alias base this;
}

struct VkEnumType {
    VkType base;
    string comment;
    bool bitmask;
    VkBitWidth width = VkBitWidth.U32;
    OMap!(string, VkEnumMember) members;

    alias base this;

    this(return scope typeof(this) other) {
        foreach (i, ref field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }

    @property string backingType() {
        final switch (width) {
            case VkBitWidth.U32:
                return "uint";
            case VkBitWidth.U64:
                return "ulong";
        }
    }
}

struct VkEnumMember {
    string name;
    string type;
    string value;
    string comment;

    string shortName(string prefix) {
        import std.ascii : isDigit;

        enum suffix = "FLAG_BITS_";

        if (prefix.endsWith(suffix)) {
            prefix = prefix[0 .. $ - suffix.length];
        }

        if (name.startsWith(prefix) && !name[prefix.length].isDigit) {
            return name[prefix.length .. $];
        } else {
            return name;
        }
    }
}

struct VkStructType {
    VkType base;
    string extends;
    VkStructMember[] members;

    alias base this;

    this(return scope typeof(this) other) {
        foreach (i, ref field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }
}

struct VkStructMember {
    string name;
    string type;
    string[] values;
    bool optional = false;

    string comment;
}

struct VkUnionType {
    VkType base;
    VkUnionMember[] members;

    alias base this;
}

struct VkUnionMember {
    string name;
    string type;
}

struct VkFuncPtrType {
    VkType base;
    string value;

    alias base this;
}

struct VkCommand {
    string name;
    string alias_;
    string type;
    VkCommandParam[] params;
    string[] successes;
    string[] errors;
    string comment;

    this(return scope typeof(this) other) {
        foreach (i, ref field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }
}

struct VkCommandParam {
    string name;
    string type;
    bool optional;
    string comment;
}

struct VkFeature {
    string name;
    string[] api;
    VkSection[] sections;

    bool opBinaryRight(string op : "in")(string name) const {
        return api.any!(api => api == name);
    }
}

struct VkExtension {
    string name;
    int number;
    string author;
    VkExtensionType type;
    string[] supported;
    string promoted;

    VkSection[] sections;
}

struct VkSection {
    string name;
    string depends;

    string[] types;
    string[] enums;
    string[] commands;

    @property bool empty() => types.empty && enums.empty && commands.empty;
}

enum VkTypeCategory {
    None = 0,

    Include,
    Define,
    Basetype,
    Bitmask,

    Handle,
    Enum,
    FuncPtr,
    Struct,
    Union,
}

enum VkExtensionType {
    Instance,
    Device,
}

enum VkBitWidth {
    U32,
    U64,
}

VkTypeCategory toVkTypeCategory(Char)(in Char[] value) {
    import std.format : format;

    switch (value) {
        case "include":
            return VkTypeCategory.Include;
        case "define":
            return VkTypeCategory.Define;
        case "basetype":
            return VkTypeCategory.Basetype;
        case "bitmask":
            return VkTypeCategory.Bitmask;
        case "handle":
            return VkTypeCategory.Handle;
        case "enum":
            return VkTypeCategory.Enum;
        case "funcpointer":
            return VkTypeCategory.FuncPtr;
        case "struct":
            return VkTypeCategory.Struct;
        case "union":
            return VkTypeCategory.Union;
        case "":
            return VkTypeCategory.None;
        default:
            throw new Exception(format!"unknown category %s"(value));
    }
}

VkExtensionType toVkExtensionType(Char)(in Char[] value) {
    import std.format : format;

    switch (value) {
        case "instance":
            return VkExtensionType.Instance;
        case "device":
            return VkExtensionType.Device;
        default:
            throw new Exception(format!"unknown extension type %s"(value));
    }
}