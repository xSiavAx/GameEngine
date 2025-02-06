import Foundation
import simd

extension SIMD3 where Scalar: ExpressibleByIntegerLiteral {
    static var oX: Self { Self(1, 0, 0) }
    static var oY: Self { Self(0, 1, 0) }
    static var oZ: Self { Self(0, 0, 1) }
}

extension SIMD3 where Scalar: FloatORDouble {
    var lengthSquared: Scalar { Scalar.len_squared(self) }

    static var right: Self { .oX }
    static var left: Self { -.oX }
    static var up: Self { .oY }
    static var down: Self { -.oY }
    static var frontR: Self { -.oZ }
    static var backR: Self { .oZ }
    static var frontL: Self { -.frontR }
    static var backL: Self { -.backR }

    var normalized: Self {
        Scalar.normalize(self)
    }
}

protocol FloatORDouble: SIMDScalar, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, FloatingPoint, Decodable, Encodable {
    static func len_squared(_ x: SIMD3<Self>) -> Self
    static func normalize(_ x: SIMD3<Self>) -> SIMD3<Self>
}

extension Float: FloatORDouble {
    static func len_squared(_ x: SIMD3<Float>) -> Float {
        length_squared(x)
    }

    static func normalize(_ x: SIMD3<Float>) -> SIMD3<Float> {
        simd_normalize(x)
    }
}

extension Double: FloatORDouble {
    static func len_squared(_ x: SIMD3<Double>) -> Double {
        length_squared(x)
    }

    static func normalize(_ x: SIMD3<Double>) -> SIMD3<Double> {
        simd_normalize(x)
    }
}
