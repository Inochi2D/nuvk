module util;

public import util.cli;
public import util.omap;
public import util.logger;


/** 
 * "Consumes" the value of the first parameter by replacing it with a given
 *   value and returning its previously held value.
 * 
 * Params:
 *   var = Ref to the variable to modify.
 *   value = Value to set to var.
 * 
 * Returns: var's previously held value.
 */
T consume(T)(ref T var, T value = T.init) {
	auto prev = var;
	var = value;
	return prev;
}

/** 
 * Convert a name from camel-case to screaming-snake-case.
 * 
 * Params:
 *   name = A name in camel-case.
 * 
 * Returns: the same name but in screaming-snake-case.
 */
string camelToScreaming(string name) {
    import std.ascii;

    string result;

    foreach (i, c; name) {
        if (i > 0 && c.isUpper) {
            result ~= "_" ~ c.toUpper;
        } else {
            result ~= c.toUpper;
        }
    }

    return result;
}

///
@"camel to screaming works"
unittest {
    assert(camelToScreaming("VkResult"), "VK_RESULT");
}

/** 
 * Convert a name from snake-case to camel-case.
 * 
 * Params:
 *   name = A name in snake-case.
 * 
 * Returns: the same name but in camel-case.
 */
string snakeToCamel(string name) {
    import std.algorithm;
    import std.string;

    return name.split("_").map!capitalize.join();
}

/** 
 * Capitalize the first letter of a string.
 * 
 * Params:
 *   str = The string to capitalize
 * 
 * Returns: the given string with its first letter capitalized.
 */
string capitalize(string str) {
    import std.string;

    return str.empty ? str : str[0 .. 1].toUpper ~ str[1 .. $];
}