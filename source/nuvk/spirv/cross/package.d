module nuvk.spirv.cross;
import bindbc.loader;

public import nuvk.spirv.cross.types;
public import nuvk.spirv.cross.funcs;
public import nuvk.spirv.cross.spv;

enum SpirvCrossSupport {
    noLibrary,
    badLibrary,
    yes
}

private {
    SharedLib lib;
}

@nogc nothrow:

bool isSpirvCrossLoaded() {
    return lib != invalidHandle;
}


SpirvCrossSupport loadSpirvCross() {
    version (Windows) {
        const(char)[][1] libNames =
            [
                "spirv-cross-c-shared.dll"
            ];
    } else version (OSX) {
        const(char)[][1] libNames =
            [
                "libspirv-cross-c-shared.dylib"
            ];
    } else version (Posix) {
        const(char)[][2] libNames =
            [
                "libspirv-cross-c-shared.so",
                "libspirv-cross-c-shared.so.0",
            ];
    } else
        static assert(0, "SPIRV-Cross is not yet supported on this platform.");

    SpirvCrossSupport ret;
    foreach (name; libNames) {
        ret = loadSpirvCross(name.ptr);
        if (ret != SpirvCrossSupport.noLibrary)
            break;
    }
    return ret;
}

SpirvCrossSupport loadSpirvCross(const(char)* libName) {
    SpirvCrossSupport loadedId;

    lib = load(libName);
    if (lib == invalidHandle) {
        resetErrors();
        return SpirvCrossSupport.noLibrary;
    }

    int loaded;
    loadedId = SpirvCrossSupport.badLibrary;
    import std.algorithm.searching : startsWith;
    import std.traits : getUDAs;

    static foreach (m; __traits(allMembers, nuvk.spirv.cross.funcs)) {
        static if (getUDAs!(__traits(getMember, nuvk.spirv.cross.funcs, m), BindAs).length > 0) {
            lib.bindSymbol(
                cast(void**)&__traits(getMember, nuvk.spirv.cross.funcs, m),
                getUDAs!(__traits(getMember, nuvk.spirv.cross.funcs, m), BindAs)[0].as
            );
            loaded++;
        }
    }

    loaded -= errorCount();
    if (loaded <= 0)
        return SpirvCrossSupport.badLibrary;

    loadedId = SpirvCrossSupport.yes;
    return loadedId;
}