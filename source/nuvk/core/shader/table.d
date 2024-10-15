/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.shader.table;
import nuvk.core.shader;
import numem.collections;
import numem.string;
import numem.core;
import spirv;

/**
    A manager for agument tables, a shader may have multiple tables
    per shader stage, as such this keeps track of stages and their tables.
*/
class NuvkShaderArgumentTableManager {
@nogc:
private:
    map!(NuvkShaderType, vector!(NuvkShaderArgumentTable*)) tables;

public:

    /**
        Adds an argument to the table
    */
    final
    void addArgument(NuvkShaderType type, SpirvVarKind binding, NuvkShaderArgumentTableEntry entry) {
        if (type !in tables) {
            tables[type] = vector!(NuvkShaderArgumentTable*)();
        }

        if (!this.findTable(type, binding)) {
            tables[type] ~= nogc_new!NuvkShaderArgumentTable(binding);
        }

        auto table = this.findTable(type, binding);
        table.entries ~= entry;
    }

    /**
        Finds an argument in the table.

        Returns null if there's no such argument in the table.
    */
    final
    NuvkShaderArgumentTableEntry* findArgument(NuvkShaderType type, SpirvVarKind binding, uint index) {
        auto table = this.findTable(type, binding);
        if (table) {
            foreach(ref item; table.entries) {
                if (item.index == index)
                    return &item;
            }
        }
        return null;
    }

    /**
        Gets tables for the specified shader type.
    */
    final
    NuvkShaderArgumentTable*[] getTables(NuvkShaderType type) {
        if (type in tables)
            return tables[type][];
        return [];
    }

    /**
        Finds a table by its type and binding point.
    */
    final
    NuvkShaderArgumentTable* findTable(NuvkShaderType type, SpirvVarKind binding) {
        foreach(ref table; this.getTables(type)) {
            if (table.bindingKind == binding)
                return table;
        }
        return null;
    }


    /**
        Gets the entry list for the specified table.
    */
    final
    NuvkShaderArgumentTableEntry[] getArguments(NuvkShaderType type, SpirvVarKind binding) {
        auto table = this.findTable(type, binding);
        if (table)
            return table.entries[];
        return [];
    }

    /**
        Finds the next free index in the argument table.
    */
    uint findNextFreeIndex(NuvkShaderType type, SpirvVarKind binding) {
        uint idx = 0;
        while (findArgument(type, binding, idx)) {
            idx++;
        }
        return idx;
    }
}

/**
    A shader argument table contains the binding points
    of uniform values that can be passed to a shader.
*/
struct NuvkShaderArgumentTable {
@nogc:

    /**
        The kind of binding this table describes.
    */
    SpirvVarKind bindingKind;

    /**
        The entries in the table.
    */
    vector!NuvkShaderArgumentTableEntry entries;
}

/**
    An entry in a shader's argumemt table.
*/
struct NuvkShaderArgumentTableEntry {
@nogc:

    /**
        Name of the shader variable.
    */
    nstring name;

    /**
        The table index.
    */
    uint index;

    /**
        The ID of this entry.
    */
    uint binding;
}