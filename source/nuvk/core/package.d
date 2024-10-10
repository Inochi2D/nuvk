/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core;
import std.traits;

public import nuvk.core.context;
public import nuvk.core.buffer;
public import nuvk.core.device;
public import nuvk.core.shader;
public import nuvk.core.texture;
public import nuvk.core.buffer;
public import nuvk.core.sync;
public import nuvk.core.queue;
public import nuvk.core.cmdbuffer;
public import nuvk.core.surface;
public import nuvk.core.devinfo;
public import nuvk.core.logging;
public import nuvk.core.staging;

import numem.string;

/**
    Base type of Nuvk objects.
*/
abstract
class NuvkObject {
@nogc:
private:
    void* handle;
    nstring name;

protected:

    /**
        Sets the internal handle
    */
    final
    void setHandle(void* handle) {
        this.handle = handle;
    }

    /**
        Called by the implementation when the name is changed.

        By default this does nothing, but backends should setup
        debug names using this function for debuggers like RenderDoc.
    */
    void onNameChanged() { }

public:

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
    ref void* getHandle() {
        return handle;
    }

    /**
        Gets the handle cast to the specified type.
    */
    ref auto getHandle(T)() {
        return cast(T)handle;
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