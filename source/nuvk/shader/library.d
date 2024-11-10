/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.shader.library;
import nuvk.shader;
import nuvk.core;
import numem.all;

enum NUVK_SHADER_LIBRARY_MAGIC = "NUVKLIB0";

private {
    
    enum errMsgFailedReading = "Failed reading section {0}.";

    alias Reader = StreamReader!(Endianess.littleEndian);
    alias Writer = StreamWriter!(Endianess.littleEndian);

    struct LibSection {
        nstring name;
        NuvkShaderType type;
        vector!uint bytecode;
    }
}

/**
    A Nuvk Shader Library.

    Shader libraries allows you to combine multiple seperate SPIRV
    shader files into a single file which can be consumed by Nuvk.
*/
class NuvkShaderLibrary : NuvkObject {
@nogc:
private:
    vector!LibSection sections;

    void checkMagicBytes(ref Reader reader) {
        nstring magic = nstring(NUVK_SHADER_LIBRARY_MAGIC.length);
        auto read = reader.read(magic, magic.length);

        // Length check
        nuvkEnforce(
            read == NUVK_SHADER_LIBRARY_MAGIC.length,
            "File too small to be a NUVK Shader Library!"
        );

        // Magic byte check
        nuvkEnforce(
            magic == NUVK_SHADER_LIBRARY_MAGIC,
            "File is not a NUVK Shader Library!"
        );
    }

    T tryRead(T)(ref Reader reader, size_t section) {
        T tmp;
        nuvkEnforce(reader.read!T(tmp), errMsgFailedReading, section);
        return tmp;
    }

    T tryRead(T)(ref Reader reader, size_t length, size_t section) {
        T tmp = T(length);
        nuvkEnforce(reader.read!T(tmp, length), errMsgFailedReading, section);
        return tmp;
    }

    bool parseSection(ref Reader reader, size_t section) {

        // Load name
        uint nameLength = this.tryRead!uint(reader, section);
        nstring name = this.tryRead!nstring(reader, nameLength, section);
        
        // Load code info
        ubyte codeType = this.tryRead!ubyte(reader, section);
        uint codeLength = this.tryRead!uint(reader, section);
        
        // Load bytecode
    	vector!uint bytecode = this.tryRead!(vector!uint)(reader, codeLength, section);
        sections ~= LibSection(
            name: name,
            type: cast(NuvkShaderType)codeType,
            bytecode: bytecode
        );

        return true;
    }

    void parse(ref Stream stream) {
        
        // Seek back to previous position once done.
        size_t pos = stream.tell();
        scope(exit) stream.seek(pos);

        Reader reader = nogc_new!Reader(stream);
        this.checkMagicBytes(reader);

        // Read all sections
        size_t eof = stream.length();
        size_t section;
        while(stream.tell() != eof) {
            if(!parseSection(reader, section)) {
                break;
            }
            section++;
        }

        nogc_delete(reader);
    }

    void emit(ref Stream stream) {
        Writer writer = nogc_new!Writer(stream);
        writer.write(NUVK_SHADER_LIBRARY_MAGIC);
        
        foreach(ref section; sections) {
            writer.write!uint(cast(uint)section.name.length);
            writer.write(section.name);

            writer.write!ubyte(cast(ubyte)section.type);
            writer.write!uint(cast(uint)section.bytecode.length);
            writer.write(section.bytecode);
        }
    }

public:

    /**
        Creates a shader library from a stream.

        Once reading is done the stream will be returned
        to the same state it was when reading began.
    */
    this(Stream stream) {
        this.parse(stream);
    }

    /**
        Creates an empty shader library.
    */
    this() { }

    /**
        Adds a shader to the library
    */
    final
    void add(nstring name, NuvkShader shader) {
        foreach(ref section; sections) {
            nuvkEnforce(
                name != section.name, 
                "Shader with name '{0}' already exists in the library!",
                name
            );
        }

        sections ~= LibSection(
            name: name,
            type: shader.getType(),
            bytecode: vector!uint(shader.getBytecode()) 
        );
    }

    /**
        Gets whether a shader with the specified name exists
        within the library.
    */
    final
    bool hasShader(nstring name) {
        foreach(ref section; sections) {
            if (section.name == name)
                return true;
        }
        return false;
    }

    /**
        Removes a shader from the libraryu
    */
    final
    void remove(nstring name) {
        foreach(i, ref section; sections) {
            if (section.name == name) {
                sections.remove(i);
                return;
            }
        }
    }

    /**
        Finds a shader within this library by name and returns it.

        If no shader with the given name was found, returns null.
    */
    final
    NuvkShader createShader(nstring name) {
        foreach(ref section; sections) {
            if (section.name == name) {
                return nogc_new!NuvkShader(section.bytecode[]);
            }
        }

        return null;
    }

    /**
        Writes library to the specified stream
    */
    final
    void writeTo(Stream stream) {
        
        // Skip empty library.
        if (sections.length == 0)
            return;

        this.emit(stream);
    }

    /**
        Gets whether the library can be directly linked
        without having to extract individual functions from it.
    */
    final
    bool canDirectLink() {
        set!NuvkShaderType seen;
        foreach(ref section; sections) {
            if (section.type in seen)
                return false;

            seen.insert(section.type); 
        }
        return true;
    }

    /**
        Instantiates all the shaders within the library and returns them.
    */
    final
    vector!NuvkShader getShaders() {
        vector!NuvkShader shaders;
        foreach(ref section; sections) {
            shaders ~= nogc_new!NuvkShader(section.bytecode[]);
        }

        return shaders;
    }
}