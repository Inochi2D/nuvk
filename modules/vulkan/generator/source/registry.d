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

    /** Registered handles. */
    OMap!(string, VkHandleType) handles;

    /** Registered structs. */
    OMap!(string, VkStructType) structs;

    /** Registered enums. */
    OMap!(string, VkEnumType) enums;

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
    bool critical;

    alias base this;

    @property bool funclike() => value.empty;
    @property bool commented() => value.startsWith("//");
}

struct VkBasetypeType {
    VkType base;
    string type;

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
    OMap!(string, VkEnumMember) members;

    alias base this;

    this(return scope typeof(this) other) {
        foreach (i, ref field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }
}

struct VkEnumMember {
    string name;
    string type;
    string value;
    string comment;
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
    string type;
    string name;
    string values;
    string comment;
    bool optional;
}

struct VkCommand {
    string name;
    string alias_;
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
    string[] supported;
    VkSection[] sections;
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