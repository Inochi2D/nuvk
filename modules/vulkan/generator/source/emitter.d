module emitter;

import std.algorithm;
import std.stdio;
import std.string;
import std.traits;

import registry;


/** 
 * Emits generated D files from a registry.
 */
class VkRegistryEmitter {
    private VkRegistry registry;

    private Emitter file;


    /** 
     * Construct an emitter from a registry and a file handle.
     * 
     * Params:
     *   registry = Source of the generated file.
     *   file = File handle where the generated file will be emitted.
     */
    this(VkRegistry registry, File file) {
        this.registry = registry;
        this.file = Emitter(file);
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
		file.writeln("extern (System) @nogc nothrow:");

		// Base types
		emitSection("Base types");

		foreach (basetype; registry.basetypes) {
			switch (basetype.type) {
				case "uint32_t":
				case "uint64_t":
					emitAlias(basetype.name, basetype.type);
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