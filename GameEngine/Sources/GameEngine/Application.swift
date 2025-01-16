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
        let vao = VertexArrayObject()
        let vbo = VertexBufferObject()
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
            try shaderProgram.use(shaders: [
                try .make(kind: C_GL_VERTEX_SHADER, name: "VertexShader"),
                try .make(kind: C_GL_FRAGMENT_SHADER, name: "FragmentShader")
            ]) // MB use sgoulkd be after bvuffer setup and link

            vao.bind { arrayIndex in
                vbo.bind { bufferIndex, buffer in
                    let params = buffer.add(
                        [
                            -0.5, -0.5, 0.0,
                            0.5, -0.5, 0.0,
                            0.0,  0.5, 0.0
                        ], 
                        normalized: true,
                        usage: C_GL_STATIC_DRAW
                    )
                    vao.linkVertexAttributes(
                        boundParams: params,
                        location: bufferIndex,
                        numberOfComponents: 3
                    )
                    vao.enable(location: bufferIndex)
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
