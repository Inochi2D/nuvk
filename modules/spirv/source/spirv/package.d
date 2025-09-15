/**
    SPIR-V Parsing, Reflection and Compilation.
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module spirv;

public import spirv.spv;
public import spirv.mod;
public import spirv.variant;
public import spirv.reflection;
public import spirv.instr;


/**
    A SPIR-V ID
*/
alias SpirvID = uint;

/**
    ID value used to indicate that a variant has no ID.
*/
enum SPIRV_NO_ID = SpirvID.max;

/**
    Magic number for the SPIR-V generator included in nuvk.
*/
enum SpirvGeneratorMagicNumber = 45;

/**
    Size of the SPIR-V header in WORDs
*/
enum SpirvHeaderSize = 5;