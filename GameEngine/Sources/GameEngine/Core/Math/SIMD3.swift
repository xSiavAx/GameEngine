import Foundation
import simd

extension SIMD3 where Scalar: ExpressibleByIntegerLiteral {
    static var oX: Self { Self(1, 0, 0) }
    static var oY: Self { Self(0, 1, 0) }
    static var oZ: Self { Self(0, 0, 1) }
}

extension SIMD3 where Scalar: FloatORDouble {
    var lengthSquared: Scalar { Scalar.len_squared(self) }

    var normalizedIfNot: Self {
        let squared = lengthSquared
        let tolerance: Scalar = 0.00001

        if squared < tolerance || abs(squared - 1) < tolerance  {
            return self
        }
        return self / sqrt(squared)
    }
}

protocol FloatORDouble: SIMDScalar, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, FloatingPoint, Decodable, Encodable {
    static func len_squared(_ x: SIMD3<Self>) -> Self
}

extension Float: FloatORDouble {
    static func len_squared(_ x: SIMD3<Float>) -> Float {
        length_squared(x)
    }
}

extension Double: FloatORDouble {
    static func len_squared(_ x: SIMD3<Double>) -> Double {
        length_squared(x)
    }
}
