#version 450

layout(location = 0) in vec3 inVertex;
layout(location = 0) out vec3 fragColor;

vec3 colors[6] = vec3[] (
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, 1.0),
    vec3(0.0, 0.0, 1.0),
    vec3(0.0, 1.0, 0.0),
    vec3(1.0, 0.0, 1.0)
);

layout(binding = 0) 
uniform Camera {
    mat4 mvp;
};

void main() {
    gl_Position = mvp * vec4(inVertex, 1.0);
    fragColor = colors[gl_VertexIndex];
}