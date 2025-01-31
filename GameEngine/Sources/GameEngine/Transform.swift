import simd

struct Transform {
    var position: SIMD3<Float>
    var rotation: float4x4
    var scale: SIMD3<Float>

    init(
        position: SIMD3<Float> = .zero,
        rotation: float4x4 = .identity, 
        scale: SIMD3<Float> = .one
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }

    func callAsFunction() -> float4x4 {
        return .identity
            .scaled(by: scale)
            .transformed(by: rotation)
            .translated(by: position)
        // return .translation(position) * rotation * .scale(scale)
    }

    static func + (lhs: Transform, rhs: Transform) -> Transform {
        var result = lhs

        result.position += rhs.position
        result.rotation = lhs.rotation.transformed(by: rhs.rotation)
        result.scale *= rhs.scale

        return result
    }

    static func += (lhs: inout Transform, rhs: Transform) {
        lhs = lhs + rhs    
    }
}
