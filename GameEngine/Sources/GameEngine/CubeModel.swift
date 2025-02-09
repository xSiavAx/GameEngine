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

        try shaderProgram.getUniform(name: "texture0").bind(Int32(0))
        try shaderProgram.getUniform(name: "texture1").bind(Int32(1))
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
