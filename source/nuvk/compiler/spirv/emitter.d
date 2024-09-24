module nuvk.compiler.spirv.emitter;
import nuvk.compiler.spirv.mod;
import nuvk.compiler.spirv.types;
import nuvk.compiler.spirv.defs;
import numem.all;

/**
    Emits a compiled Spirv module
*/
class SpirvEmitter {
private:
@nogc:
    SpirvModule module_;
    Stream stream;
    StreamWriter!(Endianess.littleEndian) writer;

    void emitImpl() {

        // Magic
        writer.write!uint(SPIRV_MAGIC);

        // Version (1.3, for now)
        writer.write!uint(0x00010300);


        writer.write!uint(0xAFAFAFAF);
    }

    void emitModule() {

    }


public:

    ~this() { }
    this() { }

    void emit(SpirvModule module_, Stream stream) {
        this.module_ = module_;
        this.stream = stream;
        this.writer = StreamWriter!(Endianess.littleEndian)(stream);

        this.emitImpl();
        
        // Deletes the writer, we're done.
        nogc_delete(writer);

        // Cleanup
        writer = null;
        stream = null;
        module_ = null;
    }
}