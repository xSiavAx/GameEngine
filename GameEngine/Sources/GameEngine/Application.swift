
// TODO:
// Make VertexArrayObject and VertexBufferObject same type with different binding strategies
// Add to this types addon, which allow to bind data, or to link and enable attrbiutes
// Make Single variant of this type, to serve as VertexArraySingle serves VertexArrayObject

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

import C_GLAD

extension Application {
    final class RunLoop {
        let vao = VertexArraySingle()
        let vbo = VertexBufferSingle()
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
            let vertices: [Float] = [
                 0.5,  0.5, 0.0,  // top right
                 0.5, -0.5, 0.0,  // bottom right
                -0.5, -0.5, 0.0,  // bottom left
                -0.5,  0.5, 0.0   // top left 
            ]
            let indices: [Int] = [
                0, 1, 3,   // first triangle
                1, 2, 3    // second triangle
            ]

            try shaderProgram.use(shaders: [
                try .make(kind: C_GL_VERTEX_SHADER, name: "VertexShader"),
                try .make(kind: C_GL_FRAGMENT_SHADER, name: "FragmentShader")
            ])

            vao.bind { vaoName in
                vbo.bind { buffer in
                    let params = buffer.add(vertices, normalized: true, usage: C_GL_STATIC_DRAW)

                    vaoName.linkVertexAttributes(boundParams: params, location: 0, numberOfComponents: 3)
                    vaoName.enableAttribute(location: 0)
                }
            }
        }

        func run() throws {
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                shaderProgram.use()
                vao.bind()
                c_glDrawArrays(C_GL_TRIANGLES, 0, 3) // Number of verticies, params.count

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
