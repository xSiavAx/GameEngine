// TODO: Catch up on face cooling
// glEnable(GL_CULL_FACE); // cull face
// glCullFace(GL_BACK); // cull back face
// glFrontFace(GL_CW); // GL_CCW for counter clock-wise

import Foundation
import simd
import OpenCombineShim

@MainActor
final class Application {
    let context: Context
    let window: Window
    var keysBag = Set<AnyCancellable>()

    init() throws {
        let context = try Context.make(glVersion: (major: 3, minor: 3))

        self.context = context
        self.window = try context.makeWindow(size: ISize(width: 640, height: 480), title: "Hello World")

        try setupContext()
        try run()
    }

    func run() throws {
        bindInput()
        _ = try RunLoop(context: context, window: window)
    }

    func runLoop() throws {
        
    }

    private func setupContext() throws {
        window.makeContextCurrent()
        try context.loadGlad()
        try context.adjustViewport()
        try window.setupResizeHandler()
    }

    func bindInput() {
        context.inputProcessor
                .addObserver(key: .ESCAPE, event: .keyUp) {  [weak self] in
                    self?.context.currentWindow?.requestClose() 
                }
                .store(into: &keysBag)
    }
}

struct MyVertex: Vertex {
    static let attributes: [VertexAttribute.Type] = [
        SIMD3<Float>.self, 
        SIMD3<Float>.self,
        SIMD2<Float>.self
    ]

    var attributes: [VertexAttribute] { [
        coords, 
        color,
        texture
    ] }

    let coords: SIMD3<Float>
    let color: SIMD3<Float>
    let texture: SIMD2<Float>
}

import C_GLAD

extension Application {
    final class RunLoop {
        let vao = VertexArraySingle()
        let vbo = GLBufferSingle(type: .array)
        let ebo = GLBufferSingle(type: .elementsArray, unbindAutomatically: false)
        let shaderProgram = ShaderProgram()
        let context: Context
        let window: Window
        var textures = [Texture]()

        init(context: Context, window: Window) throws {
            self.context = context
            self.window = window

            try prepare()
            try run()
        }

        func prepare() throws {
            let transform = simd_float4x4(1)
                .rotated(by: .degrees(90), around: .oZ)
                .scaled(by: .one / 2)

            let vertices = [
                MyVertex(
                    coords: .init(x: 0.5, y: 0.5, z: 0),
                    color: .init(x: 1, y: 0, z: 0),
                    texture: .init(1, 1)
                ),  // top right
                MyVertex(
                    coords: .init(x: 0.5, y: -0.5, z: 0),
                    color: .init(x: 0, y: 1, z: 0),
                    texture: .init(1, 0)
                ),  // bottom right
                MyVertex(
                    coords: .init(x: -0.5, y: -0.5, z: 0.0),
                    color: .init(x: 0, y: 0, z: 1),
                    texture: .init(0, 0)
                ),  // bottom left
                MyVertex(
                    coords: .init(x: -0.5, y: 0.5, z: 0.0),
                    color: .init(x: 1, y: 1, z: 1),
                    texture: .init(0, 1)
                )   // top left 
            ]
            let indices: [UInt32] = [
                0, 1, 3,   // first triangle
                1, 2, 3    // second triangle
            ]
            textures += [
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

            try shaderProgram.use(shaders: [
                try Shader.load(type: .vertex, resource: "VertexShader"),
                try Shader.load(type: .fragment, resource: "FragmentShader")
            ])

            try shaderProgram.getUniform(name: "texture0").bind(Int32(0))
            try shaderProgram.getUniform(name: "texture1").bind(Int32(1))
            try shaderProgram.getUniform(name: "transform").bind(transform)

            vao.bind { vaoName in
                vbo.bind { buffer in
                    buffer.add(vertices: vertices, usage: .staticDraw)

                    MyVertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                        attributeType.enable(location: location)
                    }
                    // vaoName.setDrawer(ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count))
                }
                ebo.bind { buffer in
                    buffer.add(indices, usage: .staticDraw)
                    vaoName.setDrawer(ElementsVertexArrayDrawer<UInt32>(mode: .triangles, count: indices.count))
                }
            }
        }

        func run() throws {
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                shaderProgram.use()
                try textures.withBind {
                    try vao.draw()
                }

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
