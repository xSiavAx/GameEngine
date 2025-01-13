@MainActor
func main() {
    do {
        let context = try makeAndSetupContext()
        var keysBag = Set<AnyReleasable>()
        let verticies: [Float] = [
            -0.5, -0.5, 0.0,
             0.5, -0.5, 0.0,
             0.0,  0.5, 0.0
        ]
        let buffer = VertexBufferObjects()

        bindInput(context: context, bag: &keysBag)

        buffer.addToArrayBuffer(verticies)

        try runLoop(context: context)
    } catch {
        print("Error \(error)")
    }
}

func runLoop(context: Context) throws {
    let window = try context.requireCurrentWindow()
    while !window.shouldClose() {
        try context.processInput()
        context.clear(color: .limedSpruce)
        window.swapBuffers()
        context.pollEvents()
    }
}

func makeAndSetupContext() throws -> Context {
    let context = try Context.make(glVersion: (major: 3, minor: 3))
    let window = try context.makeWindow(size: ISize(width: 640, height: 480), title: "Hello World")

    window.makeContextCurrent()
    try context.loadGlad()
    try context.adjustViewport()
    try window.setupResizeHandler()

    return context
}

func bindInput(context: Context, bag: inout Set<AnyReleasable>) {
    context.inputProcessor
            .addObserver(key: .ESCAPE, event: .keyUp) { context.currentWindow?.requestClose() }
            .store(into: &bag)
}

main()