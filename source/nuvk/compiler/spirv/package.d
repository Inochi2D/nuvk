module nuvk.compiler.spirv;
import nuvk.compiler.spirv.types;

/**
    Initialize SPIR-V compiler interface.
*/
extern(C)
void nuvkSpirvInitCompiler() @nogc {
    nuvkSpirvInitCompilerTypes();
}

/**
    Cleanup SPIR-V compiler interface.
*/
extern(C)
void nuvkSpirvCleanupCompiler() @nogc {
    nuvkSpirvCleanupCompilerTypes();
}