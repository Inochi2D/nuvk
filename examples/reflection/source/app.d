import std.stdio : writefln, writeln;
import nuvk.spirv;
import numem.all;
import std.file : read;
import std.path;
import std.file : dirEntries, SpanMode, DirEntry;

void main(string[] args) {
	if (args.length > 1) {
		foreach(arg; args[1..$]) {
			auto entry = DirEntry(arg);
			if (!entry.isFile())
				continue;

			if (entry.isSymlink())
				continue;
			
			writeShaderInfo(arg, new NuvkSpirvModule(cast(ubyte[])read(arg)));
		}
		return;
	}

	foreach(DirEntry item; dirEntries(".", "*.spv", SpanMode.shallow, false)) {
		if (!item.isFile())
			continue;

		writeShaderInfo(item, new NuvkSpirvModule(cast(ubyte[])read(item)));
	}
}

void writeShaderInfo(string name, NuvkSpirvModule module_) {
	size_t i = 0;
	module_.parse();
	writefln("%s:", name);
	writefln("Entrypoiny: %s".indent(1), module_.getEntrypoint());
	writefln("Capability: %s".indent(1), module_.getCapability());
	writefln("Source Language: %s".indent(1), module_.getSourceLanguage());
	writefln("Execution Model: %s".indent(1), module_.getExecutionModel());
	writefln("Addressing Model: %s".indent(1), module_.getAddressingModel());
	writefln("Memory Model: %s".indent(1), module_.getMemoryModel());
	writefln("Execution Mode: %s".indent(1), module_.getExecutionMode());
	
	// List extended instructions
	writefln("Extended Instructions (%s):".indent(1), module_.getExtendedInstructionCount());
	foreach(key; module_.getExtendedInstructionKeys())
		writefln("%d - %s".indent(2), ++i, module_.getExtendedInstructionImport(key));
	
	// List extensions
	writefln("Extensions (%s):".indent(1), module_.getExtensionCount());
	foreach(extId; 0..module_.getExtensionCount())
		writefln("%d - %s".indent(2), extId+1, module_.getExtensionName(extId));

	writefln("");
}

/// Stupid indentation code.
string indent(string text, uint amount) {
	string out_;
	foreach(i; 0..amount) {
		out_ ~= "    ";
	}
	return out_ ~ text;
}
