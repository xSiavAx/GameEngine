import simd

protocol Transform: Sendable {
    func callAsFunction() -> float4x4
}

struct LookAtTransform: Transform {
    let worldUp: SIMD3<Float>

    var position: SIMD3<Float>
    var front: SIMD3<Float> {
        didSet {
            right = Self.makeRight(front: front, worldUp: worldUp)
            up = Self.makeUp(right: right, front: front)
        }
    }
    private(set) var up: SIMD3<Float>
    var right: SIMD3<Float>

    init(
        position: SIMD3<Float> = .zero, 
        front: SIMD3<Float> = .frontR, 
        worldUp: SIMD3<Float> = .oY
    ) {
        let right = Self.makeRight(front: front, worldUp: worldUp)

        self.position = position
        self.front = front
        self.worldUp = worldUp
        self.right = right
        self.up = Self.makeUp(right: right, front: front)
    }

    private static func makeRight(front: SIMD3<Float>, worldUp: SIMD3<Float>) -> SIMD3<Float> {
        simd_cross(front, worldUp).normalized
    }

    private static func makeUp(right: SIMD3<Float>, front: SIMD3<Float>) -> SIMD3<Float> {
        simd_cross(right, front).normalized
    }

    func callAsFunction() -> float4x4 {
        return .look(at: position + front, from: position, up: up)
    }
}

struct FreeTransform: Transform {
    var position: SIMD3<Float>
    var rotation: simd_quatf
    var scale: SIMD3<Float>

    init(
        position: SIMD3<Float> = .zero,
        rotation: simd_quatf = simd_quatf(real: 1, imag: .zero), 
        scale: SIMD3<Float> = .one
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }

    func callAsFunction() -> float4x4 {
        return .identity
            .scaled(by: scale)
            .transformed(by: float4x4(rotation))
            .translated(by: position)
    }

    static func + (lhs: FreeTransform, rhs: FreeTransform) -> FreeTransform {
        var result = lhs

        result.position += rhs.position
        result.rotation = lhs.rotation * rhs.rotation
        result.scale *= rhs.scale

        return result
    }

    static func += (lhs: inout FreeTransform, rhs: FreeTransform) {
        lhs = lhs + rhs    
    }
}
