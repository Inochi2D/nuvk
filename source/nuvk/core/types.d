/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.types;
import numem.core.memory;
import numem.string;
import std.traits;

// NOTE: NuvkHandle and NuvkHandleShared are not compatible,
// as such to help with compile time error checking,
// these opqaue structs are used.

struct _NuvkHandleT; // @suppress(dscanner.style.phobos_naming_convention)
struct _NuvkHandleSharedT; // @suppress(dscanner.style.phobos_naming_convention)

/**
    A handle to a backend structure used by the underlying graphics API.

    This pointer is only meaningful if you know what graphics API is being used.
*/
alias NuvkHandle = _NuvkHandleT*;

/**
    A handle to a shared resource which may be passed between running processes.

    Check `NuvkDeviceFeatures.sharing` to find out whether shared handles are supported.
*/
alias NuvkHandleShared = _NuvkHandleSharedT*;

/**
    Base type of all Nuvk objects.
*/
abstract
class NuvkObject {
@nogc:
private:
    NuvkHandle handle = null;
    nstring name;

protected:

    /**
        Sets the internal handle
    */
    final
    void setHandle(NuvkHandle handle) {
        this.handle = handle;
    }

    /**
        Sets the internal handle
    */
    final
    void setHandle(void* handle) {
        this.handle = cast(NuvkHandle)handle;
    }

    /**
        Called by the implementation when the name is changed.

        By default this does nothing, but backends should setup
        debug names using this function for debuggers like RenderDoc.
    */
    void onNameChanged() { }

public:

    /**
        Destructor
    */
    ~this() { }

    /**
        constructor
    */
    this(nstring name = nstring.init) {
        this.name = name;
    }

    /**
        Gets the user specified name of the object
    */
    final
    nstring getName() {
        return name;
    }

    /**
        Sets the name of the object
    */
    final 
    ref auto setName(nstring name) {
        this.name = name;
        this.onNameChanged();
        return this;
    }

    /**
        Gets the internal handle

        This handle is owned by the object and should NOT be freed
        by the caller.
    */
    final
    ref NuvkHandle getHandle() {
        return handle;
    }

    /**
        Gets the handle cast to the specified type.
    */
    ref auto getHandle(T)() {
        return cast(T)handle;
    }

    /**
        Checks whether a nuvk object is the same as another
        by comparing the backing handles.
    */
    bool opEquals(inout(NuvkObject) other) inout {
        return this.handle is other.handle;
    }
}

/**
    Represents a range
*/
struct NuvkRange(T) if (isNumeric!T) {
@nogc:
    /**
        Start of the range
    */
    T start;
    
    /**
        End of the range
    */
    T end;


    /**
        Gets the length of the range
    */
    T getLength() {
        return (end-start);
    }
}

/**
    A RGB color
*/
struct NuvkColor {
@nogc:
    union {
        float[4] colorData;
        struct {
            float r;
            float g;
            float b;
            float a;
        }
    }
}

/**
    A 3D extent
*/
struct NuvkExtent3D(T) if (isNumeric!T) {
@nogc:
    T width;
    T height;
    T depth;
}

/**
    Clearing value.
*/
struct NuvkClearValue {
@nogc:
    this(float r, float g, float b, float a) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    this(float depth, uint stencil) {
        this.depth = depth;
        this.stencil = stencil;
    }

    union {
        struct {
            float r;
            float g;
            float b;
            float a;
        }
        struct {
            float depth;
            uint stencil;
        }
    }
}