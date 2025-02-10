// TODO: Catch up on face cooling
// glEnable(GL_CULL_FACE); // cull face
// glCullFace(GL_BACK); // cull back face
// glFrontFace(GL_CW); // GL_CCW for counter clock-wise

// TODO: Move matricies multiplication from App to Shader (One calculated in Transform).

import Foundation
import simd
import OpenCombineShim

@MainActor
final class Application {
    let context: Context
    let window: Window

    private var keysBag = Set<AnyCancellable>()

    init() throws {
        let context = try Context.make(glVersion: (major: 3, minor: 3))

        self.context = context
        self.window = try context.makeWindow(size: ISize(width: 800, height: 600), title: "Hello World")

        try setupContext()
        bindInput()
        _ = try RunLoop(context: context, window: window)
    }

    private func setupContext() throws {
        window.makeContextCurrent()
        try context.loadGlad()
        try context.adjustViewport()
        context.isDepthTestEnabled = true
    }

    private func bindInput() {
        window.inputProcessor.buttons
                .addObserver(key: .ESCAPE, event: .keyUp) {  [weak self] in
                    self?.context.currentWindow?.requestClose() 
                }
                .store(in: &keysBag)
    }
}

extension Application {
    final class RunLoop {
        let context: Context
        let window: Window
        
        let shaderProgram = ShaderProgram()
        let timeDelta = TimeDelta()
        let scene: Scene = TestScene()

        private var bag = Set<AnyCancellable>()

        init(context: Context, window: Window) throws {
            self.context = context
            self.window = window

            try prepare()
            try run()
        }

        func prepare() throws {
            try shaderProgram.use(shaders: [
                try Shader.load(type: .vertex, resource: "VertexShader"),
                try Shader.load(type: .fragment, resource: "FragmentShader")
            ])
            try scene.prepare(context: context, window: window, shaderProgram: shaderProgram)
        }

        func run() throws {
            timeDelta.reset()
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                shaderProgram.use()

                try scene.draw(delta:  timeDelta.update())

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
