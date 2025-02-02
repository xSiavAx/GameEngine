import simd

protocol Transform: Sendable {
    func callAsFunction() -> float4x4
}

struct LookAtTransform: Transform {
    var position: SIMD3<Float>
    var front: SIMD3<Float>
    var up: SIMD3<Float>

    var right: SIMD3<Float> { simd_cross(front, up) }

    init(
        position: SIMD3<Float> = .zero, 
        front: SIMD3<Float> = .frontR, 
        up: SIMD3<Float> = .oY
    ) {
        self.position = position
        self.front = front
        self.up = up
    }

    func callAsFunction() -> float4x4 {
        return .look(at: position + front, from: position, up: up)
    }

    static func + (lhs: LookAtTransform, rhs: LookAtTransform) -> LookAtTransform {
        var result = lhs

        result.position += rhs.position
        // result.rotation = lhs.rotation * rhs.rotation
        // result.scale *= rhs.scale

        return result
    }

    static func += (lhs: inout LookAtTransform, rhs: LookAtTransform) {
        lhs = lhs + rhs    
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
