module registry;

import std.algorithm;
import std.range;
import std.sumtype;
import std.string;
import std.typecons;

import util.omap;


/** 
 * Stores information from vk.xml in a structured format.
 */
class VkRegistry {
    /** Registered platforms. */
    OMap!(string, VkPlatform) platforms;

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
    OMap!(string, VkFeature) features;

    /** Registered extensions */
    OMap!(string, VkExtension) extensions;

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

    @property bool funclike() const => value.empty;
    @property bool commented() const => value.startsWith("//");
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
    string alias_;

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
    string alias_;
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

    @property string backingType() const {
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
    string deprecated_;
    string comment;

    string shortName(string prefix) const => shortName(prefix, name);

    string shortAlias(string prefix) const => shortName(prefix, alias_);

    string shortName(string prefix, string name) const {
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

    @property bool hasAlias() const => !alias_.empty;

    @property bool isDeprecated() const => !deprecated_.empty;
}

/** 
 * Information about a struct type.
 */
struct VkStructType {
    VkType base;
    string alias_;
    string extends;
    VkStructMember[] members;

    alias base this;

    @property bool hasBitfields() const {
        foreach (ref member; members) {
            if (member.width > 0) {
                return true;
            }
        }

        return false;
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
    string deprecated_;
    uint width;

    string comment;

    /** 
     * Dodge collisions with D keywords.
     * 
     * Returns: our name suffixed with an underscore, if it's a keyword.
     */
    @property string safename() const {
        if (name in keywords) {
            return name ~ "_";
        } else {
            return name;
        }
    }

    @property bool isDeprecated() const => !deprecated_.empty;
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
        if (name in keywords) {
            return name ~ "_";
        } else {
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

    @property VkFuncPtrType funcptr() const {
        VkFuncPtrType result;

        result.name = "PFN_" ~ name;
        result.type = type;
        result.params = params.dup;

        return result;
    }

    @property bool isAlias() const => !alias_.empty;
}

/** 
 * Information about a particular Vulkan command parameter.
 */
struct VkParam {
    string name;
    string type;
    bool optional;
    string comment;

    /** 
     * Dodge collisions with D keywords.
     * 
     * Returns: our name suffixed with an underscore, if it's a keyword.
     */
    @property string safename() const {
        if (name in keywords) {
            return name ~ "_";
        } else {
            return name;
        }
    }
}

/** 
 * Information about a Vulkan feature. Usually just standard versions.
 */
struct VkFeature {
    string name;
    string[] api;
    string depends;
    int major;
    int minor;
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
    string deprecated_;
    VkDepends depends = null;
    VkSection[] sections;
    string platform;

    @property string shortName() const {
        import std.ascii;

        if (name.startsWith("VK_")) {
            auto result = name["VK_".length .. $];

            auto index = result.indexOf("_");
            assert(index != -1, result);
            result = result[index + 1 .. $];

            // Some extension short names start with numbers.
            if (result[0].isDigit) {
                result = "_" ~ result;
            }

            return result;
        } else if (name.startsWith("vulkan_video_codec_")) {
            const offset = "vulkan_video_codec_".length;
            return name[offset .. $];
        } else {
            return "common";
        }
    }

    @property string prefix() const {
        if (name.startsWith("VK_")) {
            auto result = name["VK_".length .. $];
            auto index = result.indexOf("_");
            assert(index != -1, result);
            return result[0 .. index].toLower;
        } else if (name.startsWith("vulkan_video_codec")) {
            return "video";
        } else {
            assert(false, name);
        }
    }

    @property bool disabled() const => supported == ["disabled"];

    @property bool supportedByVulkan() const {
        return supported.empty || supported.canFind("vulkan");
    }

    @property bool usable() const => !disabled && supportedByVulkan;

    @property bool isVulkan() const => name.startsWith("VK_");

    @property bool isVideo() const => name.startsWith("vulkan_video_codec");
}

/** 
 * Information about a particular section of either a feature or an extension.
 */
struct VkSection {
    string name;
    VkDepends depends = null;

    string[] types;
    VkEnumMember[] mconsts;
    string[] commands;

    @property bool empty() const => types.empty && mconsts.empty && commands.empty;
}

/** 
 * Generalizes a depends expression into an AST.
 */
struct VkDepends {
    SumType!(typeof(null), string, VkDependsOp) inner;

    alias inner this;

    @disable this();

    this(ref return scope inout(VkDepends) other) inout {
        inner = other.inner;
    }

    this(return scope VkDepends other) inout {
        inner = __rvalue(other.inner);
    }

    this(typeof(null)) {
        inner = null;
    }

    this(string name) {
        inner = name;
    }

    this(char operator, ref VkDepends lhs, ref VkDepends rhs) {
        inner = VkDependsOp(operator, new VkDepends(lhs), new VkDepends(rhs));
    }

    bool opCast(T : bool)() const {
        return !inner.has!(const typeof(null));
    }

    bool opBinary(string op : "==")(string str) const {
        return inner.match!(
            (string name) => name == str,
            _ => false,
        );
    }

    string toString() const {
        return inner.match!(
            (typeof(null)) => null.stringof,
            (string name) => name,
            (const ref VkDependsOp op) {
                auto lhs = op.lhs.toString();
                auto rhs = op.rhs.toString();
                return format!"(%s%s%s)"(lhs, op.operator, rhs);
            },
        );
    }

    @property bool isFeature() const => inner.match!(
        (string name) => name.startsWith("VK_VERSION_"),
        _ => false,
    );

    @property inout(string) name() inout => inner.get!(inout string);

    @property inout(VkDependsOp) op() inout => inner.get!(inout VkDependsOp);

    @property bool isName() inout => inner.has!(inout string);

    @property bool isOp() inout => inner.has!(inout VkDependsOp);
}

@"constructing VkDepends from null works"
unittest {
    VkDepends result = null;

    assert(!result);
}

@"constructing VkDepends from a string works"
unittest {
    VkDepends result = "hello";

    assert(result);
    assert(result.isName);
    assert(result.name == "hello");
}

struct VkDependsOp {
    char operator;
    VkDepends* lhs;
    VkDepends* rhs;
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

const bool[string] keywords = [
    "module": true,
    "version": true,
    "scope": true,
    "function": true,
];