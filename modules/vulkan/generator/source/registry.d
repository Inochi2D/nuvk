module registry;

import std.algorithm;
import std.range;
import std.typecons;

import util.omap;


/** 
 * Stores information from vk.xml in a structured format.
 */
class VkRegistry {
    string name;

    /** Registered platforms. */
    VkPlatform[] platforms;

    /** Registered vendors. */
    OMap!(string, VkVendor) vendors;

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

    /** Registered function pointers. */
    OMap!(string, VkFuncPtrType) funcptrs;

    /** Registered structs. */
    OMap!(string, VkStructType) structs;

    /** Registered unions. */
    OMap!(string, VkUnionType) unions;

    /** Registered commands. */
    OMap!(string, VkCommand) commands;

    /** Registered features */
    VkFeature[] features;

    /** Registered extensions */
    OMap!(int, VkExtension) extensions;

    /** Map globals to their enums. */
    string[string] globals;

    /** Map types to their categories. */
    VkType[string] types;

    /** Special enum which isn't really an enum. */
    @property ref const(VkEnumType) constants() => enums["API Constants"];
}

/** 
 * Information about a platform which supports Vulkan.
 */
struct VkPlatform {
    string name;
    string comment;
    string protect;
}

/** 
 * Information about a Vulkan driver author/vendor.
 */
struct VkVendor {
    string ext;
    string author;
    string contact;
}

/** 
 * Information shared between all Vulkan types.
 */
struct VkType {
    string name;
    VkTypeCategory category;
}

/** 
 * Information about a "define" (just a C macro, really).
 */
struct VkDefineType {
    VkType base;
    string value;
    string[] api;

    alias base this;

    @property bool funclike() => value.empty;
    @property bool commented() => value.startsWith("//");
}

/** 
 * Information about a base type. Usually just special platform-specific types.
 */
struct VkBasetypeType {
    VkType base;
    string type;

    alias base this;
}

/** 
 * Information about a bitmask type. Bitmasks store flags from FlagBits enums.
 */
struct VkBitmaskType {
    VkType base;
    string requires;
    string backing;

    alias base this;
}

/** 
 * Information about a handle type. Handles are opaque pointers to Vulkan resources.
 */
struct VkHandleType {
    VkType base;
    string alias_;

    alias base this;
}

/** 
 * Information about an enum type.
 */
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

/** 
 * Information about a particular enum type member.
 */
struct VkEnumMember {
    string name;
    string type;
    string value;
    string alias_;
    string comment;

    string shortName(string prefix) => shortName(prefix, name);

    string shortAlias(string prefix) => shortName(prefix, alias_);

    string shortName(string prefix, string name) {
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

/** 
 * Information about a struct type.
 */
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

/** 
 * Information about a particular struct type member.
 */
struct VkStructMember {
    string name;
    string type;
    string[] values;
    bool optional = false;

    string comment;

    /** 
     * Dodge collisions with D keywords.
     * 
     * Returns: our name suffixed with an underscore, if it's a keyword.
     */
    @property string safename() const {
        switch (name) {
            case "module":
            case "version":
                return name ~ "_";
            default:
                return name;
        }
    }
}

/** 
 * Information about a union type.
 */
struct VkUnionType {
    VkType base;
    VkUnionMember[] members;

    alias base this;
}

/** 
 * Information about a particular union type member.
 */
struct VkUnionMember {
    string name;
    string type;
    string comment;

    /** 
     * Dodge collisions with D keywords.
     * 
     * Returns: our name suffixed with an underscore, if it's a keyword.
     */
    @property string safename() const {
        switch (name) {
            case "module":
            case "version":
                return name ~ "_";
            default:
                return name;
        }
    }
}

/** 
 * Information about a function pointer type. Also basically just C code.
 */
struct VkFuncPtrType {
    VkType base;
    string type;
    VkParam[] params;

    alias base this;
}

/** 
 * Information about a Vulkan command.
 */
struct VkCommand {
    string name;
    string alias_;
    string type;
    VkParam[] params;
    string[] successes;
    string[] errors;
    string comment;

    this(return scope typeof(this) other) {
        foreach (i, ref field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }
}

/** 
 * Information about a particular Vulkan command parameter.
 */
struct VkParam {
    string name;
    string type;
    bool optional;
    string comment;
}

/** 
 * Information about a Vulkan feature. Usually just standard versions.
 */
struct VkFeature {
    string name;
    string[] api;
    string depends;
    VkSection[] sections;

    bool opBinaryRight(string op : "in")(string name) const {
        return api.any!(api => api == name);
    }
}

/** 
 * Information about a Vulkan extension.
 */
struct VkExtension {
    string name;
    int number;
    string author;
    VkExtensionType type;
    string[] supported;
    string promoted;

    VkSection[] sections;
}

/** 
 * Information about a particular section of either a feature or an extension.
 */
struct VkSection {
    string name;
    string depends;

    string[] types;
    VkEnumMember[] mconsts;
    string[] commands;

    @property bool empty() => types.empty && mconsts.empty && commands.empty;
}

/** 
 * All possible Vulkan types.
 */
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

/** 
 * Whether a given extension is an instance extension or a device extension.
 */
enum VkExtensionType {
    Instance,
    Device,
}

/** 
 * Used by bitmasks to track their backing type.
 */
enum VkBitWidth {
    U32,
    U64,
}

VkTypeCategory toVkTypeCategory(Char)(in Char[] value) {
    import std.format : format;

    final switch (value) {
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
    }
}

VkExtensionType toVkExtensionType(Char)(in Char[] value) {
    import std.format : format;

    final switch (value) {
        case "instance":
            return VkExtensionType.Instance;
        case "device":
            return VkExtensionType.Device;
    }
}