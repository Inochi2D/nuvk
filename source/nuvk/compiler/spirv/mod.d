module nuvk.compiler.spirv.mod;
import nuvk.compiler.spirv.defs;
import nuvk.compiler.spirv.types;
import numem.all;

/**
    A spirv module
*/
class SpirvModule {
@nogc:
private:
    struct SpirvEntrypoint {
        nstring name;
        SpirvFunction function_;
        SpirvExecutionModel model;
    }

    set!SpirvCapability             capabilities;
    set!nstring                     extensions;
    SpirvMemoryModel                memoryModel;

    weak_vector!SpirvEntrypoint     entryPoints;
    map!(nstring, SpirvFunction)    functions;

    weak_vector!SpirvType           usedTypes;
public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(capabilities);
        nogc_delete(extensions);
        nogc_delete(entryPoints);
        nogc_delete(functions);

        // Cleanup the types that this module references.
        foreach(type; usedTypes) {
            if (!type.isManaged()) {
                nogc_delete(type);
            }
        }
        nogc_delete(usedTypes);
    }

    /**
        Constructor
    */
    this() { }

    /**
        Gets or creates a function
    */
    SpirvFunction getFunction(nstring name) {
        
        // Create function if it doesn't exist.
        if (name !in functions) {
            functions[name] = nogc_new!SpirvFunction(this, name);
        }

        return functions[name];
    }

    void setEntrypoint(nstring name, SpirvExecutionModel model) {
        
        // Add entry point if function exists.
        if (name in functions) {

            // Don't allow setting entrypoint multiple times to the same name.
            foreach(entrypoint; entryPoints) {
                if (entrypoint.name == name) return;
            }

            entryPoints ~= SpirvEntrypoint(name, functions[name], model);
        }
    }

    /**
        Registers a type as used within the spirv module.
    */
    void registerType(SpirvType type) {
        foreach(type_; usedTypes) {
            if (type_ == type) return;
        }

        usedTypes ~= type;
    }
}