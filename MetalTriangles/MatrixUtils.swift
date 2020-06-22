//
//  MatrixUtils.swift
//  MetalTriangles
//
//  Created by David Kanenwisher on 6/21/20.
//  Copyright © 2020 dkanen. All rights reserved.
//

import Foundation

extension float4x4 {
    init(translateBy: SIMD3<Float>) {
        self = float4x4(
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [translateBy.x, translateBy.y, translateBy.z, 1]
        )
    }
    
    init(rotateXby radians: Float) {
        self = float4x4(
            [1, 0, 0, 0],
            [0, cos(radians), sin(radians), 0],
            [0, -sin(radians), cos(radians), 0],
            [0, 0, 0, 1]
        )
    }
    
    init(rotateYby radians: Float) {
        self = float4x4(
            [cos(radians), 0, -sin(radians), 0],
            [0, 1, 0, 0],
            [sin(radians), 0, cos(radians), 0],
            [ 0, 0, 0, 1]
        )
    }
    
    init(rotateZby radians: Float) {
        self = float4x4(
            [ cos(radians), sin(radians), 0, 0],
            [-sin(radians), cos(radians), 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        )
    }
    
    init(rotateBy radians: SIMD3<Float>) {
        self = float4x4(rotateXby: radians.x)
            * float4x4(rotateYby: radians.y)
            * float4x4(rotateZby: radians.z)
    }
}

typealias Degrees = Float

extension Degrees {
    var radians: Float {
        (self / 180) * Float.pi
    }
}
