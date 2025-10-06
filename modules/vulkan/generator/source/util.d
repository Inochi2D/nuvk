module util;


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