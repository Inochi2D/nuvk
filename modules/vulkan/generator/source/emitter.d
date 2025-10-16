module emitter;

import std.algorithm;
import std.array;
import std.range;
import std.sumtype;
import std.stdio;
import std.string;
import std.traits;

import util;
import registry;


/** 
 * Emit Vulkan core from our registry to our file.
 */
void emitVkCore(const ref VkRegistry registry, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitVkCore();
}

/** 
 * Emit Vulkan extensions from our registry to our file.
 */
void emitVkExt(const ref VkRegistry registry, const ref VkExtension ext, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitVkExt(ext);
}

/** 
 * Emit Video common from our registry to our file.
 */
void emitVidCommon(const ref VkRegistry registry, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitVidCommon();
}

/** 
 * Emit Video extensions from our registry to our file.
 */
void emitVidExt(const ref VkRegistry registry, const ref VkExtension ext, File file, Logger logger) {
    auto emitter = new VkRegistryEmitter(registry, file, logger);
    emitter.emitVidExt(ext);
}

/** 
 * Emits generated D files from a registry.
 */
class VkRegistryEmitter {
    private const VkRegistry* registry;

    private Emitter file;

    private Logger logger;


    /** 
     * Construct an emitter from a registry and a file handle.
     * 
     * Params:
     *   registry = Source of the generated file.
     *   file = File handle where the generated file will be emitted.
     */
    this(const ref VkRegistry registry, File file, Logger logger) {
        this.registry = &registry;
        this.file = Emitter(file);
        this.logger = logger;
    }

    /** 
     * Emit core Vulkan functionality.
     */
    void emitVkCore() {
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
        file.writeln("import vulkan.patches;");
        file.writeln("import vulkan.loader;");
        file.writeln();
        file.writeln("public import vulkan.defines;");
        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");
        file.writeln();
        file.writeln(cascade.splitLines.join("\n"));

        // Collect features that are part of the normal Vulkan core.
        auto features = registry.features[].filter!(f => "vulkan" in f).array;

        // Emit every section of every feature.
        VkTypeCategory prevcategory = VkTypeCategory.None;
        foreach (ref feature; features) {
            file.writeln();

            foreach (ref section; feature.sections.filter!(s => !s.empty)) {
                emitCoreSection(section, feature, prevcategory);
            }
        }
    }

    /** 
     * Emit Vulkan extension.
     */
    void emitVkExt(const ref VkExtension ext) {
        // Write preamble comment.
        file.comment();
        file.writefln!"%s (%s)"(ext.name, ext.type);
        file.writeln();
        if (auto vendor = ext.author in registry.vendors) {
            file.writeln("Author:");
            file.writefln!"    %s"(vendor.author);
        } else {
            file.writeln("Author:");
            file.writefln!"    %s"(ext.author);
        }
        if (ext.platform) {
            file.writeln();
            file.writeln("Platform:");
            if (auto platform = ext.platform in registry.platforms) {
                file.writefln!"    %s"(platform.comment);
            } else {
                file.writefln!"    %s"(ext.platform);
            }
        }
        file.writeln();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Module name, imports, attributes.
        if (ext.isVulkan) {
            file.writefln!"module vulkan.%s.%s;"(ext.prefix, ext.shortName);
        } else {
            file.writefln!"module vulkan.video.%s;"(ext.shortName);
        }

        file.writeln();
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.patches;");
        file.writeln("import vulkan.loader;");
        file.writeln("import vulkan.core;");

        if (auto promo = ext.promoted in registry.extensions) {
            file.writefln!"import vulkan.%s.%s;"(promo.prefix, promo.shortName);
        } else if (ext.promoted && ext.promoted !in registry.features) {
            logger.warn("unknown promoted extension %s", ext.promoted);
        }

        if (auto deprecated_ = ext.deprecated_ in registry.extensions) {
            file.writefln!"import vulkan.%s.%s;"(deprecated_.prefix, deprecated_.shortName);
        }

        if (auto deps = ext.name in dependencies) {
            foreach (ref dep; (*deps).map!(d => registry.extensions[d])) {
                file.writefln!"import vulkan.%s.%s;"(dep.prefix, dep.shortName);
            }
        }

        if (auto video = ext.name in videos) {
            foreach (v; *video) {
                file.writefln!"import vulkan.video.%s;"(v);
            }
        }

        switch (ext.platform) {
            case "win32":
                file.writeln("import vulkan.platforms.windows;");
                break;

            case "metal":
                file.writeln("import vulkan.platforms.metal;");
                break;

            case "xlib":
                file.writeln("import vulkan.platforms.xlib;");
                break;

            case "xlib_xrandr":
                file.writeln("import vulkan.platforms.xrandr;");
                break;

            case "fuchsia":
                file.writeln("import vulkan.platforms.fuchsia;");
                break;

            case "directfb":
                file.writeln("import vulkan.platforms.directfb;");
                break;

            case "wayland":
                file.writeln("import vulkan.platforms.wayland;");
                break;

            case "xcb":
                file.writeln("import vulkan.platforms.xcb;");
                break;

            case "screen":
                file.writeln("import vulkan.platforms.qnx;");
                break;

            case "android":
                file.writeln("import vulkan.platforms.android;");
                break;

            case "ohos":
                file.writeln("import vulkan.platforms.ohos;");
                break;

            case "":
                break;

            default:
                logger.dbg(1, "skipping import for platform <yellow>%s</yellow>", ext.platform);
                break;
        }

        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");
        file.writeln();
        file.writeln(cascade.splitLines.join("\n"));

        if (ext.depends) {
            file.writeln();
            emitDepends(ext.depends);
        }

        // Emit target platform version guard.
        if (!ext.platform.empty && ext.platform in platforms) {
            file.writefln!"version (%s):"(platforms[ext.platform]);
        }

        // Emit extension commands struct.
        emitExtCommands(ext.sections, ext);

        // Emit every section of our extension.
        VkTypeCategory prevcategory = VkTypeCategory.None;
        foreach (const ref section; ext.sections.filter!(s => !s.empty)) {
            emitExtSection(section, ext, prevcategory);
        }
    }

    /** 
     * Emit Vulkan Video common functionality.
     */
    void emitVidCommon() {
        // Write preamble comment.
        file.comment();
        file.writeln("Video Common");
        file.writeln();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Module name, imports, attributes.
        file.writefln!"module vulkan.video.common;";
        file.writeln();
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.patches;");
        file.writeln("import vulkan.loader;");
        file.writeln();
        file.writeln("public import vulkan.video.defines;");
        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");

        // Find common extension.
        auto common = registry.extensions["vulkan_video_codecs_common"];

        // Emit every section of our extension.
        VkTypeCategory prevcategory = VkTypeCategory.None;
        foreach (const ref section; common.sections.filter!(s => !s.empty)) {
            emitExtSection(section, common, prevcategory);
        }
        emitExtCommands(common.sections, common);
    }

    /** 
     * Emit Vulkan Video extension.
     */
    void emitVidExt(const ref VkExtension ext) {
        // Write preamble comment.
        file.comment();
        file.writeln(ext.name);
        file.writeln();
        if (auto vendor = ext.author in registry.vendors) {
            file.writefln!"Author: %s"(vendor.author);
        } else {
            file.writefln!"Author: %s"(ext.author);
        }
        file.writeln();
        foreach (line; preamble.splitLines) {
            file.writeln(line);
        }
        file.uncomment();

        // Module name, imports, attributes.
        if (ext.isVulkan) {
            file.writefln!"module vulkan.%s.%s;"(ext.prefix, ext.shortName);
        } else {
            file.writefln!"module vulkan.video.%s;"(ext.shortName);
        }
        file.writeln();
        file.writeln("import numem.core.types : OpaqueHandle;");
        file.writeln("import vulkan.patches;");
        file.writeln("import vulkan.loader;");
        file.writeln("import vulkan.video.common;");
        if (ext.name.endsWith("_encode")) {
            auto parent = registry.extensions[ext.name[0 .. $ - "_encode".length]];
            file.writefln!"import vulkan.video.%s;"(parent.shortName);
        } else if (ext.name.endsWith("_decode")) {
            auto parent = registry.extensions[ext.name[0 .. $ - "_decode".length]];
            file.writefln!"import vulkan.video.%s;"(parent.shortName);
        }
        file.writeln();
        file.writeln("extern (System) @nogc nothrow:");

        // Emit extension commands struct.
        emitExtCommands(ext.sections, ext);

        // Emit every section of our extension.
        VkTypeCategory prevcategory = VkTypeCategory.None;
        foreach (const ref section; ext.sections.filter!(s => !s.empty)) {
            emitExtSection(section, ext, prevcategory);
        }
    }

    /** 
     * Emit a section from core Vulkan.
     */
    private void emitCoreSection(const ref VkSection section, const ref VkFeature feature, ref VkTypeCategory prevcategory) {
        emitSection(section, prevcategory);

        if (!section.commands.empty) {
            if (prevcategory) {
                file.writeln();
            }

            if (feature.minor > 0) {
                file.openf!"version (%s) {"(feature.name);
            }

            foreach (i, command; section.commands.map!(c => registry.commands[c]).array) {
                if (i > 0) {
                    file.writeln();
                }

                if (command.params.empty) {
                    file.writefln!"extern %s %s();"(command.type, command.name);
                } else {
                    file.openf!"extern %s %s("(command.type, command.name);
                    foreach (param; command.params) {
                        file.writefln!"%s %s,"(param.type, param.safename);
                    }
                    file.close(");");
                }
            }

            if (feature.minor > 0) {
                file.close("}");
            }
        }
    }

    /** 
     * Emit a section from a Vulkan extension.
     */
    private void emitExtSection(const ref VkSection section, const ref VkExtension ext, ref VkTypeCategory prevcategory) {
        emitSection(section, prevcategory);

        foreach (ref command; section.commands.map!(c => registry.commands[c])) {
            file.writeln();
            emitFuncPtr(command);
        }
    }

    /** 
     * Emit command struct from a Vulkan extension.
     */
    private void emitExtCommands(const(VkSection)[] sections, const ref VkExtension ext) {
        // Early return if section is empty of commands.
        if (sections.fold!((int a, s) => a + cast(int) s.commands.length)(0) == 0) {
            return;
        }

        file.writeln();
        file.openf!"struct %s {"(ext.name);
        foreach (section; sections) {
            auto commands = section.commands
                .map!(c => registry.commands[c])
                .map!(c => c.isAlias ? registry.commands[c.alias_] : c)
                .array;

            auto funcptrs = commands
                .map!(c => c.funcptr)
                .array;

            section.depends.match!(
                (string name) {
                    file.writeln();
                    if (name in registry.features) {
                        file.openf!"version (%s) {"(name);
                    }
                },
                (_) {},
            );

            foreach (i, ref command, ref funcptr; lockstep(commands, funcptrs)) {
                if (i > 0) {
                    file.writeln();
                }

                file.writefln!"@VkProcName(\"%s\")"(command.name);
                file.writefln!"%s %s;"(funcptr.name, command.name);
            }

            section.depends.match!(
                (string name) {
                    if (name in registry.features) {
                        file.close("}");
                    }
                },
                (_) {},
            );
        }
        file.close("}");
    }

    /** 
     * Common functionality between all functions that emit Vulkan sections.
     */
    private VkTypeCategory emitSection(const ref VkSection section, ref VkTypeCategory prevcategory) {
        // Section marker.
        if (!section.name.empty) {
            file.writeln();
            file.writefln!"// %s"(section.name);
        }

        if (section.depends) {
            file.writeln();
            emitDepends(section.depends);
        }

        if (section.mconsts.length > 0) {
            prevcategory = VkTypeCategory.Define;
            file.writeln();
        }

        foreach (ref mconst; section.mconsts) {
            emitDeprecation(mconst.isDeprecated, mconst.deprecated_);

            if (mconst.hasAlias) {
                emitMConst(mconst.name, mconst.alias_);
            } else if (mconst.type.empty) {
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

                case VkTypeCategory.Include:
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

    /** 
     * Emit version guard & dependency import statements.
     */
    private void emitDepends(const ref VkDepends depends) {
        depends.match!(
            (typeof(null)) {},
            (string name) {
                if (name in registry.features) {
                    file.writefln!"version (%s):"(name);
                } else if (auto dep = name in registry.extensions) {
                    file.writefln!"public import vulkan.%s.%s;"(dep.prefix, dep.shortName);
                } else {
                    file.writefln!"// -=[%s]=-"(depends);
                }
            },
            (const ref VkDependsOp op) {
                if (op.operator == ',') {
                    if (op.lhs.isFeature) {
                        file.openf!"version (%s) {} else {"(op.lhs.name);
                        emitDepends(*op.rhs);
                        file.close("}");
                    } else if (op.rhs.isFeature) {
                        file.openf!"version (%s) {} else {"(op.rhs.name);
                        emitDepends(*op.lhs);
                        file.close("}");
                    } else {
                        emitDepends(*op.lhs);
                        emitDepends(*op.rhs);
                    }
                } else if (op.operator == '+') {
                    if (op.lhs.isFeature) {
                        emitDepends(*op.lhs);
                        emitDepends(*op.rhs);
                    } else {
                        emitDepends(*op.rhs);
                        emitDepends(*op.lhs);
                    }
                }
            },
        );
    }

    private void emitDefine(const ref VkDefineType define) {
        if (isBespoke(define.name)) {
            logger.dbg(1, "skipping define with bespoke impl. <lblue>%s</lblue>", define.name);
        } else if (define.commented) {
            logger.dbg(1, "ignoring commented out define <lblue>%s</lblue>", define.name);
        } else {
            emitMConst(define.name, define.value);
        }
    }

    private void emitBasetype(const ref VkBasetypeType basetype) {
        if (!basetype.name.isBespoke) {
            emitAlias(basetype.name, basetype.type);
        }
    }

    private void emitBitmask(const ref VkBitmaskType bitmask) {
        if (bitmask.alias_.empty) {
            file.writefln!"alias %s = %s;"(bitmask.name, bitmask.backing);
        } else {
            file.writefln!"alias %s = %s;"(bitmask.name, bitmask.alias_);
        }
    }

    private void emitHandle(const ref VkHandleType handle) {
        if (handle.alias_.empty) {
            auto name = handle.name;
            file.writefln!"alias %s = OpaqueHandle!(\"%s\");"(name, name);
        } else {
            emitAlias(handle.name, handle.alias_);
        }
    }

    private void emitEnum(const ref VkEnumType enum_) {
        if (enum_.alias_) {
            emitAlias(enum_.name, enum_.alias_);
        } else if (enum_.bitmask) {
            emitBitmask(enum_);
        } else if (enum_.members.empty) {
            file.writefln!"enum %s;"(enum_.name);
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
                emitDeprecation(member.isDeprecated, member.deprecated_);

                if (member.alias_.empty) {
                    file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
                } else {
                    file.writefln!"enum %s = %s;"(member.name, member.alias_);
                }
            }
        }
    }

    private void emitBitmask(const ref VkEnumType enum_) {
        if (enum_.members.empty) {
            file.writefln!"enum %s : %s;"(enum_.name, enum_.backingType);
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
                emitDeprecation(member.isDeprecated, member.deprecated_);

                if (member.alias_.empty) {
                    file.writefln!"enum %s = %s.%s;"(member.name, enum_.name, member.shortName(prefix));
                } else {
                    file.writefln!"enum %s = %s;"(member.name, member.alias_);
                }
            }
        }
    }

    private void emitFuncPtr(const ref VkCommand command) {
        if (command.alias_) {
            auto funcptr = registry.commands[command.alias_].funcptr;
            emitFuncPtr(funcptr);
        } else {
            auto funcptr = command.funcptr;
            emitFuncPtr(funcptr);
        }
    }

    private void emitFuncPtr(const ref VkFuncPtrType funcptr) {
        if (funcptr.params.empty) {
            file.writefln!"alias %s = %s function();"(funcptr.name, funcptr.type);
        } else {
            file.openf!"alias %s = %s function("(funcptr.name, funcptr.type);
            foreach (ref param; funcptr.params) {
                file.writefln!"%s %s,"(param.type, param.safename);
            }
            file.close(");");
        }
    }

    private void emitStruct(const ref VkStructType struct_) {
        if (struct_.name.isBespoke) {
            return;
        }

        if (!struct_.alias_.empty) {
            emitAlias(struct_.name, struct_.alias_);
        } else if (struct_.members.empty) {
            file.writefln!"struct %s {}"(struct_.name);
        } else {
            file.openf!"struct %s {"(struct_.name);
            foreach (ref member; struct_.members) {
                string type = member.type;
                if (auto bitmask = type in registry.bitmasks) {
                    if (auto alias_ = bitmask.alias_ in registry.bitmasks) {
                        type = alias_.backing;
                    } else {
                        type = bitmask.backing;
                    }
                }

                emitDeprecation(member.isDeprecated, member.deprecated_);

                if (member.width > 0) {
                    if (member.values.length == 1) {
                        file.writefln!"%s %s:%s = %s;"(type, member.safename, member.width, member.values[0]);
                    } else {
                        file.writefln!"%s %s:%s;"(type, member.safename, member.width);
                    }
                } else {
                    if (member.values.length == 1) {
                        file.writefln!"%s %s = %s;"(type, member.safename, member.values[0]);
                    } else {
                        file.writefln!"%s %s;"(type, member.safename);
                    }
                }
            }
            if (struct_.hasBitfields) {
                file.writeln("mixin DMD20473;");
            }
            file.close("}");
        }
    }

    private void emitUnion(const ref VkUnionType union_) {
        if (union_.name.isBespoke) {
            return;
        }

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

    private void emitDeprecation(bool deprecated_, string reason) {
        if (deprecated_) {
            file.writefln!"deprecated(\"%s\")"(reason);
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

private string preamble = import("preamble.txt");
private string cascade = import("cascade.txt");

private const string[string] platforms = [
    "android": "Android",
    "win32": "Windows",
    "ios": "iOS",
    "macos": "OSX",
];

/** 
 * Dependencies between extensions that have to be manually added because
 *   vk.xml is a mess.
 */
private string[][string] dependencies = [
    "VK_EXT_pipeline_properties": [
        "VK_KHR_pipeline_executable_properties",
    ],
    "VK_KHR_ray_tracing_pipeline": [
        "VK_KHR_pipeline_library",
    ],
    "VK_NV_framebuffer_mixed_samples": [
        "VK_AMD_mixed_attachment_samples",
    ],
    "VK_NV_cooperative_matrix": [
        "VK_KHR_shader_bfloat16",
        "VK_KHR_cooperative_matrix",
    ],
    "VK_NV_partitioned_acceleration_structure": [
        "VK_NV_cluster_acceleration_structure",
    ],
    "VK_QCOM_render_pass_transform": [
        "VK_KHR_surface",
    ],
    "VK_QCOM_rotated_copy_commands": [
        "VK_KHR_surface",
    ],
];

/** 
 * Map Vulkan extensions to Vulkan Video modules.
 */
private string[][string] videos = [
    "VK_KHR_video_encode_av1": [
        "av1std", "av1std_encode", "av1std_decode",
    ],
    "VK_KHR_video_decode_av1": [
        "av1std", "av1std_encode", "av1std_decode",
    ],
    "VK_KHR_video_encode_h264": [
        "h264std", "h264std_encode", "h264std_decode",
    ],
    "VK_KHR_video_decode_h264": [
        "h264std", "h264std_encode", "h264std_decode",
    ],
    "VK_KHR_video_encode_h265": [
        "h265std", "h265std_encode", "h265std_decode",
    ],
    "VK_KHR_video_decode_h265": [
        "h265std", "h265std_encode", "h265std_decode",
    ],
    "VK_KHR_video_encode_vp9": [
        "vp9std", "vp9std_decode",
    ],
    "VK_KHR_video_decode_vp9": [
        "vp9std", "vp9std_decode",
    ],
    "VK_KHR_video_maintenance2": [
        "av1std", "h264std", "h265std", "vp9std",
    ],
];

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

    "VK_MAKE_VIDEO_STD_VERSION": true,

    "CAMetalLayer": true,
    "MTLDevice_id": true,
    "MTLCommandQueue_id": true,
    "MTLBuffer_id": true,
    "MTLTexture_id": true,
    "MTLSharedEvent_id": true,
    "IOSurfaceRef": true,

    "AHardwareBuffer": true,
    "ANativeWindow": true,

    "OHNativeWindow": true,
];