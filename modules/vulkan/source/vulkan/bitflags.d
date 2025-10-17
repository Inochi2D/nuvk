/** 
 * Utility type to wrap "Flags" bitmasks.
 */
module vulkan.bitflags;
import vulkan.core;

alias VkBitFlags(E)   = VkBitFlagsBase!(VkFlags, E);
alias VkBitFlags64(E) = VkBitFlagsBase!(VkFlags64, E);

struct VkBitFlagsBase(T, E) if (E.sizeof == T.sizeof) {
    T inner;
    alias inner this;

    this(T value) {
        inner = value;
    }

    this(E value) {
        inner = cast(T) value;
    }

    pragma(inline, true)
    VkBitFlagsBase opBinary(string op : "|")(E other) const {
        return VkBitFlagsBase(inner | cast(T) other);
    }

    pragma(inline, true)
    VkBitFlagsBase opBinary(string op : "|")(VkBitFlagsBase other) const {
        return VkBitFlagsBase(inner | other.inner);
    }

    pragma(inline, true)
    VkBitFlagsBase opBinary(string op : "&")(E other) const {
        return VkBitFlagsBase(inner & cast(T) other);
    }

    pragma(inline, true)
    VkBitFlagsBase opBinary(string op : "&")(VkBitFlagsBase other) const {
        return VkBitFlagsBase(inner & other.inner);
    }

    pragma(inline, true)
    auto opOpAssign(string op : "|")(E other) {
        inner |= cast(T) other;
        return this;
    }

    pragma(inline, true)
    auto opOpAssign(string op : "|")(VkBitFlagsBase other) {
        inner |= other.inner;
        return this;
    }

    pragma(inline, true)
    auto opOpAssign(string op : "&")(E other) {
        inner &= cast(T) other;
        return this;
    }

    pragma(inline, true)
    auto opOpAssign(string op : "&")(VkBitFlagsBase other) {
        inner &= other.inner;
        return this;
    }
}

@"VkBitFlags work"
unittest {
    enum NumberFlagBits : VkFlags {
        One   = 0b001,
        Two   = 0b010,
        Three = 0b100,
    }
    alias NumberFlags = VkBitFlags!NumberFlagBits;

    NumberFlags flags = NumberFlagBits.One | NumberFlagBits.Three;
    assert(flags == 0b101);
}