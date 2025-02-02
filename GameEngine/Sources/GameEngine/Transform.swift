import simd

protocol Transform: Sendable {
    func callAsFunction() -> float4x4
}

struct LookAtATransform: Transform {
    var positon: SIMD3<Float>
    var target: SIMD3<Float>
    var up: SIMD3<Float>

    init(
        positon: SIMD3<Float> = .zero, 
        target: SIMD3<Float> = .oZ, 
        up: SIMD3<Float> = .oY
    ) {
        self.positon = positon
        self.target = target
        self.up = up
    }

    func callAsFunction() -> float4x4 {
        return .look(at: target, from: positon, up: up)
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
