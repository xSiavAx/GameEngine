// TODO: Catch up on face cooling
// glEnable(GL_CULL_FACE); // cull face
// glCullFace(GL_BACK); // cull back face
// glFrontFace(GL_CW); // GL_CCW for counter clock-wise

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
            let vertices: [Float] = [
                 0.5,  0.5, 0.0,  // top right
                 0.5, -0.5, 0.0,  // bottom right
                -0.5, -0.5, 0.0,  // bottom left
                -0.5,  0.5, 0.0   // top left 
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
                    let params = buffer.add(vertices, normalized: true, usage: .staticDraw)

                    buffer.linkVertexAttributes(boundParams: params, location: 0, numberOfComponents: 3)
                    vaoName.enableAttribute(location: 0)
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

                shaderProgram.use()
                try vao.draw()

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
