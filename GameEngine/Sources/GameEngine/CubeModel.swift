import Foundation
import simd

struct CubeModelHelper {
    let vbo = GLBufferSingle(type: .array)
    let ebo = GLBufferSingle(type: .elementsArray, unbindAutomatically: false)
    let vertices = MyVertex.cubeVertices
    let textures: [Texture]
    let transformUniform: Uniform<simd_float4x4>

    init(shaderProgram: ShaderProgram) throws {
        textures = try Self.loadTextures()
        transformUniform = try shaderProgram.getUniform(name: "model")
    }

    func bind() -> Int {
        vbo.bind { buffer in
            buffer.add(vertices: vertices, usage: .staticDraw)

            MyVertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                attributeType.enable(location: location)
            }
        }
        return vertices.count
    }

    func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element == CubeModel {
        try textures.withBind {
            for model in models {
                transformUniform.bind(model.transform())
                try onDraw()
            }
        }
    }

    private static func loadTextures() throws -> [Texture] {
        return [
            try .make(
                resource: "wooden_box.jpg", 
                type: .t2D, 
                internalFormat: .Base.rgb, 
                format: .rgb, 
                wrapping: .repeat, 
                generateMipmpap: true
            ),
            try .make(
                resource: "awesomeface.png", 
                type: .t2D, 
                internalFormat: .Base.rgb, 
                format: .rgba, 
                wrapping: .repeat, 
                generateMipmpap: true
            ),
        ]
    }
}

struct Transform {
    var position: SIMD3<Float>
    var rotation: simd_float4x4
    var scale: SIMD3<Float>

    init(
        position: SIMD3<Float> = .zero,
        rotation: simd_float4x4 = .identity, 
        scale: SIMD3<Float> = .one
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }

    func callAsFunction() -> simd_float4x4 {
        return .identity
            .scaled(by: scale)
            .transformed(by: rotation)
            .translated(by: position)
        // return .translation(position) * rotation * .scale(scale)
    }

    static func + (lhs: Transform, rhs: Transform) -> Transform {
        var result = lhs

        result.position += rhs.position
        result.rotation = lhs.rotation.transformed(by: rhs.rotation)
        result.scale *= rhs.scale

        return result
    }

    static func += (lhs: inout Transform, rhs: Transform) {
        lhs = lhs + rhs    
    }
}

struct CubeModel {
    var transform: Transform

    init(transform: Transform) {
        self.transform = transform
    }

    static let cubes = cubePositions.map { CubeModel(transform: Transform(position: $0)) }

    private static let cubePositions = [
        SIMD3<Float>(0.0, 0.0, 0.0),
        SIMD3<Float>(2.0, 5.0, -15.0),
        SIMD3<Float>(-1.5, -2.2, -2.5),
        SIMD3<Float>(-3.8, -2.0, -12.3),
        SIMD3<Float>(2.4, -0.4, -3.5),
        SIMD3<Float>(-1.7, 3.0, -7.5),
        SIMD3<Float>(1.3, -2.0, -2.5),
        SIMD3<Float>(1.5, 2.0, -2.5),
        SIMD3<Float>(1.5, 0.2, -1.5),
        SIMD3<Float>(-1.3, 1.0, -1.5)
    ]
}

extension MyVertex {
    static let cubeVertices: [MyVertex] = [
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),

        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0))
    ]
}
