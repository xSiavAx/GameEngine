final class LightingScene: Scene {
    final class Light: Scene {
        let vao = VertexArraySingle()
        var drawHelper: ModelHelper?
        let model = AnyModel(freeTransform: FreeTransform(
            position: .init(x: 1.2, y: 1, z: 2),
            scale: .init(repeating: 0.2)
        ))
        var modeUniform: Uniform<ShaderMode>?

        func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
            drawHelper = try ColorCubeModelHelper(shaderProgram: shaderProgram, color: .white)
            modeUniform = try shaderProgram.modeUniform()

            bindDrawData()
        }

        func draw(delta: Float) throws {
            modeUniform?.set(.light)
            try drawHelper?.draw(models: [model]) {
                try vao.draw()
            }
        }

        private func bindDrawData() {
            guard let drawHelper else { return assertionFailure("Drawer not found") }
            
            vao.bind { vaoName in
                vaoName.setDrawer(drawHelper.bind())
            }
        }
    }

    final class Subject: Scene {
        let vao = VertexArraySingle()
        var drawHelper: ModelHelper?
        let model = AnyModel(freeTransform: FreeTransform(position: .zero))
        var modeUniform: Uniform<ShaderMode>?

        func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
            drawHelper = try ColorCubeModelHelper(shaderProgram: shaderProgram, color: .coral)
            modeUniform = try shaderProgram.modeUniform()

            bindDrawData()
        }

        func draw(delta: Float) throws {
            modeUniform?.set(.color)
            try drawHelper?.draw(models: [model]) {
                try vao.draw()
            }
        }

        private func bindDrawData() {
            guard let drawHelper else { return assertionFailure("Drawer not found") }

            vao.bind { vaoName in
                vaoName.setDrawer(drawHelper.bind())
            }
        }
    }
    
    let light = Light()
    let subject = Subject()
    private let cameraHelper = CameraHelper(transform: LookAtTransform(position: .zero, front: .frontR))

    func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
        try cameraHelper.config(shaderProgram: shaderProgram, viewPort: context.$viewPort)
        cameraHelper.bindInput(window.inputProcessor)

        try light.prepare(context: context, window: window, shaderProgram: shaderProgram)
        try subject.prepare(context: context, window: window, shaderProgram: shaderProgram)

        try shaderProgram.getUniform(name: "lightColor").set(Color.white.rgbVector)
    }
    
    func draw(delta: Float) throws {
        try light.draw(delta: delta)
        try subject.draw(delta: delta)
        cameraHelper.update(delta: delta)
    }
}
