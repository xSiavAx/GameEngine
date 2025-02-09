import Foundation
import simd

protocol ModelHelper {
    func bind() -> VertexArrayDrawer
    func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element: RenderModel
}

final class TexturedCubeModelHelper: BaseCubeModelHelper, ModelHelper {
    let textures: [Texture]

    override init(shaderProgram: ShaderProgram) throws {
        textures = try Self.loadTextures()
        try super.init(shaderProgram: shaderProgram)
        try shaderProgram.getUniform(name: "texture0").bind(Int32(0))
        try shaderProgram.getUniform(name: "texture1").bind(Int32(1))
    }

    func bind() -> VertexArrayDrawer {
        let vertices = Vertex.cubeVertices

        bindVBO(vertices: vertices)
        return ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count)
    }

    override func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element: RenderModel {
        try textures.withBind {
            try super.draw(models: models, onDraw: onDraw)
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

final class ColorCubeModelHelper: BaseCubeModelHelper, ModelHelper {
    func bind() -> VertexArrayDrawer {
        let (vertices, indices) = Vertex.cubeVerticiesAndIndexes

        bindVBO(vertices: vertices)
        ebo.bind { buffer in buffer.add(indices, usage: .staticDraw) }

        return ElementsVertexArrayDrawer<UInt32>(mode: .triangles, count: indices.count)
    }
}

class BaseCubeModelHelper {
    let vbo = GLBufferSingle(type: .array)
    let ebo = GLBufferSingle(type: .elementsArray, unbindAutomatically: false)
    
    let transformUniform: Uniform<float4x4>

    init(shaderProgram: ShaderProgram) throws {
        transformUniform = try shaderProgram.getUniform(name: "model")
    }

    func bindVBO(vertices: [Vertex]) {
        vbo.bind { buffer in
            buffer.add(vertices: vertices, usage: .staticDraw)

            Vertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                attributeType.enable(location: location)
            }
        }
    }

    func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element: RenderModel {
        for model in models {
            transformUniform.bind(model.transform())
            try onDraw()
        }
    }
}

extension Vertex {
    fileprivate static let cubeVertices: [Vertex] = [
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),

        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .white, texture: .init(0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .white, texture: .init(0.0, 1.0))
    ]

    fileprivate static let cubeVerticiesAndIndexes: ([Vertex], [UInt32]) = (
        [
            Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .white, texture: .init(0.0, 0.0)), // 0 - Bottom-left-back
            Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(1.0, 0.0)), // 1 - Bottom-right-back
            Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .white, texture: .init(1.0, 1.0)), // 2 - Top-right-back
            Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0)), // 3 - Top-left-back
            Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0)), // 4 - Bottom-left-front
            Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0)), // 5 - Bottom-right-front
            Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .white, texture: .init(1.0, 1.0)), // 6 - Top-right-front
            Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(0.0, 1.0))  // 7 - Top-left-front
        ], [
            0, 1, 2, 2, 3, 0, // Back face
            4, 5, 6, 6, 7, 4, // Front face
            0, 1, 5, 5, 4, 0, // Bottom face
            2, 3, 7, 7, 6, 2, // Top face
            0, 3, 7, 7, 4, 0, // Left face
            1, 2, 6, 6, 5, 1  // Right face
        ]
    )
}
