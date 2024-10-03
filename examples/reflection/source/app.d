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
	module_.parse();

	auto caps = module_.getCapabilities();
	auto execModes = module_.getExecutionModes();

	writefln("%s:", name);
	writefln("Capabilities (%d):".indent(1), caps.length);
	foreach(i, cap; caps) writefln("%d - %s".indent(2), i, cap);
	writefln("Execution Modes (%d):".indent(1), execModes.length);
	foreach(i, mode; execModes) writefln("%d - %s".indent(2), i, mode);
	writefln("Execution Model: %s".indent(1), module_.getExecutionModel());
	writefln("Entrypoint: %s".indent(1), module_.getEntrypoint());
	writeln("Descriptor sets:".indent(1));

	foreach(set; module_.getSetIter()) {
		writefln("Set (%d):".indent(1), set);
		auto descriptorList = module_.getDescriptors(set);
		foreach(i, ref descriptor; descriptorList) {
			writefln("%d - %s".indent(2), i, descriptor.name);
		}
	}


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
