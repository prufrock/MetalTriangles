//
//  Shaders.metal
//  MetalTriangles
//
//  Created by David Kanenwisher on 6/15/20.
//  Copyright © 2020 dkanen. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct VertexOut {
    float4 position [[position]];
    float point_size [[point_size]];
};

vertex VertexOut vertex_main(constant float3 *vertices [[buffer(0)]],
                             constant float4x4 &matrix [[buffer(1)]],
                             uint id [[vertex_id]]) {
    VertexOut vertex_out {
        .position = matrix * float4(vertices[id], 1),
        .point_size = 20.0
        
    };
    return vertex_out;
}

fragment float4 fragment_main(constant float4 &color [[buffer(0)]]) {
    return color;
}
