module emitter;

import std.algorithm;
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

		// Defines
		emitSection("Defines");

		file.writeln("import vulkan.defines;");
		foreach (define; registry.defines) {
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

		// Base types
		emitSection("Base types");

		foreach (basetype; registry.basetypes) {
			switch (basetype.type) {
				case "uint32_t":
					emitAlias(basetype.name, "uint");
					break;

				case "uint64_t":
					emitAlias(basetype.name, "ulong");
					break;

				default:
					break;
			}
		}

		// Opaque handles
		emitSection("Opaque handles");

		foreach (handle; registry.handles) {
			if (handle.comment && handle.name != "VkInstance") {
				emitSection(handle.comment);
			}

			if (handle.alias_.empty) {
				emitHandle(handle.name);
			} else {
				emitAlias(handle.name, handle.alias_);
			}
		}
    }

	private void emitHandle(string name) {
		file.writefln!"alias %s = OpaqueHandle!%s;"(name, name);
	}

	private void emitAlias(string lhs, string rhs) {
		file.writefln!"alias %s = %s;"(lhs, rhs);
	}

	private void emitEnum(string lhs, string rhs) {
		file.writefln!"enum %s = %s;"(lhs, rhs);
	}

	private void emitSection(string label) {
		file.writefln!"\n// %s\n"(label);
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