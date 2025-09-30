module registry;

import std.algorithm;
import std.array;
import std.format : format;
import std.exception : enforce;
import std.path;
import std.range;

import yxml;

import logger;


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
    string category;
    string name;
}

struct VkEnumType {
    VkType vktype;
    string comment;
    bool bitmask;
    VkEnumMember[] members;

    alias vktype this;

    // override string toString() const {
    //     debug {
    //         string out_ = "    %s:\n".format(name);
    //         foreach(member; members) {
    //             out_ ~= "      %s = %s (%s)\n".format(member.name, member.value, member.comment);
    //         }
    //         return out_;
    //     } else {
    //         return super.toString();
    //     }
    // }
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

    // override string toString() const {
    //     debug {
    //         string out_ = "    %s:\n".format(name);
    //         foreach(member; members) {
    //             if (member.values) {
    //                 out_ ~= "      %s %s = %s\n".format(member.type, member.name, member.values);
    //             } else {
    //                 out_ ~= "      %s %s\n".format(member.type, member.name);
    //             }
    //         }
    //         return out_;
    //     } else {
    //         return super.toString();
    //     }
    // }
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

struct VkHandleType {
    VkType vktype;
    
    alias vktype this;
}