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
        let verticies: [Float] = [
            -0.5, -0.5, 0.0,
             0.5, -0.5, 0.0,
             0.0,  0.5, 0.0
        ]
        let buffer = VertexBufferObjects()
        let shader = try ShaderLoader.prepare(kind: C_GL_VERTEX_SHADER, name: "VertexShader")

        bindInput()

        buffer.addToArrayBuffer(verticies)

        try runLoop()
    }

    func runLoop() throws {
        while !window.shouldClose() {
            try context.processInput()
            context.clear(color: .limedSpruce)
            window.swapBuffers()
            context.pollEvents()
        }
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
