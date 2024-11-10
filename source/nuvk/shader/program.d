/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.shader.program;
import nuvk.shader.mapper;
import nuvk.shader.table;
import nuvk.shader;
import nuvk.device;
import nuvk.core;
import nuvk.buffer;
import spirv;
import numem.all;
import inmath;

public import spirv.variant : SpirvVarKind;
import std.traits : EnumMembers;

/**
    A linked shader program
*/
class NuvkShaderProgram : NuvkDeviceObject {
@nogc:
private:
    NuvkDescriptorMapper mapper;
    NuvkShaderArgumentTableManager tables;
    size_t linked = 0;
    NuvkShaderStage stages;
    vector!NuvkShader shaders;

    bool isGraphicsProgram() {
        return stages == 0 || (stages & NuvkShaderStage.graphics) > 0;
    }

    bool hasStage(NuvkShaderStage stage) {
        return (stages & stage) > 0;
    }

    /*
        Gets whether the specified shader is compatible with this program.
    */
    bool isShaderCompatible(NuvkShader shader) {
        return
            !this.hasStage(shader.getStage()) &&
            ((this.isGraphicsProgram() && shader.isGraphicsShader()) ||
            (stages == 0 || !this.isGraphicsProgram() && shader.getStage() == NuvkShaderStage.compute));
    }
    
    void buildArgumentTables(NuvkShader shader) {
        auto shaderType = shader.getType();
        auto module_ = shader.getModule();

        foreach(ref var; module_.getVariables()) {
            auto kind = var.getVarKind();

            switch(kind) {

                case SpirvVarKind.uniformBuffer:
                case SpirvVarKind.image:
                case SpirvVarKind.sampler:
                case SpirvVarKind.sampledImage:
                case SpirvVarKind.storageBuffer:
                    auto index = tables.findNextFreeIndex(shaderType, kind);

                    if (auto decor = module_.getDecorationFor(var.getId(), Decoration.Binding)) {
                        auto requestedIndex = decor.getArguments()[0];
                        if (!tables.findArgument(shaderType, kind, requestedIndex)) {
                            index = requestedIndex;
                        }
                    }

                    tables.addArgument(shaderType, kind, NuvkShaderArgumentTableEntry(
                        name: nstring(var.getName()),
                        index: index,
                        binding: var.getId()
                    ));
                    break;

                default:
                    break;
            }
        }

        // Then remap
        mapper.remap(shader);
        
        // Update all the bindings, we reused the binding to store the variable mapping.
        foreach(ref table; tables.getTables(shaderType)) {
            foreach(ref entry; table.entries) {
                if (auto var = module_.findVariable(entry.binding)) {
                    if (auto decor = module_.getDecorationFor(var.getId(), Decoration.Binding)) {
                        entry.binding = decor.getArguments()[0];
                        this.onBuildArgumentTable(shader, entry);
                    }
                }
            }
        }

        shader.emit();
        shader.reparse();
    }

    void buildVertexInputs(NuvkShader shader) {
        vertexInputs.clear();
        auto module_ = shader.getModule();
        auto variables = module_.getVariablesForKind(SpirvVarKind.stageInput);

        size_t offset;
        size_t location;
        foreach(ref SpirvVariable var; variables) {

            auto type = var.getType();
            size_t size = type.getSize();
            size_t bitwidth = type.getWidth();

            size_t locations = max(1, size/16);
            size_t subSize = size/locations;
            size_t elementCount = type.getComponents();
            location = module_.getDecorationArgFor(var.getId(), Decoration.Location);
            foreach(i; 0..locations) {
                NuvkSpirvVertexInput input;
                input.name = var.getName();
                input.location = cast(uint)(location+i);
                input.offset = cast(uint)offset;
                input.size = cast(uint)subSize;
                input.format = createVertexFormat(cast(uint)elementCount, cast(uint)bitwidth);

                offset += subSize;
                vertexInputs ~= input;
            }
        }

        foreach(ref input; vertexInputs) {
            input.stride = cast(uint)offset;
        }
    }

    void buildDescriptors() {
        descriptors.clear();
        static foreach(enumMember; EnumMembers!NuvkShaderType) {
            foreach(ref table; tables.getTables(enumMember)) {
                auto kind = table.bindingKind;
                foreach(ref entry; table.entries) {
                    descriptors ~= NuvkSpirvDescriptor(
                        stage: enumMember.toStage(),
                        name: entry.name,
                        kind: kind,
                        binding: entry.binding,
                    );
                }
            }
        }

    }

    // Bindings
    vector!NuvkSpirvDescriptor descriptors;
    vector!NuvkSpirvVertexInput vertexInputs;

protected:

    /**
        Gets the argument tables which onLink needs to fill out.
    */
    final
    NuvkShaderArgumentTableManager getArgumentTables() {
        return tables;
    }

    /**
        Implementation for argument table modifications.

        Called before linking, after SPIR-V transformation is completed.
    */
    void onBuildArgumentTable(NuvkShader shader, ref NuvkShaderArgumentTableEntry entry) { }

    /**
        Implementation for linking the provided shaders together.
    */
    abstract bool onLink(NuvkShader[] shaders);

public:

    ~this() {
        nogc_delete(descriptors);
        nogc_delete(vertexInputs);
    }

    /**
        Creates a new empty shader program.

        Use add to add shaders to the program.
    */
    this(NuvkDevice device) {
        super(device);
        this.tables = nogc_new!NuvkShaderArgumentTableManager();
        this.mapper = nogc_new!NuvkDescriptorMapper();
    }

    /**
        Creates a program from a nuvk shader library

        The library needs to be linkable, see [NuvkShaderLibrary.canDirectLink]
    */
    this(NuvkDevice device, NuvkShaderLibrary library) {
        super(device);
        nuvkEnforce(
            library.canDirectLink(),
            "Library is not linkable!"
        );

        // Add all shaders and link.
        auto shaders = library.getShaders();
        foreach(shader; shaders) {
            this.add(shader);
        }
        this.link();

        // Since we ended up being the owner of these objects,
        // Destroy them, local ref is gone after linking.
        nogc_delete(shaders);
    }

    /**
        Adds a shader to the program.
    */
    final
    ref auto add(NuvkShader shader) {
        nuvkEnforce(
            this.isShaderCompatible(shader),
            "Shader '{0}' is not compatible with this program.", shader.getName()
        );

        nuvkEnforce(
            linked == 0,
            "Program is already linked!"
        );

        // Add shader.
        shaders ~= shader.toUnique();
        stages |= shader.getStage();

        return this;
    }

    /**
        Links the specified shaders into a program. once linked
    */
    final
    void link() {
        nuvkEnforce(
            linked == 0,
            "Program is already linked!"
        );

        foreach(shader; shaders) {
            if (shader.getType() == NuvkShaderType.vertex)
                this.buildVertexInputs(shader);
            this.buildArgumentTables(shader);
        }
        this.buildDescriptors();

        nuvkEnforce(
            this.onLink(shaders[]), 
            "Failed to link shaders!"
        );
        this.linked = shaders.length;
        shaders.clear();
    }

    /**
        Gets an argument within the argument table.

        This is used by nuvk backends to map type indices into 
        API specific bindings.
    */
    final
    NuvkShaderArgumentTableEntry* findArgument(NuvkShaderType type, SpirvVarKind binding, uint index) {
        return tables.findArgument(type, binding, index);
    }

    /**
        Gets the vertex inputs
    */
    final
    NuvkSpirvVertexInput[] getVertexInputs() {
        return vertexInputs[];
    }

    /**
        Gets the descriptors of the program
    */
    final
    NuvkSpirvDescriptor[] getDescriptors() {
        return descriptors[];
    }

    /**
        Gets the stages in this shader.
    */
    final
    NuvkShaderStage getStages() {
        return stages;
    }

    /**
        Gets the amount of shaders linked.
    */
    final
    size_t getLinkedCount() {
        return linked;
    }
}