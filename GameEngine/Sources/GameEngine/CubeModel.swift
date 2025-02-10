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
        try shaderProgram.getUniform(name: "texture0").set(Int32(0))
        try shaderProgram.getUniform(name: "texture1").set(Int32(1))
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

final class ColorCubeModelHelper: BaseCubeModelHelper, ModelHelper {}

class BaseCubeModelHelper {
    let vbo = GLBufferSingle(type: .array)
    let transformUniform: Uniform<float4x4>

    init(shaderProgram: ShaderProgram) throws {
        transformUniform = try shaderProgram.getUniform(name: "model")
    }

    func bind() -> VertexArrayDrawer {
        let vertices = Vertex.cubeVertices

        vbo.bind { buffer in
            buffer.add(vertices: vertices, usage: .staticDraw)

            Vertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                attributeType.enable(location: location)
            }
        }

        return ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count)
    }

    func draw<C: Collection>(models: C, onDraw: () throws -> Void) throws where C.Element: RenderModel {
        for model in models {
            transformUniform.set(model.transform())
            try onDraw()
        }
    }
}

extension Vertex {
    fileprivate static let cubeVertices: [Vertex] = [
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, 0.0, -1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, 0.0, -1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, 0.0, -1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, 0.0, -1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, 0.0, -1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, 0.0, -1.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, 0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, 0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, 0.0, 1.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, 0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, 0.0, 1.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, 0.0, 1.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(-1.0, 0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(-1.0, 0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(-1.0, 0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(-1.0, 0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(-1.0, 0.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(-1.0, 0.0, 0.0)),

        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(1.0, 0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(1.0, 0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(1.0, 0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(1.0, 0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(1.0, 0.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(1.0, 0.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, -1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, -1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, -1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, -1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, -1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, -1.0, 0.0)),

        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, 1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(1.0, 1.0), normal: .init(0.0, 1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, 1.0, 0.0)),
        Vertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(1.0, 0.0), normal: .init(0.0, 1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .coral, texture: .init(0.0, 0.0), normal: .init(0.0, 1.0, 0.0)),
        Vertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .coral, texture: .init(0.0, 1.0), normal: .init(0.0, 1.0, 0.0))
    ]
}
