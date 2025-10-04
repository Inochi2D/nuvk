module emitter;

import std.algorithm;
import std.array;
import std.stdio;
import std.string;
import std.traits;

import nulib.collections.set;

import logger;
import registry;


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
        file.writeln("module vulkan.core;");
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.loader;");
        file.writeln("extern (System) @nogc nothrow:");

        // Emit every section of every feature.
        foreach (ref feature; registry.features) {
            file.writefln!"\n// %s\n"(feature.name);
            foreach (ref section; feature.sections) {
                emitSection(section);
            }
        }
    }

    private void emitSection(ref VkSection section) {
        // Section marker
        file.writefln!"\n// %s\n"(section.name);

        foreach (name; section.enums) {
            if (auto const_ = name in registry.constants) {
                auto ref enum_ = registry.enums[*const_];
                auto member = enum_.members[name];

                if (member.type.empty) {
                    emitEnum(member.name, member.value);
                } else {
                    emitEnum(member.type, member.name, member.value);
                }
            } else {
                logger.err("%s not found", name);
            }
        }

        foreach (i, type; section.types.map!(t => registry.types[t]).array) {
            const last = i + 1 == section.types.length;
            switch (type.category) {
                case VkTypeCategory.Define:
                    emitDefine(registry.defines[type.name]);
                    break;

                case VkTypeCategory.Basetype:
                    emitBasetype(registry.basetypes[type.name]);
                    break;

                case VkTypeCategory.Handle:
                    emitHandle(registry.handles[type.name]);
                    break;

                case VkTypeCategory.Struct:
                    emitStruct(registry.structs[type.name], last);
                    break;

                default:
                    logger.dbg(1, "skipping type %s", type.name);
                    break;
            }
        }

        foreach (command; section.commands.map!(c => registry.commands[c])) {
            logger.dbg(1, "skipping command %s", command.name);
        }
    }

    private void emitDefine(ref VkDefineType define) {
        if (define.critical || define.name.startsWith("VKSC")) {
            logger.dbg(1, "skipping security-critical define <lblue>%s</lblue>", define.name);
        } else if (bespoke.contains(define.name)) {
            logger.dbg(1, "skipping define with bespoke impl. <lblue>%s</lblue>", define.name);
        } else if (define.commented) {
            logger.dbg(1, "ignoring commented out define <lblue>%s</lblue>", define.name);
        } else {
            emitEnum(define.name, define.value);
        }
    }

    private void emitBasetype(ref VkBasetypeType basetype) {
        switch (basetype.type) {
            case "uint32_t":
                emitAlias(basetype.name, uint.stringof);
                break;

            case "uint64_t":
                emitAlias(basetype.name, ulong.stringof);
                break;

            default:
                break;
        }
    }

    private void emitHandle(ref VkHandleType handle) {
        if (handle.alias_.empty) {
            auto name = handle.name;
            file.writefln!"alias %s = OpaqueHandle!(\"%s\");"(name, name);
        } else {
            emitAlias(handle.name, handle.alias_);
        }
    }

    private void emitStruct(ref VkStructType struct_, bool last) {
        if (struct_.members.empty) {
            file.writefln!"struct %s {}"(struct_.name);
        } else {
            file.writefln!"struct %s {"(struct_.name);
            file.indent();
            foreach (ref member; struct_.members) {
                file.writefln!"%s %s;"(member.type, member.name);
            }
            file.dedent();
            file.writeln(last ? "}" : "}\n");
        }
    }

    private void emitAlias(string lhs, string rhs) {
        file.writefln!"alias %s = %s;"(lhs, rhs);
    }

    private void emitEnum(string name, string value) {
        file.writefln!"enum %s = %s;"(name, value);
    }

    private void emitEnum(string type, string name, string value) {
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

private set!string bespoke;

static this() {
    bespoke.insert("VK_MAKE_VERSION");
    bespoke.insert("VK_VERSION_MAJOR");
    bespoke.insert("VK_VERSION_MINOR");
    bespoke.insert("VK_VERSION_PATCH");

    bespoke.insert("VK_MAKE_API_VERSION");
    bespoke.insert("VK_API_VERSION_VARIANT");
    bespoke.insert("VK_API_VERSION_MAJOR");
    bespoke.insert("VK_API_VERSION_MINOR");
    bespoke.insert("VK_API_VERSION_PATCH");

    bespoke.insert("VK_USE_64_BIT_PTR_DEFINES");

    bespoke.insert("VK_NULL_HANDLE");

    bespoke.insert("VK_DEFINE_HANDLE");
    bespoke.insert("VK_DEFINE_NON_DISPATCHABLE_HANDLE");
}