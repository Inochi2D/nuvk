/**
 * Dirty hacks and fixes to dumb problems.
 */
module vulkan.patches;

/**
 * Template that provides a workaround for issue 20473 in D 2.111
 *   https://github.com/dlang/dmd/issues/20473
 */
mixin template DMD20473() {
    static if (__VERSION__ <= 2111) {
        extern(D) size_t toHash() const {
            size_t h = 0;
            static foreach(i, member; typeof(this).tupleof) {
                {   
                    const typeof(member) tmp = member;
                    h = h * 33LU + typeid(typeof(typeof(this).tupleof[i])).getHash(&tmp);
                }
            }
            return h;
        }
    }
}