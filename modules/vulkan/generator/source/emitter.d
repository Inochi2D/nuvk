module emitter;

import std.algorithm;
import std.array;
import std.stdio;
import std.string;
import std.traits;

import logger;
import registry;
import util : camelToScreaming;


/** 
 * Emits generated D files from a registry.
 */
class VkRegistryEmitter {
    private VkRegistry registry;

    private Emitter file;

    private Logger logger;


    /** 
     * Construct an emitter from a registry and a file handle.
     * 
     * Params:
     *   registry = Source of the generated file.
     *   file = File handle where the generated file will be emitted.
     */
    this(VkRegistry registry, File file, Logger logger) {
        this.registry = registry;
        this.file = Emitter(file);
        this.logger = logger;
    }

    /** 
     * Emit our registry to our file.
     */
    void emit(string preamble) {
        // Write preamble comment.
        file.comment();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Module name, imports, attributes.
        file.writeln("module vulkan.core;\n");
        file.writeln("import vulkan.defines;");
        file.writeln("import vulkan.loader;");
        file.writeln("import numem.core.types : OpaqueHandle;\n");
        file.writeln("extern (System) @nogc nothrow:");

        // Emit every section of every feature.
        foreach (ref feature; registry.features.filter!(f => "vulkan" in f)) {
            file.writefln!"\n// %s"(feature.name);
            foreach (ref section; feature.sections) {
                emitSection(section);
            }
        }
    }

    private void emitSection(ref VkSection section) {
        // Section marker.
        if (!section.name.empty) {
            file.writefln!"\n// %s"(section.name);
        }

        VkTypeCategory prevcategory = VkTypeCategory.None;

        foreach (name; section.enums) {
            if (auto const_ = name in registry.constants) {
                auto ref enum_ = registry.enums[*const_];
                auto member = enum_.members[name];

                if (member.type.empty) {
                    emitMConst(member.name, member.value);
                } else {
                    emitMConst(member.type, member.name, member.value);
                }
            } else {
                logger.err("%s not found", name);
            }

            prevcategory = VkTypeCategory.Define;
        }

        foreach (type; section.types.map!(t => registry.types[t]).array) {
            if (prevcategory != type.category || isMultiline(prevcategory) || isMultiline(type.category)) {
                file.writeln();
            }

            switch (type.category) {
                case VkTypeCategory.Define:
                    emitDefine(registry.defines[type.name]);
                    break;

                case VkTypeCategory.Basetype:
                    emitBasetype(registry.basetypes[type.name]);
                    break;

                case VkTypeCategory.Bitmask:
                    emitBitmask(registry.bitmasks[type.name]);
                    break;

                case VkTypeCategory.Handle:
                    emitHandle(registry.handles[type.name]);
                    break;

                case VkTypeCategory.Enum:
                    emitEnum(registry.enums[type.name]);
                    break;

                case VkTypeCategory.FuncPtr:
                    emitFuncPtr(registry.funcptrs[type.name]);
                    break;

                case VkTypeCategory.Struct:
                    emitStruct(registry.structs[type.name]);
                    break;

                case VkTypeCategory.Union:
                    emitUnion(registry.unions[type.name]);
                    break;

                default:
                    logger.dbg(1, "emitting %s type %s", type.category, type.name);
                    file.writefln!"// -=[%s]=-"(type.name);
                    break;
            }

            prevcategory = type.category;
        }

        foreach (command; section.commands.map!(c => registry.commands[c])) {
            if (command.params.empty) {
                file.writeln();
                file.writefln!"extern %s %s();"(command.type, command.name);
            } else {
                file.writeln();
                file.writefln!"extern %s %s("(command.type, command.name);
                file.indent();
                foreach (param; command.params) {
                    file.writefln!"%s %s,"(param.type, param.name);
                }
                file.dedent();
                file.writeln(");");
            }
        }
    }

    private void emitDefine(ref VkDefineType define) {
        if (isBespoke(define.name)) {
            logger.dbg(1, "skipping define with bespoke impl. <lblue>%s</lblue>", define.name);
        } else if (define.commented) {
            logger.dbg(1, "ignoring commented out define <lblue>%s</lblue>", define.name);
        } else {
            emitMConst(define.name, define.value);
        }
    }

    private void emitBasetype(ref VkBasetypeType basetype) {
        emitAlias(basetype.name, basetype.type);
    }

    private void emitBitmask(ref VkBitmaskType bitmask) {
        file.writefln!"alias %s = %s;"(bitmask.name, bitmask.backing);
        // if (bitmask.requires.empty) {
        // } else {
        //     file.writefln!"alias %s = BitFlags!%s;"(bitmask.name, bitmask.requires);
        // }
    }

    private void emitHandle(ref VkHandleType handle) {
        if (handle.alias_.empty) {
            auto name = handle.name;
            file.writefln!"alias %s = OpaqueHandle!(\"%s\");"(name, name);
        } else {
            emitAlias(handle.name, handle.alias_);
        }
    }

    private void emitEnum(ref VkEnumType enum_) {
        if (enum_.bitmask) {
            emitBitmask(enum_);
        } else if (enum_.members.empty) {
            file.writefln!"enum %s {}"(enum_.name);
        } else {
            const prefix = enum_.name.camelToScreaming ~ "_";
            file.writefln!"enum %s {"(enum_.name);
            file.indent();
            foreach (ref member; enum_.members) {
                file.writefln!"%s = %s,"(member.shortName(prefix), member.value);
            }
            file.dedent();
            file.writeln("}\n");
            foreach (ref member; enum_.members) {
                file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
            }
        }
    }

    private void emitBitmask(ref VkEnumType enum_) {
        if (enum_.members.empty) {
            file.writefln!"enum %s : %s {}"(enum_.name, enum_.backingType);
        } else {
            const prefix = enum_.name.camelToScreaming ~ "_";
            file.writefln!"enum %s : %s {"(enum_.name, enum_.backingType);
            file.indent();
            foreach (ref member; enum_.members) {
                file.writefln!"%s = %s,"(member.shortName(prefix), member.value);
            }
            file.dedent();
            file.writeln("}\n");
            foreach (ref member; enum_.members) {
                file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
            }
        }
    }

    private void emitFuncPtr(ref VkFuncPtrType funcptr) {
        if (funcptr.params.empty) {
            file.writefln!"alias %s = %s function();"(funcptr.name, funcptr.type);
        } else {
            file.writefln!"alias %s = %s function("(funcptr.name, funcptr.type);
            file.indent();
            foreach (ref param; funcptr.params) {
                file.writefln!"%s %s,"(param.type, param.name);
            }
            file.dedent();
            file.writeln(");");
        }

        // file.writefln!"alias %s = %s"(funcptr.name, funcptr.value);
        // file.writefln!"// -=[%s]=-"(funcptr.name);
    }

    private void emitStruct(ref VkStructType struct_) {
        if (struct_.members.empty) {
            file.writefln!"struct %s {}"(struct_.name);
        } else {
            file.writefln!"struct %s {"(struct_.name);
            file.indent();
            foreach (ref member; struct_.members) {
                if (member.values.length == 1) {
                    file.writefln!"%s %s = %s;"(member.type, member.name, member.values[0]);
                } else {
                    file.writefln!"%s %s;"(member.type, member.name);
                }
            }
            file.dedent();
            file.writeln("}");
        }
    }

    private void emitUnion(ref VkUnionType union_) {
        if (union_.members.empty) {
            file.writefln!"union %s {}"(union_.name);
        } else {
            file.writefln!"union %s {"(union_.name);
            file.indent();
            foreach (ref member; union_.members) {
                file.writefln!"%s %s;"(member.type, member.name);
            }
            file.dedent();
            file.writeln("}");
        }
    }

    private void emitAlias(string lhs, string rhs) {
        file.writefln!"alias %s = %s;"(lhs, rhs);
    }

    private void emitMConst(string name, string value) {
        file.writefln!"enum %s = %s;"(name, value);
    }

    private void emitMConst(string type, string name, string value) {
        file.writefln!"enum %s %s = %s;"(type, name, value);
    }
}

/** 
 * Utility to facilitate writing common source file
 *   patterns like indentation & comments.
 */
package struct Emitter {
    private File file;

    private int indentlvl;

    private int commentlvl;


    this(File file) {
        this.file = file;
        indentlvl = 0;
        commentlvl = 0;
    }

    void indent() {
        indentlvl += 1;
    }

    void dedent() {
        if (indentlvl) {
            indentlvl -= 1;
        }
    }

    void comment() {
        if (!commentlvl) {
            file.writefln("%*s/**", indentlvl * 4, "");
        }

        commentlvl += 1;
    }

    void uncomment() {
        if (!commentlvl) {
            return;
        }

        commentlvl -= 1;

        if (!commentlvl) {
            file.writefln("%*s */", indentlvl * 4, "");
        }
    }

    void writeln(A...)(A args) {
        if (commentlvl) {
            file.writeln(format!"%*s * "(indentlvl * 4, ""), args);
        } else {
            file.writeln(format!"%*s"(indentlvl * 4, ""), args);
        }
    }

    void writefln(alias fmt, A...)(A args) {
        if (commentlvl) {
            file.writefln!("%*s * " ~ fmt)(indentlvl * 4, "", args);
        } else {
            file.writefln!("%*s" ~ fmt)(indentlvl * 4, "", args);
        }
    }

    void writefln(Char, A...)(Char[] fmt, A args) if (isSomeString!(Char[])) {
        if (commentlvl) {
            file.writefln("%*s * " ~ fmt, indentlvl * 4, "", args);
        } else {
            file.writefln("%*s" ~ fmt, indentlvl * 4, "", args);
        }
    }
}

bool isMultiline(VkTypeCategory category) => multiline.get(category, false);

private const bool[VkTypeCategory] multiline = [
    VkTypeCategory.Include: false,
    VkTypeCategory.Define: false,
    VkTypeCategory.Basetype: false,
    VkTypeCategory.Bitmask: false,
    VkTypeCategory.Handle: false,
    VkTypeCategory.Enum: true,
    VkTypeCategory.FuncPtr: true,
    VkTypeCategory.Struct: true,
    VkTypeCategory.Union: true,
];

bool isBespoke(string name) => bespoke.get(name, false);

private const bool[string] bespoke = [
    "VK_MAKE_VERSION": true,
    "VK_VERSION_MAJOR": true,
    "VK_VERSION_MINOR": true,
    "VK_VERSION_PATCH": true,

    "VK_MAKE_API_VERSION": true,
    "VK_API_VERSION_VARIANT": true,
    "VK_API_VERSION_MAJOR": true,
    "VK_API_VERSION_MINOR": true,
    "VK_API_VERSION_PATCH": true,

    "VK_USE_64_BIT_PTR_DEFINES": true,

    "VK_NULL_HANDLE": true,

    "VK_DEFINE_HANDLE": true,
    "VK_DEFINE_NON_DISPATCHABLE_HANDLE": true,
    
];