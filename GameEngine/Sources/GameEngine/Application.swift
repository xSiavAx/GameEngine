// TODO: Catch up on face cooling
// glEnable(GL_CULL_FACE); // cull face
// glCullFace(GL_BACK); // cull back face
// glFrontFace(GL_CW); // GL_CCW for counter clock-wise

// TODO: Add Vectors to CGType and make bind list of Vectors, instead of array of floats

import Foundation

@MainActor
final class Application {
    let context: Context
    let window: Window
    var keysBag = Set<AnyReleasable>()

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
    nonisolated(unsafe) 
    static var attributes: [VertexAttribute.Type] = [
        SIMD3<Float>.self, 
        SIMD3<Float>.self
    ]

    var attributes: [VertexAttribute] { [
        coords, 
        color
    ] }

    let coords: SIMD3<Float>
    let color: SIMD3<Float>
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

        init(context: Context, window: Window) throws {
            self.context = context
            self.window = window

            try prepare()
            try run()
        }

        func prepare() throws {
            let vertices = [
                MyVertex(
                    coords: .init(x: 0.5, y: 0.5, z: 0.0),
                    color: .init(x: 1, y: 0, z: 0)
                ),  // top right
                MyVertex(
                    coords: .init(x: 0.5, y: -0.5, z: 0.0),
                    color: .init(x: 0, y: 1, z: 0)
                ),  // bottom right
                MyVertex(
                    coords: .init(x: -0.5, y: -0.5, z: 0.0),
                    color: .init(x: 0, y: 0, z: 1)
                ),  // bottom left
                MyVertex(
                    coords: .init(x: -0.5, y: 0.5, z: 0.0),
                    color: .init(x: 0, y: 0, z: 0)
                )   // top left 
            ]
            let indices: [UInt32] = [
                0, 1, 3,   // first triangle
                1, 2, 3    // second triangle
            ]

            try shaderProgram.use(shaders: [
                try .make(type: .vertex, name: "VertexShader"),
                try .make(type: .fragment, name: "FragmentShader")
            ])

            vao.bind { vaoName in
                vbo.bind { buffer in
                    buffer.add(vertices: vertices, usage: .staticDraw)

                    MyVertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                        attributeType.enable(location: location)
                    }
                    // vaoName.setDrawer(ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count))
                }
                ebo.bind { buffer in
                    let params = buffer.add(indices, usage: .staticDraw)

                    vaoName.setDrawer(params.elementsDrawer(mode: .triangles))
                }
            }
        }

        func run() throws {
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                let timeValue = GLTime.now
                let greenValue = Float(sin(timeValue) / 2.0) + 0.5

                shaderProgram.use()
                try vao.draw()

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
