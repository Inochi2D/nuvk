module omap;

import core.exception;

import std.range;


/** 
 * Associative array that preserves insertion order.
 */
struct OMap(K, V) {
    private V[] arr;

    private size_t[K] indices;

	private K[size_t] keys;


    @disable this(ref return scope inout(OMap) other) inout;

    this(return scope inout(OMap) other) inout {
        foreach (i, ref inout field; other.tupleof) {
            this.tupleof[i] = __rvalue(field);
        }
    }

    ref inout(V) opIndex(TK)(TK key) inout
        if (isTransKey!(TK, K))
    {
        if (auto index = key in indices) {
            return arr[*index];
        } else {
            throw new RangeError;
        }
    }

	auto opIndex() inout {
		return arr[];
	}

    ref V opIndexAssign(TK)(V value, TK key)
        if (isTransInsertKey!(TK, K))
    {
        if (auto index = key in indices) {
            arr[*index] = value;
            return arr[*index];
        } else {
            auto index = arr.length;
            arr ~= __rvalue(value);
            indices[key] = index;
            keys[index] = key;
            return arr.back;
        }
    }

    inout (V)* opBinaryRight(string op : "in", TK)(TK key) inout
        if (isTransKey!(TK, K))
    {
        if (auto index = key in indices) {
            return &arr[*index];
        } else {
            return null;
        }
    }

	int opApply(scope int delegate(ref V) dg) {
		int result = 0;

		foreach (ref item; arr) {
			result = dg(item);
			if (result) {
				break;
			}
		}

		return result;
	}

	int opApply(scope int delegate(ref const(size_t), ref inout(V)) dg) inout {
		int result = 0;

		foreach (i, ref item; arr) {
			result = dg(i, item);
			if (result) {
				break;
			}
		}

		return result;
	}

	int opApply(scope int delegate(ref const(K), ref inout(V)) dg) inout {
		int result = 0;

		foreach (i, ref item; arr) {
			result = dg(keys[i], item);
			if (result) {
				break;
			}
		}

		return result;
	}

    void clear() {
        arr = [];
        indices.clear();
		keys.clear();
    }

	@property bool empty() const => arr.empty;

    @property size_t length() const => arr.length;


    invariant() {
        assert(arr.length == indices.length && arr.length == keys.length);
    }
}

/** 
 * Check whether the given key can be used transparently to compare to another.
 * 
 * Params:
 *   TK = Key type to check for transparency.
 *   K = Key type to check against.
 */
template isTransKey(TK, K) {
    enum bool isTransKey = __traits(compiles, (TK key, size_t[K] keys) {
        key in keys;
    });
}

/** 
 * Check whether the given key can be used transparently to compare to another.
 * 
 * Params:
 *   TK = Key type to check for transparency.
 *   K = Key type to check against.
 */
template isTransInsertKey(TK, K) {
    enum bool canIndex = __traits(compiles, (TK key, size_t[K] indices) {
        key in indices;
    });

    enum bool canAssign = __traits(compiles, (TK key, size_t[K] indices, K[size_t] keys, size_t index) {
        indices[key] = index;
		keys[index] = key;
    });

    enum bool isTransInsertKey = canIndex && canAssign;
}

/** 
 * Utility for constructing an ordered map.
 */
OMap!(K, V) omap(K, V)() {
    return OMap!(K, V).init;
}

@"Ordered hashmap works"
unittest {
    auto map = omap!(string, int);

    map["key"] = 5;
    assert(map.length == 1);
    assert(map["key"] == 5);

    map.clear();
    assert(map.length == 0);
}