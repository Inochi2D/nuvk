/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Textures example app
*/
module app;

import common;
import std.stdio : writeln;

ubyte[] vertexShaderSrc = cast(ubyte[])import("shaders/textures_vert.spv");
ubyte[] fragmentShaderSrc = cast(ubyte[])import("shaders/textures_frag.spv");
ubyte[] ada = cast(ubyte[])import("textures/ada.png");

struct Uniform0 {
    mat4 mvp;
}

struct VertexAttrib {
    vec3 position;
    vec2 uv;
}

// Vertex buffer
VertexAttrib[6] vertices = [
    VertexAttrib(position: vec3(0,   0, 64), uv: vec2(0, 0)),
    VertexAttrib(position: vec3(0,  64, 64), uv: vec2(0, 1)),
    VertexAttrib(position: vec3(64,  0, 64), uv: vec2(1, 0)),

    VertexAttrib(position: vec3(64,  0, 64), uv: vec2(1, 0)),
    VertexAttrib(position: vec3( 0, 64, 64), uv: vec2(0, 1)),
    VertexAttrib(position: vec3(64, 64, 64), uv: vec2(1, 1)),
];

/**
    Main function.
*/
void main(string[] args) {
    Window myWindow = exampleInit(nstring("3d uwu!!"), 640, 480, args);

    NuvkDevice device = myWindow.getDevice();
    NuvkSwapchain swapchain = myWindow.getSurface().getSwapchain();

    NuvkQueue queue = device.createQueue();
    NuvkCommandBuffer cmdbuffer = queue.createCommandBuffer();

    // Texture & Sampler
    NuvkTexture texture = device.createFromPNG(ada);
    NuvkTextureView view = texture.createTextureView(NuvkTextureViewDescriptor(
        format: NuvkTextureFormat.rgba8UnormSRGB,
        type: NuvkTextureType.texture2d,
    ));
    NuvkSampler sampler = device.createSampler(NuvkSamplerDescriptor(
        minFilter: NuvkSamplerTextureFilter.linear,
        magFilter: NuvkSamplerTextureFilter.linear,
        mipFilter: NuvkSamplerMipmapFilter.notMipmapped,
    ));

    // Rendering pipeline
    NuvkPipeline pipeline = device.createRenderPipeline(
        vertex: vertexShaderSrc, 
        fragment: fragmentShaderSrc,
        attributes: [
            NuvkVertexAttribute(location: 0, format: NuvkVertexFormat.vec3),
            NuvkVertexAttribute(location: 1, format: NuvkVertexFormat.vec2),
        ],
        bindings: [
            NuvkVertexBinding(stride: VertexAttrib.sizeof, inputRate: NuvkInputRate.vertex)
        ]
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

        if (NuvkTextureView nextImage = swapchain.getNext()) {

            // Update matrix
            vec2i fbSize = myWindow.getFramebufferSize();
            uniform0.mvp = (
                mat4.orthographic01(0, fbSize.x, fbSize.y, 0, 0.1, 1000)
            ).transposed();

            // Set color attachment
            renderPassDescriptor.colorAttachments[0] = NuvkColorAttachment(
                loadOp: NuvkLoadOp.clear,
                storeOp: NuvkStoreOp.store,
                clearValue: NuvkClearValue(0, 0, 0, 1),
                texture: nextImage
            );
            
            // Render
            if (NuvkRenderEncoder renderPass = cmdbuffer.beginRenderPass(renderPassDescriptor)) {
                renderPass.setPipeline(pipeline);
                renderPass.setFragmentTexture(view, 1);
                renderPass.setFragmentSampler(sampler, 2);
                renderPass.setVertexBuffer(vertexBuffer, 0, 0);
                renderPass.setVertexBuffer(uniformBuffer, 0, 0);
                renderPass.draw(NuvkPrimitive.triangles, 0, 6);
                renderPass.endEncoding();
            }

            cmdbuffer.commit();
            cmdbuffer.present(myWindow.getSurface());
            cmdbuffer.awaitCompletion();
        }
    }
}