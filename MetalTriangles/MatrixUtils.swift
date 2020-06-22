// I don't quite understand all of the math here yet so I
// adapated a lot of these from "Metal Programming Guide: Tutorial and Reference Via Swift"
// by Janie Clayton and from Metal by Tutorials by By Caroline Begbie & Marius Horga

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
    
    init(projectionFov: Radians, aspectRatio: Float, nearPlane: Float, farPlane: Float) {
        let yScale = 1 / tan(projectionFov * 0.5)
        let xScale = yScale / aspectRatio
        let zScale = farPlane / (farPlane - nearPlane)
        let X = SIMD4<Float>(xScale,  0,  0,  0)
        let Y = SIMD4<Float>(0,  yScale,  0,  0)
        let Z = SIMD4<Float>(0,  0,  zScale, 1)
        let W = SIMD4<Float>(0,  0,  zScale * -nearPlane,  0)
        self.init()
        columns = (X, Y, Z, W)
    }
}

typealias Degrees = Float

extension Degrees {
    var radians: Float {
        (self / 180) * Float.pi
    }
}

typealias Radians = Float
