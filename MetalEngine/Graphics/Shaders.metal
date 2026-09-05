#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position;
    float4 color;
};

struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

// Vertex Shader
vertex VertexOut vertex_main(constant VertexIn* vertices [[buffer(0)]],
                             constant Uniforms& uniforms [[buffer(1)]],
                             uint vertexID [[vertex_id]]) {
    VertexOut out;
    
    float4 localPosition = float4(vertices[vertexID].position, 1.0);
    
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * localPosition;
    out.color = vertices[vertexID].color;
    
    return out;
}

// Fragment Shader / Pixel Shader
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
