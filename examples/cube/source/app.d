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
import std.stdio : writeln;
import common;

ubyte[] vertexShaderSrc = cast(ubyte[])import("shaders/cube_vert.spv");
ubyte[] fragmentShaderSrc = cast(ubyte[])import("shaders/cube_frag.spv");

struct Uniform0 {
    mat4 mvp;
}

// Vertex buffer
vec3[6] vertices = [
    vec3(0,   0, 64),
    vec3(0,  64, 64),
    vec3(64,  0, 64),

    vec3(64,  0, 64),
    vec3( 0, 64, 64),
    vec3(64, 64, 64),
];

/**
    Main function.
*/
void main(string[] args) {
    Window myWindow = exampleInit(nstring("3d uwu!!"), 640, 480, args);

    NuvkDevice device = myWindow.getDevice();
    NuvkSwapchain swapchain = myWindow.getSurface().getSwapchain();

    NuvkQueue queue = device.createQueue();

    // Rendering pipeline
    NuvkShaderProgram program = device.createRenderPipeline(
        vertex: vertexShaderSrc, 
        fragment: fragmentShaderSrc
    );

    // Vertex buffer
    NuvkBuffer vertexBuffer = device.createBuffer(
        NuvkBufferUsage.vertex,
        vertices
    );

    /// Uniform buffer
    Uniform0* uniform0;
    NuvkBuffer uniformBuffer = device.createBuffer(NuvkBufferUsage.uniform | NuvkBufferUsage.hostVisible, Uniform0.sizeof);
    uniformBuffer.map!Uniform0(uniform0, 1, 0);

    // Render pass
    NuvkRenderPassDescriptor renderPassDescriptor = NuvkRenderPassDescriptor(
        colorAttachments: weak_vector!NuvkColorAttachment(1)
    );

    while(!myWindow.isCloseRequested()) {
        myWindow.updateEvents();

        if (auto cmdbuffer = queue.nextCommandBuffer()) {
            if (NuvkTextureView nextImage = swapchain.getNext()) {

                // Update matrix
                vec2i fbSize = myWindow.getFramebufferSize();
                uniform0.mvp = (
                    mat4.perspective01(fbSize.x, fbSize.y, 90.0, 0.1, 1000) *
                    mat4.lookAt(vec3(0, 64, 0), vec3(32, 32, 64), vec3(0, 1, 0))
                ).transposed();

                // Set color attachment
                renderPassDescriptor.colorAttachments[0] = NuvkColorAttachment(
                    loadOp: NuvkLoadOp.clear,
                    storeOp: NuvkStoreOp.store,
                    clearValue: NuvkClearValue(0, 0, 0, 1),
                    texture: nextImage
                );

                renderPassDescriptor.shader = program;
                
                // Render
                if (NuvkRenderEncoder renderPass = cmdbuffer.beginRenderPass(renderPassDescriptor)) {
                    renderPass.setCulling(NuvkCulling.none);
                    renderPass.setVertexBuffer(vertexBuffer, 0, 0);
                    renderPass.setVertexBuffer(uniformBuffer, 0, 0);
                    renderPass.draw(NuvkPrimitive.triangles, 0, 6);
                    renderPass.endEncoding();
                }

                cmdbuffer.present(myWindow.getSurface());
                cmdbuffer.commit();
            }
            
            cmdbuffer.awaitCompletion();
        }
    }
}