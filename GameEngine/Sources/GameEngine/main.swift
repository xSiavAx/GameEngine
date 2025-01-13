@MainActor
func main() {
    do {
        let context = try Context.make(glVersion: (major: 3, minor: 3))
        let window = try context.makeWindow(size: ISize(width: 640, height: 480), title: "Hello World")
        var keyBag = Set<AnyReleasable>()

        let verticies: [Float] = [
            -0.5, -0.5, 0.0,
             0.5, -0.5, 0.0,
             0.0,  0.5, 0.0
        ]

        window.makeContextCurrent()
        try context.loadGlad()
        try context.adjustViewport()
        try window.setupResizeHandler()

        // Make context create it?
        let buffer = VertexBufferObjects()

        context.inputProcessor
            .addObserver(key: .ESCAPE, event: .keyUp) { context.currentWindow?.requestClose() }
            .store(into: &keyBag)

        buffer.addToArrayBuffer(verticies)

        while !window.shouldClose() {
            try context.processInput()
            context.clear(color: .limedSpruce)
            window.swapBuffers()
            context.pollEvents()
        }
    } catch {
        print("Error \(error)")
    }
}

main()