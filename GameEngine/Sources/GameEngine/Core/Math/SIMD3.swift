import Foundation
import simd

extension SIMD3 where Scalar: ExpressibleByIntegerLiteral {
    static var oX: Self { Self(1, 0, 0) }
    static var oY: Self { Self(0, 1, 0) }
    static var oZ: Self { Self(0, 0, 1) }
}

extension SIMD3 where Scalar: FloatORDouble {
    var lengthSquared: Scalar { Scalar.len_squared(self) }

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
