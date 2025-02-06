import simd
import Foundation

extension float4x4: @retroactive @unchecked Sendable {
    static let identity = float4x4(1)

    static func perspective(fovy: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
        let yScale = 1 / tan(fovy * Float(0.5))
        let xScale = yScale / aspect
        let zRange = far - near
        let zScale = -(far + near) / zRange
        let wzScale = -2 * far * near / zRange

        return float4x4(
            SIMD4(xScale, 0, 0, 0), //col, not row
            SIMD4(0, yScale, 0, 0),
            SIMD4(0, 0, zScale, -1),
            SIMD4(0, 0, wzScale, 0)
        )
    }


    func translated(by translation: SIMD3<Float>) -> float4x4 {
        return Self.translation(translation) * self
    }

    static func translation(_ translation: SIMD3<Float>) -> float4x4 {
        var result = float4x4(1)

        result.columns.3 = SIMD4(translation.x, translation.y, translation.z, 1)

        return result
    }

    func scaled(by scale: SIMD3<Float>) -> float4x4 {
        return Self.scale(scale) * self
    }

    static func scale(_ scale: SIMD3<Float>) -> float4x4 {
        var result = float4x4(1)

        result[0, 0] = scale.x
        result[1, 1] = scale.y
        result[2, 2] = scale.z

        return result
    }

    func rotated(by angle: Float, around vector: SIMD3<Float>) -> float4x4 {
        return rotated(by: angle, axis: vector.normalized)
    }

    func rotated(by angle: Float, axis: SIMD3<Float>) -> float4x4 {
        return Self.rotation(angle: angle, axis: axis) * self
    }

    static func rotation(angle: Float, around vector: SIMD3<Float>) -> float4x4 {
        return rotation(angle: angle, axis: vector.normalized)
    }

    static func rotation(angle: Float, axis: SIMD3<Float>) -> float4x4 {
        let rotation = simd_quatf(angle: angle, axis: axis)
        return float4x4(rotation)
    }

    func transformed(by transform: float4x4) -> float4x4 {
        return transform * self
    }

    static func look(at target: SIMD3<Float>, from eye: SIMD3<Float>, up: SIMD3<Float> = SIMD3(0, 1, 0)) -> float4x4 {
        let zAxis = simd_normalize(eye - target)
        let xAxis = simd_normalize(simd_cross(up, zAxis))
        let yAxis = simd_cross(zAxis, xAxis)

        let translation = SIMD3<Float>(
            -simd_dot(xAxis, eye),
            -simd_dot(yAxis, eye),
            -simd_dot(zAxis, eye)
        )

        return float4x4(
            SIMD4(xAxis.x, yAxis.x, zAxis.x, 0),
            SIMD4(xAxis.y, yAxis.y, zAxis.y, 0),
            SIMD4(xAxis.z, yAxis.z, zAxis.z, 0),
            SIMD4(translation.x, translation.y, translation.z, 1)
        )
    }
}
