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

import std.stdio;

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
            NuvkContextDescriptor descriptor;
            descriptor.type = NuvkContextType.vulkan;

            uint extensionCount;
            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, null);
            descriptor.vulkan.requiredExtensions = weak_vector!(const(char)*)(extensionCount);
            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, descriptor.vulkan.requiredExtensions.data());

            context = nuvkCreateContext(descriptor);
        }

        // Create device
        {
            auto selectedDevice = context.getDefaultDevice();
            device = context.createDevice(selectedDevice);
        }

        // Create surface
        {
            void* surfaceAddr;
            nuvkEnforce(
                SDL_Vulkan_CreateSurface(window, context.getHandle(), &surfaceAddr) == SDL_TRUE,
                "Failed to create Vulkan surface"
            );
            surface = device.createSurfaceFromHandle(surfaceAddr, presentationMode, NuvkTextureFormat.bgra8UnormSRGB);
            surface.resize(this.getFramebufferSize());
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
                            surface.resize(this.getFramebufferSize());
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

NuvkPipeline createShaders(NuvkDevice device, ubyte[] vertex, ubyte[] fragment) @nogc {
    NuvkShader vertexShader = device.createShaderFromSpirv(vertex, NuvkShaderStage.vertex);
    NuvkShader fragmentShader = device.createShaderFromSpirv(fragment, NuvkShaderStage.fragment);

    NuvkGraphicsPipelineDescriptor graphicsShaderDesc;
    graphicsShaderDesc.vertexShader = vertexShader;
    graphicsShaderDesc.fragmentShader = fragmentShader;

    graphicsShaderDesc.attributes ~= NuvkVertexAttribute(location: 0, format: NuvkVertexFormat.vec2);
    graphicsShaderDesc.bindings ~= NuvkVertexBinding(stride: vec2.sizeof, inputRate: NuvkInputRate.vertex);

    NuvkPipeline pipeline = device.createGraphicsPipeline(graphicsShaderDesc);
    
    nogc_delete(fragmentShader);
    nogc_delete(vertexShader);
    return pipeline;
}

NuvkBuffer createVertexBuffer(NuvkDevice device) @nogc {
    vec2[3] vertices = [
        vec2(0.0, -0.5),
        vec2(0.5, 0.5),
        vec2(-0.5, 0.5)
    ];

    NuvkBuffer vertexBuffer = device.createBuffer(NuvkBufferUsage.vertex | NuvkBufferUsage.transferDst, vec2.sizeof*3);
    vertexBuffer.upload!vec2(vertices);
    return vertexBuffer;
}

/**
    Main function.
*/
void main(string[] args) {
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

    NuvkBuffer vertexBuffer = device.createVertexBuffer();
    NuvkPipeline shader = device.createShaders(vertexShaderSrc, fragmentShaderSrc);

    NuvkQueue queue = device.createQueue();
    NuvkCommandBuffer cmdbuffer = queue.createCommandBuffer();

    // Render pass
    NuvkRenderPassDescriptor renderPassDescriptor = NuvkRenderPassDescriptor(
        colorAttachments: weak_vector!NuvkColorAttachment(1)
    );

    // Set color attachment
    renderPassDescriptor.colorAttachments[0] = NuvkColorAttachment(
        loadOp: NuvkLoadOp.clear,
        storeOp: NuvkStoreOp.store,
        clearValue: NuvkClearValue(0, 0, 0, 1)
    );

    while(!myWindow.isCloseRequested()) {
        myWindow.updateEvents();
        double ticks = cast(double)SDL_GetTicks64();

        if (NuvkTextureView nextImage = swapchain.getNext()) {

            // Update render pass color attachment.
            renderPassDescriptor.colorAttachments[0].texture = nextImage;
            
            if (NuvkRenderEncoder renderPass = cmdbuffer.beginRenderPass(renderPassDescriptor)) {
                renderPass.setPipeline(shader);
                renderPass.setCulling(NuvkCulling.none);
                renderPass.setVertexBuffer(vertexBuffer, 0, 0);
                renderPass.draw(NuvkPrimitive.triangles, 0, 3);
                renderPass.endEncoding();
            }

            cmdbuffer.commit();
            cmdbuffer.present(myWindow.getSurface());
        }
        cmdbuffer.awaitCompletion();
    }
}