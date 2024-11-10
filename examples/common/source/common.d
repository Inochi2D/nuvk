module common;
import bindbc.sdl;
import nuvk;
import imagefmt;
import numem.all;
import inmath;

public import window;
public import inmath;
public import numem.all;
public import nuvk;

/**
    Initialises the example with a predefined set of arguments and such.
*/
Window exampleInit(nstring title, uint width, uint height, string[] args) {
    loadSDL();
    SDL_Init(SDL_INIT_EVERYTHING);

    NuvkPresentMode presentationMode = NuvkPresentMode.vsync;
    if (args.length > 1) {
        foreach(arg; args[1..$]) {
            if (arg == "--no-vsync")
                presentationMode = NuvkPresentMode.immediate;

            if (arg == "--triple-buffered")
                presentationMode = NuvkPresentMode.tripleBuffered;
        }
    }

    return nogc_new!Window(title, width, height, presentationMode);
}

/**
    Gets the runtime of the app in miliseconds.
*/
size_t getTicks() {
    return cast(size_t)SDL_GetTicks64();
}

/**
    Creates a shader from a vertex and fragment pair
*/
NuvkShaderProgram createRenderPipeline(NuvkDevice device, ubyte[] vertex, ubyte[] fragment) @nogc {
    NuvkShader vertexShader = nogc_new!NuvkShader(vertex);
    NuvkShader fragmentShader = nogc_new!NuvkShader(fragment);

    NuvkShaderProgram program = device.createShader();
    program.add(vertexShader);
    program.add(fragmentShader);
    program.link();
    return program;
}

/**
    Creates a texture from a PNG
*/
NuvkTexture createFromPNG(NuvkDevice device, ubyte[] pngdata) @nogc {
    IFImage img = read_image(pngdata, 4);    

    NuvkTextureDescriptor descriptor = NuvkTextureDescriptor(
        format: NuvkTextureFormat.rgba8UnormSRGB,
        type: NuvkTextureType.texture2d,
        extents: NuvkExtent3D!uint(
            width: img.w, 
            height: img.h, 
            depth: 1
        ),
        mipLevels: 1,
        arrayLayers: 1,
    );

    NuvkTexture texture = device.createTexture(descriptor);
    texture.upload(img.buf8, img.w*img.c, recti(0, 0, img.w, img.h), 0, 0);
    img.free();

    return texture;
}