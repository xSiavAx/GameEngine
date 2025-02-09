import OpenCombineShim
import simd

final class RotatingCubesScene: Scene {
    let vao = VertexArraySingle()
    var drawHelper: ModelHelper?
    private var cubes = cubePositions.map { AnyModel(freeTransform: FreeTransform(position: $0)) }
    private let cameraHelper = CameraHelper(transform: LookAtTransform(position: .zero, front: .frontR))

    @Published
    private var time: Double = 0
    private var bag = Set<AnyCancellable>()

    func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
        drawHelper = try TexturedCubeModelHelper(shaderProgram: shaderProgram)

        try cameraHelper.config(shaderProgram: shaderProgram, viewPort: context.$viewPort)
        cameraHelper.bindInput(window.inputProcessor)
        
        bindRotationOverTime()
        bindDrawData()
        try shaderProgram.modeUniform().bind(.texture)
    }
    
    func draw(delta: Float) throws {
        time = GLTime.now

        try drawHelper?.draw(models: cubes) {
            try vao.draw()
        }
        cameraHelper.update(delta: delta)
    }

    private func bindRotationOverTime() {
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
    }

    private func bindDrawData() {
        guard let drawHelper else { return assertionFailure("Drawer not found") }

        vao.bind { vaoName in
            vaoName.setDrawer(drawHelper.bind())
        }
    }

    private static let cubePositions = [
        SIMD3<Float>(0.0, 0.0, 0.0),
        SIMD3<Float>(2.0, 5.0, -15.0),
        SIMD3<Float>(-1.5, -2.2, -2.5),
        SIMD3<Float>(-3.8, -2.0, -12.3),
        SIMD3<Float>(2.4, -0.4, -3.5),
        SIMD3<Float>(-1.7, 3.0, -7.5),
        SIMD3<Float>(1.3, -2.0, -2.5),
        SIMD3<Float>(1.5, 2.0, -2.5),
        SIMD3<Float>(1.5, 0.2, -1.5),
        SIMD3<Float>(-1.3, 1.0, -1.5)
    ]
}
