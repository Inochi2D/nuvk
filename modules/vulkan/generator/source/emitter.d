module emitter;

import std.algorithm;
import std.array;
import std.range;
import std.stdio;
import std.string;
import std.traits;

import util;
import registry;


/** 
 * Emit Vulkan core from our registry to our file.
 */
void emitCore(ref VkRegistry registry, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitCore();
}

/** 
 * Emit Vulkan extensions from our registry to our file.
 */
void emitExt(ref VkRegistry registry, string ext, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitExt(ext);
}

/** 
 * Emits generated D files from a registry.
 */
class VkRegistryEmitter {
    private VkRegistry* registry;

    private Emitter file;

    private Logger logger;


    /** 
     * Construct an emitter from a registry and a file handle.
     * 
     * Params:
     *   registry = Source of the generated file.
     *   file = File handle where the generated file will be emitted.
     */
    this(ref VkRegistry registry, File file, Logger logger) {
        this.registry = &registry;
        this.file = Emitter(file);
        this.logger = logger;
    }

    void emitCore() {
        // Write preamble comment.
        file.comment();
        file.writeln("Vulkan Core");
        file.writeln();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Module name, imports, attributes.
        file.writeln("module vulkan.core;");
        file.writeln();
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.defines;");
        file.writeln("import vulkan.loader;");
        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");

        // Collect features that are part of the normal Vulkan core.
        auto features = registry.features.filter!(f => "vulkan" in f).array;

        // Emit version number preamble.
        foreach_reverse (ref feature; features) {
            if (feature.depends.empty || feature.depends == "VK_VERSION_1_0") {
                continue;
            }

            file.writeln();
            file.openf!"version (%s) {"(feature.name);
            file.writefln!"version = %s;"(feature.depends);
            file.close("}");
        }

        // Emit version number constants.
        foreach (ref feature; features.filter!(f => !f.depends.empty)) {
            file.writeln();
            file.openf!"version (%s) {"(feature.name);
            file.writefln!"package enum %s = true;"(feature.name);
            file.clopen("} else {");
            file.writefln!"package enum %s = false;"(feature.name);
            file.close("}");
        }

        // Emit every section of every feature.
        foreach (ref feature; features) {
            file.writeln();
            file.writefln!"// %s"(feature.name);
            foreach (ref section; feature.sections.filter!(s => !s.empty)) {
                emitCoreSection(section, feature);
            }
        }
    }

    void emitExt(string ext) {
        // Write preamble comment.
        file.comment();
        file.writeln(ext);
        file.writeln();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Find extension.
        auto extension = registry.extensions[ext];

        // Module name, imports, attributes.
        file.writefln!"module vulkan.%s.%s;"(extension.author.toLower, extension.shortName);
        file.writeln();
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.loader;");
        file.writeln("import vulkan.core;");
        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");

        // Emit every section of our extension.
        foreach (ref section; extension.sections.filter!(s => !s.empty)) {
            emitExtSection(section, extension);
        }
    }

    private void emitCoreSection(ref VkSection section, ref VkFeature feature) {
        auto prevcategory = emitSection(section);

        if (!section.commands.empty) {
            if (prevcategory) {
                file.writeln();
            }

            file.openf!"version (%s) {"(feature.name);
            foreach (i, command; section.commands.map!(c => registry.commands[c]).array) {
                if (i > 0) {
                    file.writeln();
                }

                if (command.params.empty) {
                    file.writefln!"extern %s %s();"(command.type, command.name);
                } else {
                    file.openf!"extern %s %s("(command.type, command.name);
                    foreach (param; command.params) {
                        file.writefln!"%s %s,"(param.type, param.name);
                    }
                    file.close(");");
                }
            }
            file.close("}");
        }
    }

    private void emitExtSection(ref VkSection section, ref VkExtension ext) {
        auto prevcategory = emitSection(section);

        if (!section.commands.empty) {
            auto commands = section.commands.map!(c => registry.commands[c]).array;
            auto funcptrs = commands.map!(c => c.funcptr).array;

            if (prevcategory) {
                file.writeln();
            }

            foreach (i, ref funcptr; funcptrs) {
                if (i > 0) {
                    file.writeln();
                }

                emitFuncPtr(funcptr);
            }

            file.writeln();
            file.openf!"struct %s {"(format!"%s%sCommands"(ext.author, ext.shortName.snakeToCamel));
            foreach (i, ref command, ref funcptr; lockstep(commands, funcptrs)) {
                if (i > 0) {
                    file.writeln();
                }

                file.writefln!"@VkProcName(\"%s\")"(command.name);
                file.writefln!"%s %s;"(funcptr.name, command.name);
            }
            file.close("}");
        }
    }

    private VkTypeCategory emitSection(ref VkSection section) {
        // Section marker.
        if (!section.name.empty) {
            file.writeln();
            file.writefln!"// %s"(section.name);
        }

        VkTypeCategory prevcategory = VkTypeCategory.None;

        if (section.mconsts.length > 0) {
            prevcategory = VkTypeCategory.Define;
            file.writeln();
        }

        foreach (ref mconst; section.mconsts) {
            if (mconst.type.empty) {
                emitMConst(mconst.name, mconst.value);
            } else {
                emitMConst(mconst.type, mconst.name, mconst.value);
            }
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

        return prevcategory;
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
        if (enum_.members.empty) {
            return;
        } else if (enum_.bitmask) {
            emitBitmask(enum_);
        } else if (enum_.members.empty) {
            file.writefln!"enum %s {}"(enum_.name);
        } else {
            const prefix = enum_.name.camelToScreaming ~ "_";
            file.openf!"enum %s {"(enum_.name);
            foreach (ref member; enum_.members) {
                if (member.alias_.empty) {
                    file.writefln!"%s = %s,"(member.shortName(prefix), member.value);
                } else {
                    file.writefln!"%s = %s,"(member.shortName(prefix), member.shortAlias(prefix));
                }
            }
            file.close("}");
            file.writeln();

            foreach (ref member; enum_.members) {
                if (member.alias_.empty) {
                    file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
                } else {
                    file.writefln!"enum %s = %s;"(member.name, member.alias_);
                }
            }
        }
    }

    private void emitBitmask(ref VkEnumType enum_) {
        if (enum_.members.empty) {
            file.writefln!"enum %s : %s {}"(enum_.name, enum_.backingType);
        } else {
            const prefix = enum_.name.camelToScreaming ~ "_";
            file.openf!"enum %s : %s {"(enum_.name, enum_.backingType);
            foreach (ref member; enum_.members) {
                if (member.alias_.empty) {
                    file.writefln!"%s = %s,"(member.shortName(prefix), member.value);
                } else {
                    file.writefln!"%s = %s,"(member.shortName(prefix), member.shortAlias(prefix));
                }
            }
            file.close("}");
            file.writeln();

            foreach (ref member; enum_.members) {
                if (member.alias_.empty) {
                    file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
                } else {
                    file.writefln!"enum %s = %s;"(member.name, member.alias_);
                }
            }
        }
    }

    private void emitFuncPtr(ref VkFuncPtrType funcptr) {
        if (funcptr.params.empty) {
            file.writefln!"alias %s = %s function();"(funcptr.name, funcptr.type);
        } else {
            file.openf!"alias %s = %s function("(funcptr.name, funcptr.type);
            foreach (ref param; funcptr.params) {
                file.writefln!"%s %s,"(param.type, param.name);
            }
            file.close(");");
        }
    }

    private void emitStruct(ref VkStructType struct_) {
        if (struct_.members.empty) {
            file.writefln!"struct %s {}"(struct_.name);
        } else {
            file.openf!"struct %s {"(struct_.name);
            foreach (ref member; struct_.members) {
                if (member.values.length == 1) {
                    file.writefln!"%s %s = %s;"(member.type, member.safename, member.values[0]);
                } else {
                    file.writefln!"%s %s;"(member.type, member.safename);
                }
            }
            file.close("}");
        }
    }

    private void emitUnion(ref VkUnionType union_) {
        if (union_.members.empty) {
            file.writefln!"union %s {}"(union_.name);
        } else {
            file.openf!"union %s {"(union_.name);
            foreach (ref member; union_.members) {
                file.writefln!"%s %s;"(member.type, member.safename);
            }
            file.close("}");
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

    void open(A...)(A args) {
        writeln(args);
        indent();
    }

    void openf(alias fmt, A...)(A args) {
        writefln!fmt(args);
        indent();
    }

    void close(A...)(A args) {
        dedent();
        writeln(args);
    }

    void closef(alias fmt, A...)(A args) {
        dedent();
        writeln!fmt(args);
    }

    void clopen(A...)(A args) {
        dedent();
        writeln(args);
        indent();
    }

    void clopenf(alias fmt, A...)(A args) {
        dedent();
        writeln!fmt(args);
        indent();
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

private string preamble = import("vk_preamble.txt");

/** 
 * Whether a given type category takes multiple lines when emitted.
 * 
 * This function is used to track spacing emitted between declarations.
 * 
 * Params:
 *   category = A Vulkan type category.
 * 
 * Returns: true if the type category is multiline, false otherwise.
 */
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

/** 
 * Whether the given symbol has a bespoke implementation and should be skipped.
 * 
 * Params:
 *   name = A symbol name which has a bespoke implementation.
 * 
 * Returns: true when a symbol should be ignored, false otherwise.
 */
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