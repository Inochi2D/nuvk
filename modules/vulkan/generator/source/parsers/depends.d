/**
 * Sub-parser for the contents of `depends` attributes in Vulkan XML.
 */
module parsers.depends;

import std.algorithm;
import std.array;
import std.range;
import std.regex;
import std.sumtype;

import registry;


/** 
 * Parse the contents of a `depends` attribute.
 * 
 * Params:
 *   depends = Contents of a `depends` attribute.
 * 
 * Returns: a VkDepends instance.
 */
VkDepends parseDependsString(xmlstring depends) {
    return VkDependsParser(depends).parse();
}

@"parsing depends string works"
unittest {
    auto depends = "((VK_KHR_get_physical_device_properties2,VK_VERSION_1_1)+VK_KHR_depth_stencil_resolve),VK_VERSION_1_2";
    auto result = parseDependsString(depends);

    assert(result.isOp);
    assert(result.op.operator == ',');
    assert(result.op.lhs.isOp);
    assert(result.op.lhs.op.operator == '+');
    assert(!result.op.rhs.isOp);
    assert(result.op.rhs.name == "VK_VERSION_1_2");
}

/** 
 * Parser of depends expressions.
 */
struct VkDependsParser {
    private Token[] tokens;

    /** Copy-construction forbidden. */
    @disable this(ref return scope VkDependsParser other);

    /** Move-construction forbidden. */
    @disable this(return scope VkDependsParser other);

    /** 
     * Construct a depends expression parser from an XML string.
     * 
     * Params:
     *   depends = The contents of a `depends` attribute.
     */
    this(xmlstring depends) {
        while (!depends.empty) {
            if (depends[0] in ops) {
                tokens ~= Token(depends[0]);
                depends.popFront();
            } else if (auto match = depends.matchFirst(regex(`^[a-zA-Z0-9_]+`))) {
                tokens ~= Token(match.front);
                depends = depends[match.front.length .. $];
            } else {
                assert(false, depends);
            }
        }
    }

    VkDepends parse() {
        return matchAny();
    }

    private VkDepends matchAny() {
        if (auto result = matchOr()) {
            return result;
        } else if (auto result = matchAnd()) {
            return result;
        } else if (auto result = matchName()) {
            return result;
        } else {
            return null;
        }
    }

    private VkDepends matchParensOrName() {
        if (auto result = matchParens()) {
            return result;
        } else if (auto result = matchName()) {
            return result;
        } else {
            return null;
        }
    }

    private VkDepends matchParensOrAny() {
        if (auto result = matchParens()) {
            return result;
        } else if (auto result = matchAny()) {
            return result;
        } else {
            return null;
        }
    }

    private VkDepends matchName() {
        if (tokens.empty) {
            return null;
        } else if (auto name = tokens.front.tryName) {
            tokens.popFront();
            return new VkDepends(name.text.idup);
        } else {
            return null;
        }
    }

    private VkDepends matchAnd() => matchOp('+');

    private VkDepends matchOr() => matchOp(',');

    private VkDepends matchOp(char op) {
        auto checkpoint = tokens;

        if (auto lhs = matchParensOrName()) {
            if (tokens.empty) {
                goto fail;
            } else if (tokens.front.hasOp(op)) {
                tokens.popFront();
                if (auto rhs = matchParensOrName()) {
                    return new VkDepends(op, lhs, rhs);
                }
            }
        }

     fail:
        tokens = checkpoint;
        return null;
    }

    private VkDepends matchParens() {
        auto checkpoint = tokens;

        if (tokens.empty) {
            goto fail;
        } else if (tokens.front.hasOp('(')) {
            tokens.popFront();
            if (auto result = matchAny()) {
                if (tokens.empty) {
                    goto fail;
                } else if (tokens.front.hasOp(')')) {
                    tokens.popFront();
                    return result;
                }
            }
        }

     fail:
        tokens = checkpoint;
        return null;
    }
}

/** 
 * Token type containing a sum type of all possible token subtypes.
 */
private struct Token {
    SumType!(NameTk, OpTk) inner;

    alias inner this;

    /** 
     * Construct a name token from a string.
     * 
     * Params:
     *   name = String slice from the contents of a `depends` attribute.
     */
    this(xmlstring name) {
        inner = NameTk(name);
    }

    /** 
     * Construct an operator token from a character.
     * 
     * Params:
     *   op = Which character this operator token represents.
     */
    this(char op) in (op in ops) {
        inner = cast(OpTk) op;
    }

    @property bool isName() const => inner.match!(
        token => is(typeof(token) : NameTk)
    );

    @property bool isOp() const => inner.match!(
        token => is(typeof(token) : OpTk)
    );

    bool hasOp(char op) const => inner.match!(
        (const ref OpTk token) => token == op, _ => false,
    );

    ref inout(NameTk) toName() inout => inner.match!(
        function ref inout(NameTk)(ref inout(NameTk) name) => name, _ => assert(false),
    );

    ref inout(OpTk) toOp() inout => inner.match!(
        function ref inout(OpTk)(ref inout(OpTk) op) => op, _ => assert(false),
    );

    inout(NameTk*) tryName() inout => inner.match!(
        function inout(NameTk*)(ref inout(NameTk) name) => &name, _ => null,
    );

    inout(OpTk*) tryOp() inout => inner.match!(
        function inout(OpTk*)(ref inout(OpTk) op) => &op, _ => null,
    );
}

/** 
 * Name token, contains its own text.
 */
private struct NameTk {
    xmlstring text;
}

/** 
 * Operator token, contains its own character.
 */
private enum OpTk : char {
    ParOpen = '(',
    ParClose = ')',
    And = '+',
    Or = ',',
}

/** 
 * YXML uses this as a string type for @nogc reasons.
 */
private alias xmlstring = const(char)[];

/** 
 * Map of valid operators.
 */
private bool[char] ops = [
    '(': true,
    ')': true,
    '+': true,
    ',': true,
];