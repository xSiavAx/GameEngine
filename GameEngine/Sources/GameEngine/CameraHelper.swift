import simd
import OpenCombineShim
import Foundation

final class CameraHelper {
    private let control = CameraControl()

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

    func bindInput(_ processor: InputProcessor) {
        control.bindInput(processor) { [weak self] in self?.transform }
    }

    func update(delta: Float) {
        control.update(transform: &transform, delta: delta)
    }
}


private final class CameraControl {
    var isCapturingMouse: Bool { rotation != nil }
    private var rotation: CameraRotation?
    private var input: Input = .empty
    var moveSpeed: Float = 20.0
    var sense: Float = 0.1
    
    private var keysBag = Set<AnyCancellable>()

    func update(transform: inout LookAtTransform, delta: Float) {
        guard !input.contains(.reset) else { return transform = LookAtTransform() }
        var move = SIMD3<Float>(repeating: 0)
        
        if !input.isEmpty { // TODO: Move to "CameraMove"
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
        }
        transform.position += move * delta * moveSpeed
        rotation?.update(transform: &transform, sense: sense)
    }
    
    func bindInput(_ processor: InputProcessor, getCurrentTransform: @escaping () -> LookAtTransform?) {
        func map(key: InputProcessor.Buttons.Key, input: Input) {
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

        processor.buttons
            .addObserver(key: .F, event: .keyUp) { [weak self, weak processor] in
                guard let self else { return }
                if isCapturingMouse {
                    processor?.mouse.set(mode: .normal)
                    rotation = nil
                } else {
                    if let transform = getCurrentTransform() {
                        processor?.mouse.set(mode: .disabled)
                        rotation = CameraRotation(initialTransform: transform)
                    }
                }
            }
            .store(in: &keysBag)

        processor.mouse
            .observeCursor { [weak self] x, y in
                self?.rotation?.updateCursor(x: x, y: y)
            }
            .store(in: &keysBag)
    }
}

extension CameraControl {
    private final class CameraRotation {
        private var yaw: Float
        private var pitch: Float
        private var posDelta = SIMD2<Float>.zero
        private var capturedMouseDelta = CapturedMouseDelta()

        init(initialTransform: LookAtTransform) {
            let front = initialTransform.front

            yaw = atan2(front.z, front.x).asDegrees
            pitch = asin(front.y).asDegrees
        }

        func updateCursor(x: Double, y: Double) {
            capturedMouseDelta.update(x: x, y: y).flatMap {
                posDelta += $0
            }
        }

        func update(transform: inout LookAtTransform, sense: Float) {
            guard posDelta != .zero else { return }            
            defer { posDelta = .zero }

            updateYawAndPitch(sense: sense)
            transform.front = makeDirection()
        }

        private func updateYawAndPitch(sense: Float) {
            let posDelta = sense * posDelta

            yaw += posDelta.x
            pitch = Self.clamped(pitch: pitch - posDelta.y)
        }

        private func makeDirection() -> SIMD3<Float> {
            let radYaw = Float.degrees(yaw)
            let radPitch = Float.degrees(pitch)
            return SIMD3(
                cos(radYaw) * cos(radPitch),
                sin(radPitch),
                sin(radYaw) * cos(radPitch)
            ).normalized
        }

        private static func clamped(pitch: Float) -> Float {
            if pitch > 89 { return 89 }
            if pitch < -89 { return -89 }
            return pitch
        }
    }

    private struct CapturedMouseDelta {
        private var last: SIMD2<Float>?

        mutating func update(x: Double, y: Double) -> SIMD2<Float>? {
            let new = SIMD2(Float(x), Float(y))

            defer { last = new }
            return last.flatMap { new - $0 }
        }
    }
}

extension CameraControl {
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
}
