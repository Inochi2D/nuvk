/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Triangle example app
*/
module app;
import common;

import std.stdio;

ubyte[] vertexShaderSrc = cast(ubyte[])import("shaders/triangle_vert.spv");
ubyte[] fragmentShaderSrc = cast(ubyte[])import("shaders/triangle_frag.spv");

// Vertices
vec2[3] vertices = [
    vec2(0.0, -0.5),
    vec2(0.5, 0.5),
    vec2(-0.5, 0.5)
];

/**
    Main function.
*/
void main(string[] args) {
    Window myWindow = exampleInit(nstring("Hello Triangle"), 640, 480, args);

    NuvkDevice device = myWindow.getDevice();
    NuvkSwapchain swapchain = myWindow.getSurface().getSwapchain();

    NuvkQueue queue = device.createQueue();
    NuvkCommandBuffer cmdbuffer = queue.createCommandBuffer();

    // shader program
    NuvkShaderProgram program = device.createRenderPipeline(
        vertex: vertexShaderSrc, 
        fragment: fragmentShaderSrc
    );

    // Vertex buffer
    NuvkBuffer vertexBuffer = device.createBuffer(
        NuvkBufferUsage.vertex,
        vertices
    );

    // Render pass
    NuvkRenderPassDescriptor renderPassDescriptor = NuvkRenderPassDescriptor(
        colorAttachments: weak_vector!NuvkColorAttachment(1)
    );

    while(!myWindow.isCloseRequested()) {
        myWindow.updateEvents();

        if (NuvkTextureView nextImage = swapchain.getNext()) {

            // Set color attachment
            renderPassDescriptor.colorAttachments[0] = NuvkColorAttachment(
                loadOp: NuvkLoadOp.clear,
                storeOp: NuvkStoreOp.store,
                clearValue: NuvkClearValue(0, 0, 0, 1),
                texture: nextImage
            );
            
            renderPassDescriptor.shader = program;
            
            if (NuvkRenderEncoder renderPass = cmdbuffer.beginRenderPass(renderPassDescriptor)) {
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