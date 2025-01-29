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

    func runLoop() throws {
        
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
        @Published
        var modelMatrix: simd_float4x4 = .identity
        @Published
        var viewMatrix: simd_float4x4 = .identity.translated(by: SIMD3(0, 0, -3))
        @Published
        var projectionMatrix: simd_float4x4 = .identity
        var textures = [Texture]()

        @Published
        private var time = 0.0
        private var bag = Set<AnyCancellable>()

        init(context: Context, window: Window) throws {
            self.context = context
            self.window = window

            try prepare()
            try run()
        }

        func prepare() throws {

            let vertices = MyVertex.cubeVertices
            // [
            //     MyVertex(
            //         coords: .init(x: 0.5, y: 0.5, z: 0),
            //         color: .init(x: 1, y: 0, z: 0),
            //         texture: .init(1, 1)
            //     ),  // top right
            //     MyVertex(
            //         coords: .init(x: 0.5, y: -0.5, z: 0),
            //         color: .init(x: 0, y: 1, z: 0),
            //         texture: .init(1, 0)
            //     ),  // bottom right
            //     MyVertex(
            //         coords: .init(x: -0.5, y: -0.5, z: 0.0),
            //         color: .init(x: 0, y: 0, z: 1),
            //         texture: .init(0, 0)
            //     ),  // bottom left
            //     MyVertex(
            //         coords: .init(x: -0.5, y: 0.5, z: 0.0),
            //         color: .init(x: 1, y: 1, z: 1),
            //         texture: .init(0, 1)
            //     )   // top left 
            // ]
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

            let modelUniform = try shaderProgram.getUniform(name: "model") as Uniform<simd_float4x4>
            let viewUniform = try shaderProgram.getUniform(name: "view") as Uniform<simd_float4x4>
            let projectionUniform = try shaderProgram.getUniform(name: "projection") as Uniform<simd_float4x4>

            context.$viewPort
                .map { size in Float(size.width / size.height)  }
                .map { 
                    simd_float4x4.perspective(
                        fovy: .degrees(45), 
                        aspect: $0, 
                        near: 0.1, 
                        far: 100
                    ) 
                }
                .assign(to: &$projectionMatrix)

            $time
                .map { time in
                    .identity.rotated(by: Float(time) * .degrees(50), around: SIMD3(0.5, 1, 0))
                }
                .assign(to: &$modelMatrix)

            $modelMatrix
                .sink { modelUniform.bind($0) }
                .store(in: &bag)
            
            $viewMatrix
                .sink { viewUniform.bind($0) }
                .store(in: &bag)

            $projectionMatrix
                .sink { projectionUniform.bind($0) }
                .store(in: &bag)

            vao.bind { vaoName in
                vbo.bind { buffer in
                    buffer.add(vertices: vertices, usage: .staticDraw)

                    MyVertex.linkAttributes(shouldNormilize: false) { location, attributeType in
                        attributeType.enable(location: location)
                    }
                    vaoName.setDrawer(ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count))
                }
                // ebo.bind { buffer in
                //     buffer.add(indices, usage: .staticDraw)
                //     vaoName.setDrawer(ElementsVertexArrayDrawer<UInt32>(mode: .triangles, count: indices.count))
                // }
            }
        }

        func run() throws {
            while !window.shouldClose() {
                try context.processInput()
                context.clear(color: .limedSpruce)

                shaderProgram.use()
                time = GLTime.now
                try textures.withBind {
                    try vao.draw()
                }

                window.swapBuffers()
                context.pollEvents()
            }
        }
    }
}

extension MyVertex {
    static let cubeVertices: [MyVertex] = [
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),

        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y: -0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),

        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 1.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x:  0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(1.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z:  0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 0.0)),
        MyVertex(coords: .init(x: -0.5, y:  0.5, z: -0.5), color: .init(x: 1, y: 1, z: 1), texture: .init(0.0, 1.0))
    ]
}