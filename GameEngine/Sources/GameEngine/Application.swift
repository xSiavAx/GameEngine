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
        self.window = try context.makeWindow(size: ISize(width: 800, height: 600), title: "Hello World")

        try setupContext()
        try run()
    }

    func run() throws {
        bindInput()
        _ = try RunLoop(context: context, window: window)
    }

    private func setupContext() throws {
        window.makeContextCurrent()
        try context.loadGlad()
        try context.adjustViewport()
        try window.setupResizeHandler()
        context.isDepthTestEnabled = true
    }

    func bindInput() {
        context.inputProcessor
                .addObserver(key: .ESCAPE, event: .keyUp) {  [weak self] in
                    self?.context.currentWindow?.requestClose() 
                }
                .store(in: &keysBag)
    }
}

import C_GLAD

extension Application {
    final class RunLoop {
        let vao = VertexArraySingle()
        let shaderProgram = ShaderProgram()
        let context: Context
        let window: Window
        var drawHelper: CubeModelHelper?

        private var cubes = AnyModel.cubes[0..<10]

        private let cameraHelper = CameraHelper(transform: FreeTransform(position: SIMD3(0, 0, -3)))

        @Published
        var time: Double = 0
        @Published
        var projectionMatrix: float4x4 = .identity

        let timeDelta = TimeDelta()

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

            cameraHelper.control.bindInput(context.inputProcessor)

            let base = float4x4(
                SIMD4<Float>(1, 1, 1, 0),
                SIMD4<Float>(2, 2, 2, 0),
                SIMD4<Float>(3, 3, 3, 0),
                SIMD4<Float>(0, 0, 0, 1)
            )

            var pos = float4x4(1)
            pos.columns.3 = SIMD4<Float>(5, 5, 5, 1)

            print(base * pos)
            
            // Create helper
            try shaderProgram.getUniform(name: "texture0").bind(Int32(0))
            try shaderProgram.getUniform(name: "texture1").bind(Int32(1))

            try cameraHelper.config(shaderProgram: shaderProgram)
            let projectionUniform = try shaderProgram.getUniform(name: "projection") as Uniform<float4x4>
            let drawHelper = try CubeModelHelper(shaderProgram: shaderProgram)

            context.$viewPort
                .map { size in Float(size.width) / Float(size.height)  }
                .map { 
                    float4x4.perspective(
                        fovy: .degrees(45), 
                        aspect: $0, 
                        near: 0.1, 
                        far: 100
                    ) 
                }
                .assign(to: &$projectionMatrix)
            

            $projectionMatrix
                .sink { projectionUniform.bind($0) }
                .store(in: &bag)

            let rotationAxis = SIMD3<Float>(1.0, 0.3, 0.5).normalized
            $time
                .map { Float($0) }
                .sink { [weak self] time in
                    guard let self else { return }
                    for i in (0..<cubes.count) {
                        cubes[i].freeTransform.rotation = simd_quatf(angle: time + .degrees(20.0 * Float(i)), axis: rotationAxis)
                    }
                }
                .store(in: &bag)

            vao.bind { vaoName in
                let verticiesCount = drawHelper.bind()

                vaoName.setDrawer(ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: verticiesCount))
                // ebo.bind { buffer in
                //     buffer.add(indices, usage: .staticDraw)
                //     vaoName.setDrawer(ElementsVertexArrayDrawer<UInt32>(mode: .triangles, count: indices.count))
                // }
            }
            self.drawHelper = drawHelper
        }

        func run() throws {
            timeDelta.reset()
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                shaderProgram.use()
                time = GLTime.now

                let delta = timeDelta.update()

                try drawHelper?.draw(models: cubes) {
                    try vao.draw()
                }

                cameraHelper.update(delta: delta)

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}
