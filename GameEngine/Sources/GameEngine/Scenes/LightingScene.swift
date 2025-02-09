final class LightingScene: Scene {
    let vao = VertexArraySingle()
    var drawHelper: ModelHelper?
    let subject = AnyModel(freeTransform: FreeTransform(position: .zero))
    let lamp = AnyModel(freeTransform: FreeTransform(position: .init(x: 2, y: 2, z: -2)))
    private let cameraHelper = CameraHelper(transform: LookAtTransform(position: .zero, front: .frontR))

    func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
        drawHelper = try TexturedCubeModelHelper(shaderProgram: shaderProgram)

        try cameraHelper.config(shaderProgram: shaderProgram, viewPort: context.$viewPort)
        cameraHelper.bindInput(window.inputProcessor)

        bindDrawData()
    }
    
    func draw(delta: Float) throws {
        try drawHelper?.draw(models: [subject, lamp]) {
            try vao.draw()
        }
        cameraHelper.update(delta: delta)
    }

    private func bindDrawData() {
        guard let drawHelper else { return assertionFailure("Drawer not found") }

        vao.bind { vaoName in
            vaoName.setDrawer(drawHelper.bind())
        }
    }
}
