module util.cli;

import std.algorithm.searching;
import std.typecons : Nullable;

alias ArgKey = Nullable!string;
alias ArgValue = Nullable!string;

/** 
 * Parse an argument into its type, key, & value (if applicable).
 * 
 * Params:
 *   arg = Raw argument string, as taken from `main`.
 *   key = Resulting key (only valid for Long & Short arg types).
 *   value = Resulting value (only valid for Long, Short, & Value arg types).
 * 
 * Returns: the type of argument type.
 * 
 * See_Also:
 *   ArgType
 */
ArgType parseArg(string arg, out ArgKey key, out ArgValue value) {
	if (arg.startsWith("--")) {
		if (arg.length > "--".length) {
			parseKeyValue(arg["--".length..$], key, value);
			return ArgType.Long;
		} else {
			return ArgType.Forward;
		}
	} else if (arg.startsWith("-")) {
		if (arg.length > "-".length) {
			parseKeyValue(arg["-".length..$], key, value);
			return ArgType.Short;
		} else {
			return ArgType.Stream;
		}
	} else {
		value = arg;
		return ArgType.Value;
	}
}

/** 
 * Possible argument types to be parsed.
 * 
 * See_Also:
 *   parseArg
 */
enum ArgType {
	Value,
	Short,
	Long,
	Stream,
	Forward,
}

private void parseKeyValue(string arg, out ArgKey key, out ArgValue value) {
	const index = arg.countUntil("=");
	
	if (index != -1) {
		key = arg[0..index];
		value = arg[index + "=".length..$];
	} else {
		key = arg;
	}
}