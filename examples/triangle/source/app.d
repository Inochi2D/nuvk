/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Triangle example app
*/
module app;

import nuvk;
import numem.all;
import bindbc.sdl;
import sdl.video;
import sdl.vulkan;
import core.stdc.stdio : printf;
import inmath;

ubyte[] vertexShaderSrc = cast(ubyte[])import("shaders/triangle_vert.spv");
ubyte[] fragmentShaderSrc = cast(ubyte[])import("shaders/triangle_frag.spv");

/**
    A window
*/
class Window {
@nogc:
private:
    // Nuvk
    NuvkContext context;
    NuvkDevice device;
    NuvkSurface surface;

    // Window info
    nstring title;
    uint width, height;
    SDL_Window* window;

    // Window state
    bool closeRequested;

    void createWindow(nstring title, uint width, uint height) {
        window = SDL_CreateWindow(title.toCString(), SDL_WINDOWPOS_CENTRED, SDL_WINDOWPOS_CENTRED, width, height, SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE );
    }

    void createNuvk(NuvkPresentMode presentationMode) {
        
        // Create context
        {
            uint extensionCount;
            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, null);
            auto sdlRequiredExtensions = weak_vector!(const(char)*)(extensionCount);

            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, sdlRequiredExtensions.data());
            context = nuvkCreateContext(NuvkContextType.vulkan, sdlRequiredExtensions[]);
        }

        // Create device
        {
            auto selectedDevice = context.getDefaultDevice();
            device = context.createDevice(selectedDevice);
        }

        // Create surface
        {
            void* surfaceAddr;
            enforce(
                SDL_Vulkan_CreateSurface(window, context.getHandle(), &surfaceAddr) == SDL_TRUE,
                nstring("Failed to create Vulkan surface")
            );
            surface = device.createSurfaceFromHandle(surfaceAddr, presentationMode, NuvkTextureFormat.bgra8UnormSRGB);
        }
    }

public:
    this(nstring title, uint width, uint height, NuvkPresentMode presentationMode) {
        this.title = title;
        this.width = width;
        this.height = height;
        this.createWindow(title, width, height);
        this.createNuvk(presentationMode);
        this.closeRequested = false;
    }

    bool isCloseRequested() {
        return closeRequested;
    }

    void updateEvents() {
        SDL_Event event;
        SDL_PumpEvents();

        while(SDL_PollEvent(&event)) {
            switch(event.type) {

                case SDL_QUIT:
                    closeRequested = true;
                    break;

                case SDL_WINDOWEVENT:
                    switch(event.window.event) {
                        default:
                            break;
                        case SDL_WINDOWEVENT_RESIZED:
                        case SDL_WINDOWEVENT_RESTORED:
                            surface.notifyChanged();
                            break;
                    }
                    break;

                default:
                    break;
            }
        }
    }

    /**
        Gets the device being rendered with.
    */
    ref NuvkDevice getDevice() {
        return device;
    }

    /**
        Gets the surface
    */
    ref NuvkSurface getSurface() {
        return surface;
    }

    /**
        Gets the size of the framebuffer
    */
    vec2u getFramebufferSize() {
        int w, h;
        SDL_Vulkan_GetDrawableSize(window, &w, &h);
        return vec2u(w, h);
    }
}

/**
    Main function.
*/
void main(string[] args) @nogc {
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

    Window myWindow = nogc_new!Window(nstring("Hello Triangle"), 640, 480, presentationMode);

    NuvkDevice device = myWindow.getDevice();
    NuvkSwapchain swapchain = myWindow.getSurface().getSwapchain();

    NuvkShader vertexShader = device.createShader(nogc_new!NuvkSpirvModule(vertexShaderSrc), NuvkShaderStage.vertex);
    NuvkShader fragmentShader = device.createShader(nogc_new!NuvkSpirvModule(fragmentShaderSrc), NuvkShaderStage.fragment);

    vec2[3] vertices = [
        vec2(0.0, -0.5),
        vec2(0.5, 0.5),
        vec2(-0.5, 0.5)
    ];

    NuvkBuffer vertexBuffer = device.createBuffer(NuvkBufferUsage.vertex | NuvkBufferUsage.transferSrc, NuvkDeviceSharing.deviceShared, vec2.sizeof*3);
    enforce(
        vertexBuffer.upload!vec2(vertices),
        nstring("Failed to upload data!")
    );

    NuvkGraphicsPipelineDescriptor graphicsShaderDesc;
    graphicsShaderDesc.vertexShader = vertexShader;
    graphicsShaderDesc.fragmentShader = fragmentShader;
    graphicsShaderDesc.attributes ~= NuvkVertexAttribute(
        0,
        0,
        0,
        NuvkVertexFormat.vec2
    );

    graphicsShaderDesc.bindings ~= NuvkVertexBinding(
        0,
        vec2.sizeof,
        NuvkInputRate.vertex
    );
    NuvkPipeline shader = device.createGraphicsPipeline(graphicsShaderDesc);

    NuvkCommandQueue queue = device.createQueue();
    NuvkCommandBuffer cmdbuffer = queue.createCommandBuffer();

    double ticks = cast(double)SDL_GetTicks64();


    while(!myWindow.isCloseRequested()) {
        myWindow.updateEvents();
        ticks = cast(double)SDL_GetTicks64();

        if (NuvkTextureView nextImage = swapchain.getNext()) {
            float r = (1+sin(ticks/1000))/2;
            float g = (1+cos(ticks/1000))/2;
            float b = (1+sin(r+g))/2;

            NuvkRenderPassAttachment colorAttachment;
            colorAttachment.texture = nextImage;
            colorAttachment.loadOp = NuvkLoadOp.clear;
            colorAttachment.storeOp = NuvkStoreOp.store;
            colorAttachment.clearValue = NuvkClearValue(0, 0, 0, 1);

            NuvkRenderPassDescriptor renderPassDescriptor;
            renderPassDescriptor.colorAttachments ~= colorAttachment;
            
            if (NuvkRenderEncoder renderPass = cmdbuffer.beginRenderPass(renderPassDescriptor)) {
                renderPass.setPipeline(shader);
                renderPass.setVertexBuffer(vertexBuffer, 0, 0);
                renderPass.draw(NuvkPrimitive.triangles, 0, 3);
                renderPass.endEncoding();
            }

            cmdbuffer.commit();
            cmdbuffer.present(myWindow.getSurface());
            cmdbuffer.awaitCompletion();
        }
    }
}