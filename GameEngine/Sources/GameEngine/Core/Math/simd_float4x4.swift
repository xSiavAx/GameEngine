import simd

extension simd_float4x4 {
    init(
        _ a1: Float, _ a2: Float, _ a3: Float, _ a4: Float,
        _ b1: Float, _ b2: Float, _ b3: Float, _ b4: Float,
        _ c1: Float, _ c2: Float, _ c3: Float, _ c4: Float,
        _ d1: Float, _ d2: Float, _ d3: Float, _ d4: Float
    ) {
        self.init(
            SIMD4(a1, a2, a3, a4),
            SIMD4(b1, b2, b3, b4),
            SIMD4(c1, c2, c3, c4),
            SIMD4(d1, d2, d3, d4)
        )
    }

    func translated(by translation: SIMD3<Float>) -> simd_float4x4 {
        return self * Self.translation(translation)
    }

    func rotated(by angle: Float, around axis: SIMD3<Float>) -> simd_float4x4 {
        return self * Self.rotation(angle, around: axis)
    }

    func scaled(by scale: SIMD3<Float>) -> simd_float4x4 {
        return self * Self.scale(scale)
    }

    static func scale(_ scale: SIMD3<Float>) -> simd_float4x4 {
        var result = simd_float4x4(1)

        result[0, 0] = scale.x
        result[1, 1] = scale.y
        result[2, 2] = scale.z

        return result
    }

    static func rotation(_ angle: Float, around axis: SIMD3<Float>) -> simd_float4x4 {
        let rotation = simd_quatf(angle: angle, axis: axis)
        return simd_float4x4(rotation)
    }

    static func translation(_ translation: SIMD3<Float>) -> simd_float4x4 {
        var result = simd_float4x4(1)

        result.columns.3 = SIMD4(translation.x, translation.y, translation.z, 1)

        return result
    }
}
