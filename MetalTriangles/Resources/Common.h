//
//  Common.h
//  MetalTriangles
//
//  Created by David Kanenwisher on 6/21/20.
//  Copyright © 2020 dkanen. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <simd/simd.h>

#endif /* Common_h */

typedef struct {
    // time since drawing started
    float timer;
    // converts model space to world space
    matrix_float4x4 worldSpaceMatrix;
    // converts world space to camera space
    matrix_float4x4 cameraSpaceMatrix;
    // converts camera space to clip space
    matrix_float4x4 projectionMatrix;
} Uniforms;
