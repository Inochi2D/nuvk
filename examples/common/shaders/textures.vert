#version 450

layout(location = 0) in vec3 inVertex;
layout(location = 1) in vec2 inUV;

layout(location = 0) out vec2 outUV;

layout(binding = 0) 
uniform Camera {
    mat4 mvp;
};

void main() {
    gl_Position = mvp * vec4(inVertex, 1.0);
}