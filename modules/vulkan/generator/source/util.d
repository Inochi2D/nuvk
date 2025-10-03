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