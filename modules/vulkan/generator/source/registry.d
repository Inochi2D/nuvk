module registry;

import std.typecons;


class VkRegistry {
    string name;

    /** Registered platforms. */
    VkPlatform[] platforms;

    /** Registered vendors. */
    VkVendor[] vendors;

    /** Registered structs. */
    VkStructType[] structs;

    /** Registered enums. */
    VkEnumType[] enums;

    /** Registered commands. */
    VkCommand[] commands;

	/** Registered features */
	VkFeature[] features;

	/** Registered extensions */
	VkExtension[] extensions;
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

struct VkEnumType {
    VkType vktype;
    string comment;
    bool bitmask;
    VkEnumMember[] members;

    alias vktype this;
}

struct VkEnumMember {
    string name;
    string value;
    string comment;
}

struct VkStructType {
    VkType vktype;
    string extends;
    VkStructMember[] members;

    alias vktype this;
}

struct VkStructMember {
    string type;
    string name;
    string values;
    string comment;
    bool optional;
}

struct VkCommand {
    VkType vktype;
    string alias_;
    VkCommandParam[] params;
    string[] successes;
    string[] errors;
    string comment;

    alias vktype this;
}

struct VkCommandParam {
    string name;
    string type;
    bool optional;
    string comment;
}

struct VkFeature {
	string name;
}

struct VkExtension {
	string name;
}

struct VkHandleType {
    VkType vktype;
    
    alias vktype this;
}

enum VkTypeCategory {
	None = 0,

	Enum,
	Struct,
	Union,
	Include,
	Define,
	Handle,
	Bitmask,
	Basetype,
	FuncPtr,
}

VkTypeCategory toVkTypeCategory(Char)(in Char[] value) {
	import std.format : format;

	switch (value) {
		case "enum":
			return VkTypeCategory.Enum;
		case "struct":
			return VkTypeCategory.Struct;
		case "union":
			return VkTypeCategory.Union;
		case "include":
			return VkTypeCategory.Include;
		case "define":
			return VkTypeCategory.Define;
		case "handle":
			return VkTypeCategory.Handle;
		case "bitmask":
			return VkTypeCategory.Bitmask;
		case "basetype":
			return VkTypeCategory.Basetype;
		case "funcpointer":
			return VkTypeCategory.FuncPtr;
		case "":
			return VkTypeCategory.None;
		default:
			throw new Exception(format!"unknown category %s"(value));
	}
}
