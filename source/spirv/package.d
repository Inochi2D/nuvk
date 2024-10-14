/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    SPIRV Utilities to parse and modify SPIRV source.
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