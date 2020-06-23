//
//  Renderer.swift
//  MetalTriangles
//
//  Created by David Kanenwisher on 6/15/20.
//  Copyright © 2020 dkanen. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var uniforms = Uniforms()
    
    var timer: Float = 0
    
    init(metalView: MTKView) {
        guard
          let device = MTLCreateSystemDefaultDevice(),
          let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        do {
          pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
          fatalError(error.localizedDescription)
        }
        
        super.init()
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
        
        initWorldSpaceMatrix()
        initCameraSpaceMatrix()
    }
    
    func initWorldSpaceMatrix() {
        let translation = float4x4(translateBy: [0, 0.0, 0])
        let rotation = float4x4(rotateBy: [0, 0, Degrees(90).radians])
        uniforms.worldSpaceMatrix = translation * rotation
    }
    
    func initCameraSpaceMatrix() {
        uniforms.cameraSpaceMatrix = float4x4(translateBy: [0.3, 0, 0]).inverse
    }
    
    func updateProjectionMatrix(_ metalView: MTKView) {
        uniforms.projectionMatrix = float4x4(projectionFov: Degrees(45).radians, aspectRatio: aspect(metalView), nearPlane: 0.1, farPlane: 100)
    }
    
    func aspect(_ metalView: MTKView) -> Float {
        return Float(metalView.bounds.width) / Float(metalView.bounds.height)
    }
    
    func rotateWith(timer: Float, transform: matrix_float4x4) -> matrix_float4x4 {
        
        var rotated = transform
        let angle = Float.pi / (timer.truncatingRemainder(dividingBy: 10.0))
        rotated.columns.0 = [cos(angle), -sin(angle), 0, 0]
        rotated.columns.1 = [sin(angle), cos(angle), 0, 0]
        
        return rotated
    }
}

extension Renderer: MTKViewDelegate {
        
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // adjust the aspect ratio
        updateProjectionMatrix(view)
    }

    func draw(in view: MTKView) {
        guard
            let descriptor = view.currentRenderPassDescriptor,
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
                return
        }
        
        timer += 0.007
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderPurpleTriangle(renderEncoder)
        
        renderGreenTriangle(renderEncoder)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func renderPurpleTriangle(_ renderEncoder: MTLRenderCommandEncoder) {
        
        var purple = SIMD4<Float>(1, 0.5, 1, 1)
        var vertices: [SIMD3<Float>] = [
            [0, 0, 1.0],
            [0, -0.5, 1.0],
            [1.0, -0.5, 1.0]
        ]

        render(vertices: &vertices, with: renderEncoder, color: &purple)
    }
    
    func renderGreenTriangle(_ renderEncoder: MTLRenderCommandEncoder) {
        var green = SIMD4<Float>(0, 0.7, 0, 1)
        var vertices: [SIMD3<Float>] = [
            [-1.0, 0.5, 1.0],
            [-1.0, 0, 1.0],
            [0, 0, 1.0]
        ]
        
        render(vertices: &vertices, with: renderEncoder, color: &green)
    }
    
    func render(vertices: inout [SIMD3<Float>], with renderEncoder: MTLRenderCommandEncoder, color: inout SIMD4<Float>) {
        let vertexBuffer = Renderer.device.makeBuffer(bytes: &vertices,
                                                      length: MemoryLayout<SIMD3<Float>>.stride * vertices.count,
                                                      options: [])
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Float>.stride, index: 0)
        renderEncoder.setFragmentBytes(&color,
                                       length: MemoryLayout<SIMD4<Float>>.stride,
                                       index: 1)
        
        renderEncoder.setVertexBytes(&uniforms,
                                     length: MemoryLayout<Uniforms>.stride,
                                     index: 1)
        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: vertices.count)
    }
}
