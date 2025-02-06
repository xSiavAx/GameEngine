import Foundation
import simd

struct CubeModelHelper {
    let vbo = GLBufferSingle(type: .array)
    let ebo = GLBufferSingle(type: .elementsArray, unbindAutomatically: false)
    let vertices = Vertex.cubeVertices
    let textures: [Texture]
    let transformUniform: Uniform<float4x4>

    init(shaderProgram: ShaderProgram) throws {
        textures = try Self.loadTextures()
        transformUniform = try shaderProgram.getUniform(name: "model")
    }

    func bind() -> Int {
        vbo.bind { buffer in
            buffer.add(vertices: vertices, usage: .staticDraw)

            Vertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                attributeType.enable(location: location)
            }
        }
        return vertices.count
    }

    func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element: RenderModel {
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


extension AnyModel {
    static let cubes = cubePositions.map { AnyModel(freeTransform: FreeTransform(position: $0)) }

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

extension Vertex {
    static let cubeVertices: [Vertex] = [
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0))
    ]
}
