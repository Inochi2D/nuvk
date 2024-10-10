module nuvk.dlsl.compiler;
import numem.all;


/**
    Base class of all DLSL compilers.
*/
abstract
class Compiler {
@nogc:
private:
    // Buffer for bytecode.
    vector!uint buffer;

    // Bytecode writer
    BytecodeWriter writer;

protected:

    /**
        Gets the writer interface.
    */
    ref BytecodeWriter getWriter() {
        return writer;
    }

public:

    this() {
        writer = BytecodeWriter(this);
    }

    /**
        Compiles the code.
    */
    abstract uint[] compile();
}

/**
    The underlying bytecode writer used to emit
    SPIRV bytecode.
*/
struct BytecodeWriter {
@nogc:
private:
    Compiler compiler;
    vector!(uint)* buffer;
    
    /**
        Instantiates a bytecode writer for a buffer.
    */
    this(Compiler compiler) {
        this.buffer = &compiler.buffer;
        this.compiler = compiler;
    }

public:

    /**
        Appends data to the internal buffer.
    */
    void append(uint data) {
        *buffer ~= data;
    }
    
    /**
        Gets the size of the string when aligned 
        to the SPIRV boundaries.
    */
    size_t getAlignedSize(nstring str) {
        return str.length + (str.length % uint.sizeof);
    }

    /**
        Appends a string 
    */
    void append(nstring str) {
        uint out_;

        uint accumulator;
        foreach(char c; str) {
            out_ += (c << (accumulator++ * 8));

            // Handle accumulator reaching uint border
            if (accumulator == uint.sizeof) {
                this.append(out_);
                accumulator = 0;
                out_ = 0;
            }
        }
        this.append(out_);
    }

    /**
        Resets the internal buffer
    */
    void reset() {
        buffer.clear();
    }
}