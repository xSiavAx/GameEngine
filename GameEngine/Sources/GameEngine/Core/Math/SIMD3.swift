import Foundation

extension SIMD3 where Scalar: ExpressibleByIntegerLiteral {
    static var oX: Self { Self(1, 0, 0) }
    static var oY: Self { Self(0, 1, 0) }
    static var oZ: Self { Self(0, 0, 1) }
}
