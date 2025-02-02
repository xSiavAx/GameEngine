import simd
import OpenCombineShim

final class CameraHelper {
    let control = CameraControl()
    @Published
    var transform = FreeTransform()

    private var bag = Set<AnyCancellable>()

    init(transform: FreeTransform) {
        self.transform = transform
    }

    func config(shaderProgram: ShaderProgram) throws {
        // TODO: Do same trick in CubeModelHelper
        let viewUniform = try shaderProgram.getUniform(name: "view") as Uniform<float4x4>

        $transform.sink { viewUniform.bind($0()) }.store(in: &bag)
    }

    func update(delta: Float) {
        switch control.update(delta: delta) {
            case .transform(let delta):
                transform += delta
            case .reset(let initial):
                transform = initial
            case .none:
                break
        }
    }
}

final class CameraControl {
    enum Update {
        case transform(FreeTransform)
        case reset(FreeTransform)
    }
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

    func update(delta: Float) -> Update? {
        var move = SIMD3<Float>(repeating: 0)

        guard !input.isEmpty else { return nil }

        guard !input.contains(.reset) else { return .reset(FreeTransform()) }

        if input.contains(.moveForward) {
            move.z += 1
        }
        if input.contains(.moveBackward) {
            move.z -= 1
        }
        if input.contains(.moveRight) {
            move.x -= 1
        }
        if input.contains(.moveLeft) {
            move.x += 1
        }
        if input.contains(.moveUp) {
            move.y += 1
        }
        if input.contains(.moveDown) {
            move.y -= 1
        }
        return .transform(FreeTransform(position: move * delta * moveSpeed))
    }
    

    func bindInput(_ processor: InputProcessor) {
        func map(key: InputProcessor.Key, input: Input) {
            processor
                .addObserver(key: key, event: .keyUp) { [weak self] in self?.input.remove(input) }
                .store(in: &keysBag)
            processor
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
