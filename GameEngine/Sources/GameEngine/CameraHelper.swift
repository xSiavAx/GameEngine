import simd
import OpenCombineShim

final class CameraHelper {
    let control = CameraControl()
    @Published
    var transform = LookAtTransform()

    private var bag = Set<AnyCancellable>()

    init(transform: LookAtTransform) {
        self.transform = transform
    }

    func config(shaderProgram: ShaderProgram) throws {
        // TODO: Do same trick in CubeModelHelper
        let viewUniform = try shaderProgram.getUniform(name: "view") as Uniform<float4x4>

        $transform.sink { viewUniform.bind($0()) }.store(in: &bag)
    }

    func update(delta: Float) {
        control.update(transform: &transform, delta: delta)
    }
}

final class CameraControl {
    private struct Input: OptionSet {
        let rawValue: Int

        static let moveForward = Input(rawValue: 1 << 0)
        static let moveBackward = Input(rawValue: 1 << 1)
        static let moveLeft = Input(rawValue: 1 << 2)
        static let moveRight = Input(rawValue: 1 << 3)
        static let moveUp = Input(rawValue: 1 << 4)
        static let moveDown = Input(rawValue: 1 << 5)

        static let reset = Input(rawValue: 1 << 30)

        static let empty = Input([])
    }

    private var input: Input = .empty
    var moveSpeed: Float = 20.0
    private var keysBag = Set<AnyCancellable>()

    func update(transform: inout LookAtTransform, delta: Float) {
        guard !input.isEmpty else { return }
        guard !input.contains(.reset) else { return transform = LookAtTransform() }
        var move = SIMD3<Float>(repeating: 0)
        
        if input.contains(.moveForward) {
            move += transform.front
        }
        if input.contains(.moveBackward) {
            move -= transform.front
        }
        if input.contains(.moveRight) {
            move += transform.right
        }
        if input.contains(.moveLeft) {
            move -= transform.right
        }
        if input.contains(.moveUp) {
            move += transform.up
        }
        if input.contains(.moveDown) {
            move -= transform.up
        }
        transform.position += move * delta * moveSpeed
    }
    

    func bindInput(_ processor: InputProcessor) {
        func map(key: InputProcessor.Key, input: Input) {
            processor.buttons
                .addObserver(key: key, event: .keyUp) { [weak self] in self?.input.remove(input) }
                .store(in: &keysBag)
            processor.buttons
                .addObserver(key: key, event: .keyDown) { [weak self] in self?.input.insert(input) }
                .store(in: &keysBag)
        }
        map(key: .W, input: .moveForward)
        map(key: .S, input: .moveBackward)
        map(key: .A, input: .moveLeft)
        map(key: .D, input: .moveRight)
        map(key: .E, input: .moveUp)
        map(key: .Q, input: .moveDown)
        map(key: .R, input: .reset)
    }
}
