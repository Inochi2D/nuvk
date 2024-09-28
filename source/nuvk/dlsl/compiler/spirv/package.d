/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

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