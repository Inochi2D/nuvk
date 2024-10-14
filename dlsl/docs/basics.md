# DLSL Basics

DLSL is a subset of DLang used for writing shaders.
It is closely modelled after how Metal Shading Language is used.


# Types

DLSL has its own set of types, mainly modelled after the inmath library.  
There is additionally a `half` type for 16 bit floating point numbers.

|               Type | Description                          |
|-------------------:|--------------------------------------|
|             `bool` | Boolean value                        |
|            `ubyte` | Unsigned 8 bit integer               |
|             `byte` | Signed 8 bit integer                 |
|           `ushort` | Unsigned 16 bit integer              |
|            `short` | Signed 16 bit integer                |
|             `uint` | Unsigned 32 bit integer              |
|              `int` | Signed 32 bit integer                |
|            `ulong` | Unsigned 64 bit integer              |
|             `long` | Signed 64 bit integer                |
|             `half` | 16 bit floating point number         |
|            `float` | 32 bit floating point number         |
|           `double` | 64 bit floating point number         |
|            `vecX*` | Vector with X components             |
|           `matXY*` | X by Y Matrix                        |
|            `matX*` | X by X Matrix                        |
|              `T[]` | An array                             |
|        `textureXD` | A X-dimensional texture              |
|    `textureXDCube` | A X-dimensional texture              |
|          `sampler` | A texture sampler                    |

> ### Note
> **\*** The types `vec` and `mat` can additionally be suffixed with an identifier specializing it to a type.  
> If no specialization is given the `f` (32-bit float) specialization will be assumed.
>
> Additionally, `vec` and `mat`'s component count can be no smaller than `2` and no greater than `4`.

| Identifier | Compound Type |
|-----------:|---------------|
|        `h` | `half`        |
|        `f` | `float`       |
|        `d` | `double`      |
|        `b` | `byte`        |
|       `ub` | `ubyte`       |
|        `s` | `short`       |
|       `us` | `ushort`      |
|        `i` | `int`         |
|        `u` | `uint`        |
|        `l` | `long`        |
|       `ul` | `ulong`       |

Additionally the user may define `struct`s and `enum`s. Unions and classes are not allowed.

### Example

Following example shows a vertex shader which takes a struct as an input, and emits a struct as an output.  
Take note of the attributes in the structs, these determine how the data is accessed.

```d
struct VertexInput {
    @attribute(0) vec3 position;
    @attribute(1) vec2 uvs;
}

struct VertexOutput {
    @position vec3 position;
    vec2 uvs;
}

@vertex
VertexOutput vertex_main(in VertexInput vbuffer) {
    return VertexOutput(
        position: vbuffer.position,
        uvs: vbuffer.uvs
    );
}
```

## Arrays

DLSL allows the user to declare arrays, using the same syntax as in DLang.  
Depending on what type of buffer backs the array, there is some limitations.

Uniform buffers (marked with `const`) need to be statically sized at compile time.  
Storage buffers may be passed between stages and may be of a dynamic size.

When storage buffers are used **the host** defines the size of the buffer.  
If a storage buffer is declared in a struct it is required to be the last element,
unless it has a static size.

### Example
```d
struct Uniform0 {
    mat4 mvpMatrix;
}

@vertex
vec4 vertex_main(in vec3 position, @bind(0) const Uniform0 uniform) {
    return uniform.mvpMatrix * vec4(position, 1)
}
```

> ### Note
> If `@attribute` is not specified for an input to a vertex shader then the compiler will assume
> that the attributes are in the same order as they are declared, starting from 0.

# Attributes

DLSL defines a series of attributes which modify the behaviour of a type.  
DLang's UDA syntax used whenever an attribute takes an argument.

Here's the list of current attributes.

|           Attribute | Description                                                                 | Stages           |
|--------------------:|-----------------------------------------------------------------------------|------------------|
|                `in` | Variable is a input to the stage                                            | Any              |
|             `const` | Variable is a constant, or uniform.                                         | Any              |
|      `@bind(<int>)` | Sets the binding location of a shader resource                              | Any              |
|         `@vertexId` | Marks a variable/argument as a GPU passed vertex ID                         | Vertex           |
|   `@vertexInstance` | Marks a variable/argument as a GPU passed vertex instance ID                | Vertex           |
| `@attribute(<int>)` | Sets the attribute location of an input argument                            | Vertex           |
|         `@position` | Marks a variable as output position in slot 0                               | Vertex           |
|  `@position(<int>)` | Marks a variable as output position in the specified slot                   | Vertex           |
|           `@vertex` | Function is a vertex function                                               | Vertex           |
|         `@fragment` | Function is a fragment function                                             | Fragment         |
|             `@mesh` | Function is a mesh function                                                 | Mesh             |
|           `@kernel` | Function is a compute kernel                                                | Compute          |
