#version 450

layout(location = 0) in vec2 outUV;
layout(location = 0) out vec4 outColor;

layout(binding = 1) uniform texture2D texture_;
layout(binding = 2) uniform sampler sampler_;

void main() {
    outColor = texture(sampler2D(texture_, sampler_), outUV);
}