import simd
import OpenCombineShim

final class CameraHelper {
    private let control = CameraControl()

    @Published
    var transform = LookAtTransform()

    private var bag = Set<AnyCancellable>()

    init(transform: LookAtTransform) {
        self.transform = transform
    }

    func config(shaderProgram: ShaderProgram) throws {
        let viewUniform = try shaderProgram.getUniform(name: "view") as Uniform<float4x4>

        $transform.sink { viewUniform.bind($0()) }.store(in: &bag)
    }

    func bindInput(_ processor: InputProcessor) {
        control.bindInput(processor) { [weak self] in self?.transform }
    }

    func update(delta: Float) {
        control.update(transform: &transform, delta: delta)
    }
}
