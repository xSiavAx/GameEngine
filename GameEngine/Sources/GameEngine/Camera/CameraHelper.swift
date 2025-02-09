import simd
import OpenCombineShim

final class CameraHelper {
    private let control = FreeCameraControl()

    @Published
    var transform = LookAtTransform()

    @Published
    var projectionMatrix: float4x4 = .identity

    var fov: Published<Float>.Publisher { control.$fov }

    private var bag = Set<AnyCancellable>()

    init(transform: LookAtTransform) {
        self.transform = transform
    }

    func config(shaderProgram: ShaderProgram, viewPort: Published<ISize>.Publisher) throws {
        let viewUniform = try shaderProgram.getUniform(name: "view") as Uniform<float4x4>
        let projectionUniform = try shaderProgram.getUniform(name: "projection") as Uniform<float4x4>

        viewPort
            .combineLatest(fov)
            .map { size, fov in
                let aspectRatio = Float(size.width) / Float(size.height)

                return float4x4.perspective(
                    fovy: .degrees(45 * fov), 
                    aspect: aspectRatio, 
                    near: 0.1, 
                    far: 100
                ) 
            }
            .assign(to: &$projectionMatrix)

        $transform.sink { viewUniform.bind($0()) }.store(in: &bag)
        $projectionMatrix
            .sink { projectionUniform.bind($0) }
            .store(in: &bag)
        
    }

    func bindInput(_ processor: InputProcessor) {
        control.bindInput(processor) { [weak self] in self?.transform }
    }

    func update(delta: Float) {
        control.update(transform: &transform, delta: delta)
    }
}
